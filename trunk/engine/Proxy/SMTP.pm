# POPFILE LOADABLE MODULE 4
package Proxy::SMTP;

use Proxy::Proxy;
@ISA = ("Proxy::Proxy");

# ----------------------------------------------------------------------------
#
# This module handles proxying the SMTP protocol for POPFile.
#
# Copyright (c) 2001-2009 John Graham-Cumming
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
# ----------------------------------------------------------------------------

use strict;
use warnings;
use locale;

# A handy variable containing the value of an EOL for networks
my $eol = "\015\012";

#----------------------------------------------------------------------------
# new
#
#   Class new() function
#----------------------------------------------------------------------------
sub new
{
    my $type = shift;
    my $self = Proxy::Proxy->new();

    # Must call bless before attempting to call any methods

    bless $self, $type;

    $self->name( 'smtp' );

    $self->{child_} = \&child__;
    $self->{connection_timeout_error_} = '554 Transaction failed';
    $self->{connection_failed_error_}  = '554 Transaction failed, can\'t connect to';
    $self->{good_response_}            = '^[23]';

    return $self;
}

# ----------------------------------------------------------------------------
#
# initialize
#
# Called to initialize the SMTP proxy module
#
# ----------------------------------------------------------------------------
sub initialize
{
    my ( $self ) = @_;

    # By default we don't fork on Windows
    $self->config_( 'force_fork', ($^O eq 'MSWin32')?0:1 );

    # Default port for SMTP service
    $self->config_( 'port', 25 );

    # Where to forward on to
    $self->config_( 'chain_server', '' );
    $self->config_( 'chain_port', 25 );

    # Only accept connections from the local machine for smtp
    $self->config_( 'local', 1 );

    # The welcome string from the proxy is configurable
    $self->config_( 'welcome_string', "SMTP POPFile ($self->{version_}) welcome" );

    if ( !$self->SUPER::initialize() ) {
        return 0;
    }

    $self->config_( 'enabled', 0 );

    return 1;
}

# ----------------------------------------------------------------------------
#
# start
#
# Called to start the SMTP proxy module
#
# ----------------------------------------------------------------------------
sub start
{
    my ( $self ) = @_;

    # If we are not enabled then no further work happens in this module

    if ( $self->config_( 'enabled' ) == 0 ) {
        return 2;
    }

    # Tell the user interface module that we having a configuration
    # item that needs a UI component

    $self->register_configuration_item_( 'configuration',   # PROFILE BLOCK START
                                         'smtp_fork_and_port',
                                         'smtp-configuration.thtml',
                                         $self );           # PROFILE BLOCK STOP

    $self->register_configuration_item_( 'security',        # PROFILE BLOCK START
                                         'smtp_local',
                                         'smtp-security-local.thtml',
                                         $self );           # PROFILE BLOCK STOP

    $self->register_configuration_item_( 'chain',           # PROFILE BLOCK START
                                         'smtp_server',
                                         'smtp-chain-server.thtml',
                                         $self );           # PROFILE BLOCK STOP

    if ( $self->config_( 'welcome_string' ) =~ /^SMTP POPFile \(v\d+\.\d+\.\d+\) welcome$/ ) { # PROFILE BLOCK START
        $self->config_( 'welcome_string', "SMTP POPFile ($self->{version_}) welcome" );        # PROFILE BLOCK STOP
    }

    return $self->SUPER::start();;
}

# ----------------------------------------------------------------------------
#
# child__
#
# The worker method that is called when we get a good connection from
# a client
#
# $client   - an open stream to a SMTP client
# $session  - administrator session
#
# ----------------------------------------------------------------------------
sub child__
{
    my ( $self, $client, $session ) = @_;

    # Number of messages downloaded in this session

    my $count = 0;

    # The handle to the real mail server gets stored here

    my $mail;

    # Tell the client that we are ready for commands and identify our
    # version number

    $self->tee_( $client, "220 " . $self->config_( 'welcome_string' ) . "$eol" );

    # Retrieve commands from the client and process them until the
    # client disconnects or we get a specific QUIT command

    while  ( <$client> ) {
        my $command;

        $command = $_;

        # Clean up the command so that it has a nice clean $eol at the end
        $command =~ s/(\015|\012)//g;

        $self->log_( 2, "Command: --$command--" );

        if ( $command =~ /HELO/i ) {
            if ( $self->config_( 'chain_server' ) )  {
                if ( $mail = $self->verify_connected_( $mail, $client, $self->config_( 'chain_server' ),  $self->config_( 'chain_port' ) ) )  {

                    $self->smtp_echo_response_( $mail, $client, $command );
                } else {
                    last;
                }
            } else {
                $self->tee_(  $client, "421 service not available$eol" );
            }

            next;
        }

        # Handle EHLO specially so we can control what ESMTP extensions are negotiated

        if ( $command =~ /EHLO/i ) {
            if ( $self->config_( 'chain_server' ) )  {
                if ( $mail = $self->verify_connected_( $mail, $client, $self->config_( 'chain_server' ),  $self->config_( 'chain_port' ) ) )  {

                    # TODO: Make this user-configurable (-smtp_add_unsupported, -smtp_remove_unsupported)

                    # Stores a list of unsupported ESMTP extensions

                    my $unsupported;

                    # RFC 1830, http://www.faqs.org/rfcs/rfc1830.html
                    # CHUNKING and BINARYMIME both require the support of the "BDAT" command
                    # support of BDAT requires extensive changes to POPFile's internals and
                    # will not be implemented at this time

                    $unsupported .= "CHUNKING|BINARYMIME|XEXCH50";

                    # append unsupported ESMTP extensions to $unsupported here, important to maintain
                    # format of OPTION|OPTION2|OPTION3

                    $unsupported = qr/250\-$unsupported/;

                    $self->smtp_echo_response_( $mail, $client, $command, $unsupported );


                } else {
                    last;
                }
            } else {
                $self->tee_(  $client, "421 service not available$eol" );
            }

            next;
        }

        if ( ( $command =~ /MAIL FROM:/i )    ||   # PROFILE BLOCK START
             ( $command =~ /RCPT TO:/i )      ||
             ( $command =~ /VRFY/i )          ||
             ( $command =~ /EXPN/i )          ||
             ( $command =~ /NOOP/i )          ||
             ( $command =~ /HELP/i )          ||
             ( $command =~ /RSET/i ) ) {           # PROFILE BLOCK STOP
            $self->smtp_echo_response_( $mail, $client, $command );
            next;
        }

        if ( $command =~ /DATA/i ) {
            # Get the message from the remote server, if there's an error then we're done, but if not then
            # we echo each line of the message until we hit the . at the end
            if ( $self->smtp_echo_response_( $mail, $client, $command ) ) {
                $count += 1;

                my ( $class, $history_file ) = $self->classifier_()->classify_and_modify( $session, $client, $mail, 0, '', 0  );

                my $response = $self->slurp_( $mail );
                $self->tee_( $client, $response );
                next;
            }
        }

        # The mail client wants to stop using the server, so send that message through to the
        # real mail server, echo the response back up to the client and exit the while.  We will
        # close the connection immediately
        if ( $command =~ /QUIT/i ) {
            if ( $mail )  {
                $self->smtp_echo_response_( $mail, $client, $command );
                close $mail;
            } else {
                $self->tee_(  $client, "221 goodbye$eol" );
            }
            last;
        }

        # Don't know what this is so let's just pass it through and hope for the best
        if ( $mail && $mail->connected )  {
            $self->smtp_echo_response_( $mail, $client, $command );
            next;
        } else {
            $self->tee_(  $client, "500 unknown command or bad syntax$eol" );
            last;
        }
    }

    if ( defined( $mail ) ) {
        $self->done_slurp_( $mail );
        close $mail;
    }

    close $client;
    $self->mq_post_( 'CMPLT', $$ );
    $self->log_( 0, "SMTP proxy done" );
}

# ----------------------------------------------------------------------------
#
# smtp_echo_response_
#
# $mail     The stream (created with IO::) to send the message to (the remote mail server)
# $client   The local mail client (created with IO::) that needs the response
# $command  The text of the command to send (we add an EOL)
# $suppress (OPTIONAL) suppress any lines that match, compile using qr/pattern/
#
# Send $command to $mail, receives the response and echoes it to the $client and the debug
# output.
#
# This subroutine returns responses from the server as defined in appendix E of
# RFC 821, allowing multi-line SMTP responses.
#
# Returns true if the initial response is a 2xx or 3xx series (as defined by {good_response_}
#
# ----------------------------------------------------------------------------
sub smtp_echo_response_
{
    my ($self, $mail, $client, $command, $suppress) = @_;
    my ( $response, $ok ) = $self->get_response_( $mail, $client, $command );

    if ( $response =~ /^\d\d\d-/ ) {
        $self->echo_to_regexp_($mail, $client, qr/^\d\d\d /, 1, $suppress);
    }
    return ( $response =~ /$self->{good_response_}/ );
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
# Returns 1 if smtp_local is 1
#
# ----------------------------------------------------------------------------

sub configure_item
{
    my ( $self, $name, $templ, $language ) = @_;

    if ( $name eq 'smtp_fork_and_port' ) {
        $templ->param( 'smtp_port'          => $self->config_( 'port' ) );
        $templ->param( 'smtp_force_fork_on' => ( $self->config_( 'force_fork' ) == 1 ) );
    }

    if ( $name eq 'smtp_local' ) {
        $templ->param( 'smtp_local_on' => $self->config_( 'local' ) );
        return $self->config_( 'local' );
     }

    if ( $name eq 'smtp_server' ) {
        $templ->param( 'smtp_chain_server' => $self->config_( 'chain_server' ) );
        $templ->param( 'smtp_chain_port' => $self->config_( 'chain_port' ) );
    }


    $self->SUPER::configure_item( $name, $templ, $language );
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

    my ($status, $error, $changed);

    if ( $name eq 'smtp_fork_and_port' ) {

        if ( defined($$form{smtp_force_fork}) ) {
            if ( $$form{smtp_force_fork} ) {
                if ( $self->config_( 'force_fork' ) ne 1 ) {
                    $self->config_( 'force_fork', 1 );
                    $status = $$language{Configuration_SMTPForkEnabled} . "\n";
                }
            } else {
                if ( $self->config_( 'force_fork' ) ne 0 ) {
                    $self->config_( 'force_fork', 0 );
                    $status = $$language{Configuration_SMTPForkDisabled} . "\n";
                }
            }
        }

        if ( defined($$form{smtp_port}) ) {
            if ( $self->is_valid_port_( $$form{smtp_port} ) ) {
                if ( $self->config_( 'port' ) ne $$form{smtp_port} ) {
                    $self->config_( 'port', $$form{smtp_port} );
                    $status .= sprintf(                    # PROFILE BLOCK START
                            $$language{Configuration_SMTPUpdate},
                            $self->config_( 'port' ) );    # PROFILE BLOCK STOP
                }
            } else {
                $error = $$language{Configuration_Error3};
            }
        }
        return( $status, $error );
    }

    if ( $name eq 'smtp_local' ) {
        if ( $form->{serveropt_smtp} ) {
            if ( $self->config_( 'local' ) ne 0 ) {
                $self->config_( 'local', 0 );
                $status = $$language{Security_ServerModeUpdateSMTP};
            }
        } else {
            if ( $self->config_( 'local' ) ne 1 ) {
                $self->config_( 'local', 1 );
                $status = $$language{Security_StealthModeUpdateSMTP};
            }
        }
        return ( $status, $error );
    }

    if ( $name eq 'smtp_server' ) {
        if ( defined $$form{smtp_chain_server} ) {
            if ( $self->config_( 'chain_server' ) ne $$form{smtp_chain_server} ) {
                $self->config_( 'chain_server', $$form{smtp_chain_server} );
                $status = sprintf(                                 # PROFILE BLOCK START
                        $$language{Security_SMTPServerUpdate},
                        $self->config_( 'chain_server' ) ) . "\n"; # PROFILE BLOCK STOP
            }
        }

        if ( defined $$form{smtp_chain_server_port} ) {

            if ( $self->is_valid_port_( $$form{smtp_chain_server_port} ) ) {
                if ( $self->config_( 'chain_port' ) ne $$form{smtp_chain_server_port} ) {
                    $self->config_( 'chain_port', $$form{smtp_chain_server_port} );
                    $status .= sprintf(                       # PROFILE BLOCK START
                            $$language{Security_SMTPPortUpdate},
                            $self->config_( 'chain_port' ) ); # PROFILE BLOCK STOP
                }
            } else {
                $error = $$language{Security_Error1};
            }
        }
        return( $status, $error );
    }

    return $self->SUPER::validate_item( $name, $templ, $language, $form );
}

1;
