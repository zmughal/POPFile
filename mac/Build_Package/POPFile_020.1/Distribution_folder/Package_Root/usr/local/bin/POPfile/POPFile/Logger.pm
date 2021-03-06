# POPFILE LOADABLE MODULE
package POPFile::Logger;

use POPFile::Module;
@ISA = ("POPFile::Module");

#----------------------------------------------------------------------------
#
# This module handles POPFile's logger.  It is used to save debugging
# information to disk or to send it to the screen.
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
#   This file is part of POPFile
#
#   POPFile is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
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

# Constant used by the log rotation code
my $seconds_per_day = 60 * 60 * 24;

#----------------------------------------------------------------------------
# new
#
#   Class new() function
#----------------------------------------------------------------------------
sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = POPFile::Module->new();

    # The name of the debug file

    $self->{debug_filename__} = '';

    # The last ten lines sent to the logger

    $self->{last_ten__} = ();

    bless($self, $class);

    $self->name( 'logger' );

    return $self;
}

# ---------------------------------------------------------------------------------------------
#
# initialize
#
# Called to initialize the interface
#
# ---------------------------------------------------------------------------------------------
sub initialize
{
    my ( $self ) = @_;

    # Start with debugging to file

    $self->global_config_( 'debug', 1 );

    # The default location for log files

    $self->config_( 'logdir', './' );

    $self->{last_tickd__} = time;

    $self->mq_register_( 'TICKD', $self );
    $self->calculate_today__();

    return 1;
}

# ---------------------------------------------------------------------------------------------
#
# deliver
#
# Called by the message queue to deliver a message
#
# There is no return value from this method
#
# ---------------------------------------------------------------------------------------------
sub deliver
{
    my ( $self, $type, $message, $parameter ) = @_;

    # If a day has passed then clean up log files

    if ( $type eq 'TICKD' ) {
        $self->remove_debug_files();
    }
}

# ---------------------------------------------------------------------------------------------
#
# service
#
# ---------------------------------------------------------------------------------------------
sub service
{
    my ( $self ) = @_;

    $self->calculate_today__();

    # We send out a TICKD message every hour so that other modules
    # can do clean up tasks that need to be done regularly but not
    # often

    if ( time > ( $self->{last_tickd__} + 60 * 60 ) ) {
        $self->mq_post_( 'TICKD', '', '' );
        $self->{last_tickd__} = time;
    }

    return 1;
}

# ---------------------------------------------------------------------------------------------
#
# calculate_today - set the global $self->{today} variable to the current day in seconds
#
# ---------------------------------------------------------------------------------------------
sub calculate_today__
{
    my ( $self ) = @_;

    # Create the name of the debug file for the debug() function
    $self->{today__} = int( time / $seconds_per_day ) * $seconds_per_day;
    $self->{debug_filename__} = $self->config_( 'logdir' ) . "popfile$self->{today__}.log";
}

# ---------------------------------------------------------------------------------------------
#
# remove_debug_files
#
# Removes popfile log files that are older than 3 days
#
# ---------------------------------------------------------------------------------------------
sub remove_debug_files
{
    my ( $self ) = @_;

    my @debug_files = glob( $self->config_( 'logdir' ) . 'popfile*.log' );

    foreach my $debug_file (@debug_files) {
        # Extract the epoch information from the popfile log file name
        if ( $debug_file =~ /popfile([0-9]+)\.log/ )  {
            # If older than now - 3 days then delete
            unlink($debug_file) if ( $1 < (time - 3 * $seconds_per_day) );
        }
    }
}

# ---------------------------------------------------------------------------------------------
#
# debug
#
# $message    A string containing a debug message that may or may not be printed
#
# Prints the passed string if the global $debug is true
#
# ---------------------------------------------------------------------------------------------
sub debug
{
    my ( $self, $message ) = @_;

    if ( $self->global_config_( 'debug' ) > 0 ) {
        # Check to see if we are handling the USER/PASS command and if we are then obscure the
        # account information
        $message = "$`$1$3 XXXXXX$4" if ( $message =~ /((--)?)(USER|PASS)\s+\S*(\1)/ );
        chomp $message;
        $message .= "\n";

        my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime;
        $year += 1900;
        $mon  += 1;

        $min  = "0$min"  if ( $min  < 10 );
        $hour = "0$hour" if ( $hour < 10 );
        $sec  = "0$sec"  if ( $sec  < 10 );

        my $msg = "$year/$mon/$mday $hour:$min:$sec $$: $message";

        if ( $self->global_config_( 'debug' ) & 1 )  {
  	    if ( open DEBUG, ">>$self->{debug_filename__}" ) {
                binmode DEBUG;
                print DEBUG $msg;
                close DEBUG;
            } else {
                print "Can't write to log file $self->{debug_filename__}\n";
            }
        }

        print $msg if ( $self->global_config_( 'debug' ) & 2 );

        # Add the line to the in memory collection of the last ten
        # logger entries and then remove the first one if we now have
        # more than 10

        push @{$self->{last_ten__}}, ($msg);

        if ( $#{$self->{last_ten__}} > 9 ) {
            shift @{$self->{last_ten__}};
        }
    }
}

# GETTERS/SETTERS

sub debug_filename
{
    my ( $self ) = @_;

    return $self->{debug_filename__};
}

sub last_ten
{
    my ( $self ) = @_;

    if ( $#{$self->{last_ten__}} >= 0 ) {
        return @{$self->{last_ten__}};
    } else {
        my @temp = ( 'log empty' );
        return @temp;
    }
}

1;
