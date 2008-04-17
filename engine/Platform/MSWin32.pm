# POPFILE LOADABLE MODULE 4
package Platform::MSWin32;

use POPFile::Module;
@ISA = ("POPFile::Module");

#----------------------------------------------------------------------------
#
# This module handles POPFile specifics on Windows
#
# Copyright (c) 2001-2006 John Graham-Cumming
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

    $self->config_( 'trayicon', 1 );
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

    my ( $status_message );

    if ( $name eq 'windows_trayicon_and_console' ) {

        if ( defined( $$form{update_windows_configuration} ) ) {
            if ( $$form{windows_trayicon} ) {
                $self->config_( 'trayicon', 1 );
            } else {
                $self->config_( 'trayicon', 0 );
            }

            if ( $$form{windows_console} ) {
                $self->config_( 'console', 1 );
            } else {
                $self->config_( 'console', 0 );
            }

            $status_message = $$language{Windows_NextTime};
        }
    }

   return ( $status_message, undef );
}

1;
