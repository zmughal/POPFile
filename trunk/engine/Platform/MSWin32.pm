# POPFILE LOADABLE MODULE
package Platform::MSWin32;

use POPFile::Module;
@ISA = ("POPFile::Module");

use Win32::API;

#----------------------------------------------------------------------------
#
# This module handles POPFile specifics on Windows
#
# Copyright (c) 2001-2003 John Graham-Cumming
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

# ---------------------------------------------------------------------------------------------
#
# initialize
#
# Called when we are are being set up but before starting
#
# ---------------------------------------------------------------------------------------------
sub initialize
{
    my ( $self ) = @_;

    $self->config_( 'trayicon', 1 );

    $self->register_configuration_item_( 'configuration',
                                         'windows_trayicon',
                                         $self );

    return 1;
}

# ---------------------------------------------------------------------------------------------
#
# configure_item
#
#    $name            The name of the item being configured, was passed in by the call
#                     to register_configuration_item
#    $language        Reference to the hash holding the current language
#    $session_key     The current session key
#
#  Must return the HTML for this item
# ---------------------------------------------------------------------------------------------

sub configure_item
{
    my ( $self, $name, $language, $session_key ) = @_;

    my $body;

    # POP3 Listen Port widget
    if ( $name eq 'windows_trayicon' ) {
        $body .= "<span class=\"configurationLabel\">$$language{Windows_TrayIcon}:</span><br />\n";
        $body .= "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" summary=\"\"><tr><td nowrap=\"nowrap\">\n";

        if ( $self->config_( 'trayicon' ) == 0 ) {
            $body .= "<form action=\"/configuration\">\n";
            $body .= "<span class=\"securityWidgetStateOff\">$$language{No}</span>\n";
            $body .= "<input type=\"submit\" class=\"toggleOn\" id=\"windowTrayIconOn\" name=\"toggle\" value=\"$$language{ChangeToYes}\" />\n";
            $body .= "<input type=\"hidden\" name=\"windows_trayicon\" value=\"1\" />\n";
            $body .= "<input type=\"hidden\" name=\"session\" value=\"$session_key\" />\n</form>\n";
        } else {
            $body .= "<form action=\"/configuration\">\n";
            $body .= "<span class=\"securityWidgetStateOn\">$$language{Yes}</span>\n";
            $body .= "<input type=\"submit\" class=\"toggleOn\" id=\"windowTrayIconOff\" name=\"toggle\" value=\"$$language{ChangeToNo}\" />\n";
            $body .= "<input type=\"hidden\" name=\"windows_trayicon\" value=\"0\" />\n";
            $body .= "<input type=\"hidden\" name=\"session\" value=\"$session_key\" />\n</form>\n";
        }
        $body .= "</td></tr></table>\n";
    }

    return $body;
}

# ---------------------------------------------------------------------------------------------
#
# validate_item
#
#    $name            The name of the item being configured, was passed in by the call
#                     to register_configuration_item
#    $language        Reference to the hash holding the current language
#    $form            Hash containing all form items
#
#  Must return the HTML for this item
# ---------------------------------------------------------------------------------------------

sub validate_item
{
    my ( $self, $name, $language, $form ) = @_;

    if ( $name eq 'windows_trayicon' ) {
        if ( defined($$form{windows_trayicon}) ) {
            $self->config_( 'trayicon', $$form{windows_trayicon} );

            if ( $$form{windows_trayicon} == 0 ) {
                $self->{hideicon__} = Win32::API->new( "Platform/POPFileIcon.dll", "HideIcon", "", "N" );
                $self->{hideicon__}->Call();
                undef $self->{hideicon__};
	    }
        }
    }

    return '';
}

# ---------------------------------------------------------------------------------------------
#
# prefork
#
# Called when a fork is about to occur
#
# ---------------------------------------------------------------------------------------------
sub prefork
{
    my ( $self ) = @_;

    # If the fork occurs and the DLL handling the icon is still present then
    # there's going to be a problem because the DLL will get unloaded and we'll
    # still have a pointer into it, so here we unload the DLL, it will get reloaded
    # automatically later

    undef $self->{getmessage__};
}

# ---------------------------------------------------------------------------------------------
#
# service
#
# Called to handle interface requests
#
# ---------------------------------------------------------------------------------------------
sub service
{
    my ( $self ) = @_;

    if ( !$self->config_( 'trayicon' ) ) {
        return 1;
    }

    if ( !defined( $self->{getmessage__} ) ) {
        $self->{getmessage__} = Win32::API->new( "Platform/POPFileIcon.dll", "GetMenuMessage", "", "N" );
    }

    my $event = $self->{getmessage__}->Call();

    # User wants the icon hidden

    if ( $event == 3 ) {
        $self->config_( 'trayicon', 0 );

        $self->{hideicon__} = Win32::API->new( "Platform/POPFileIcon.dll", "HideIcon", "", "N" );
        $self->{hideicon__}->Call();
        undef $self->{hideicon__};

        return 1;
    }

    # Double click icon, or select Open option in menu results in
    # navigating to the UI

    if ( $event == 2 ) {

        my $execute = Win32::API->new( "Shell32", "ShellExecute", "NPPPPN", "N" );

        # Get the port that the UI is running on and then use the
        # windows start function to start the browser running

        my $url = 'http://127.0.0.1:' . $self->module_config_( 'html', 'port' );

        if ( defined( $execute ) ) {
            $execute->Call( 0, "open", $url, "", "", 0 );
	} else {
            system( "start $url" );
        }
    }

    # Exit action from try context menu - return 0, to cause exit

    if ( $event == 1 ) {
         return 0;
    }

    return 1;
}

1;
