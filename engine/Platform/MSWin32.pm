# POPFILE LOADABLE MODULE
package Platform::MSWin32;

use POPFile::Module;
@ISA = ("POPFile::Module");

#----------------------------------------------------------------------------
#
# This module handles POPFile specifics on Windows
#
# Copyright (c) 2001-2008 John Graham-Cumming
#
#   This file is part of POPFile
#
#   POPFile is free software; you can redistribute it and/or modify it
#   under the terms of version 2 of the GNU General Public License as
#   published by the Free Software Foundation.
#
#   POPFile is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with POPFile; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
#----------------------------------------------------------------------------

use strict;
use warnings;
use locale;

#----------------------------------------------------------------------------
# new
#
#   Class new() function
#----------------------------------------------------------------------------
sub new
{
    my $type = shift;
    my $class = ref($type) || $type;
    my $self = POPFile::Module->new();

    bless $self, $type;

    $self->name( 'windows' );

    $self->{use_tray_icon__} = 0;

    return $self;
}

# ----------------------------------------------------------------------------
#
# initialize
#
# Called when we are are being set up but before starting
#
# ----------------------------------------------------------------------------
sub initialize
{
    my ( $self ) = @_;

    $self->config_( 'trayicon', 0 );
    $self->config_( 'console',  0 );

    return 1;
}

# ----------------------------------------------------------------------------
#
# start
#
# Called when all configuration information has been loaded from disk.
#
# The method should return 1 to indicate that it started correctly, if
# it returns 0 then POPFile will abort loading immediately, returns 2
# if everything OK but this module does not want to continue to be
# used.
#
# ----------------------------------------------------------------------------

sub start
{
    my ( $self ) = @_;

    $self->register_configuration_item_( 'configuration',
                                         'windows_trayicon_and_console',
                                         'windows-configuration.thtml',
                                         $self );

    # Now try to cleanup a mess that PerlApp/PerlTray might have left
    # behind in the $TEMP.  For some reason even though we build with
    # --clean it leaves behind empty directories in the TEMP directory
    # in the form $TEMP/pdk-USER-PID
    #
    # We try to delete everything that is in that form but does not have 
    # our PID

    my $pdk = $ENV{TEMP} . "/pdk-" . Win32::LoginName() . "-*";
    $pdk =~ s/ /?/g;

    my @temp = glob $pdk;

    foreach my $dir (@temp) {
        if ( $dir =~ /pdk\-.+\-(\d+)$/ ) {
   	        if ( $$ != $1 ) {
                rmdir $dir;
	        }
        }
    }

    return $self->SUPER::start();
}

# ----------------------------------------------------------------------------
#
# prefork
#
# This is called when this module is about to fork POPFile
#
# There is no return value from this method
#
# ----------------------------------------------------------------------------
sub prefork
{
    my ( $self ) = @_;

    # If the trayicon is on, temporarily disable trayicon to avoid crash

    if ( $self->{use_tray_icon__} ) {
        $self->dispose_trayicon();
    }
}

# ----------------------------------------------------------------------------
#
# postfork
#
# This is called when this module has just forked POPFile.  It is
# called in the parent process.
#
# $pid The process ID of the new child process $reader The reading end
#      of a pipe that can be used to read messages from the child
#
# There is no return value from this method
#
# ----------------------------------------------------------------------------
sub postfork
{
    my ( $self, $pid, $reader ) = @_;

    # If the trayicon is on, recreate the trayicon

    # When the forked (pseudo-)child process exits, the Win32::GUI objects
    # (Windows, Menus, etc.) seem to be purged. So we have to recreate the
    # trayicon.

    if ( $self->{use_tray_icon__} ) {
        $self->prepare_trayicon();
    }
}

# ----------------------------------------------------------------------------
#
# prepare_trayicon
#
# Create a dummy window, a trayicon and a menu, and then set a timer to the
# window.
#
# ----------------------------------------------------------------------------
sub prepare_trayicon
{
    my $self = shift;

    $self->{use_tray_icon__} = 1;

    # Create a dummy window

    $self->{trayicon_window} = Win32::GUI::Window->new();
    if ( !defined( $self->{trayicon_window} ) ) {
        $self->log_( 0, "Couldn't create a window for the trayicon" );
        die "Couldn't create a window for the trayicon.";
    }

    # Create a trayicon

    my $icon = Win32::GUI::Icon->new( $self->get_root_path_( 'trayicon.ico' ) );
    $self->{trayicon} = $self->{trayicon_window}->AddNotifyIcon(
        -name => 'NI',
        -icon => $icon,
        -tip  => 'POPFile'
    );
    if ( !defined( $self->{trayicon} ) ) {
        $self->log_( 0, "Couldn't create a trayicon" );
    }

    # Create a popup menu

    $self->{trayicon_menu} = Win32::GUI::Menu->new(
        '&POPFile'        => 'POPFile',
        '> POPFile &UI'   => { -name => 'Menu_Open_UI', -default => 1 },
        '> -'             => 0,
        '> &Quit POPFile' => { -name => 'Menu_Quit' },
    );
    if ( !defined( $self->{trayicon_menu} ) ) {
        $self->log_( 0, "Couldn't create a popup menu for the trayicon" );
    }

    # Set timer

    $self->{trayicon_window}->AddTimer( 'Poll', 250 );
}

# ----------------------------------------------------------------------------
#
# dispose_trayicon
#
# Dispose dummy window and trayicon
#
# ----------------------------------------------------------------------------
sub dispose_trayicon
{
    my ( $self ) = @_;

    if ( defined( $self->{trayicon_window} ) ) {

        # Stop timer

        if ( defined( $self->{trayicon_window}->Poll ) ) {
            $self->{trayicon_window}->Poll->Kill( 1 );
        }

        # Remove trayicon

        if ( defined( $self->{trayicon} ) ) {
            if ( $Win32::GUI::VERSION >= 1.04 ) {
                $self->{trayicon}->Remove();
            } else {
                $self->{trayicon}->Delete( -id => $self->{trayicon}->{-id} );
            }
        }

        undef $self->{trayicon};
        undef $self->{trayicon_window};
        undef $self->{trayicon_menu};
    }
}

# ----------------------------------------------------------------------------
#
# configure_item
#
#    $name            Name of this item
#    $templ           The loaded template that was passed as a parameter
#                     when registering
#    $language        Current language
#
# ----------------------------------------------------------------------------

sub configure_item
{
    my ( $self, $name, $templ, $language ) = @_;

    if ( $name eq 'windows_trayicon_and_console' ) {
        $templ->param( 'windows_icon_on' => $self->config_( 'trayicon' ) );
        $templ->param( 'windows_console_on' => $self->config_( 'console' ) );
    }
}

# ----------------------------------------------------------------------------
#
# validate_item
#
#    $name            The name of the item being configured, was passed in by the call
#                     to register_configuration_item
#    $templ           The loaded template
#    $language        The language currently in use
#    $form            Hash containing all form items
#
# ----------------------------------------------------------------------------

sub validate_item
{
    my ( $self, $name, $templ, $language, $form ) = @_;

    if ( $name eq 'windows_trayicon_and_console' ) {

        if ( defined($$form{windows_trayicon}) ) {
            $self->config_( 'trayicon', $$form{windows_trayicon} );
            $templ->param( 'trayicon_feedback' => 1 );
        }

        if ( defined($$form{windows_console}) ) {
            $self->config_( 'console', $$form{windows_console} );
            $templ->param( 'console_feedback' => 1 );
        }
    }

   return '';
}

1;
