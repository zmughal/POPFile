# POPFILE LOADABLE MODULE
package POPFile::MQ;

use POPFile::Module;
@ISA = ( "POPFile::Module" );

#----------------------------------------------------------------------------
#
# This module handles POPFile's message queue.  Every POPFile::Module is
# able to register with the MQ for specific message types and can also
# send messages without having to know which modules need to receive
# its messages.
#
# Message delivery is asynchronous and guaranteed.
#
# The following public functions are defined:
#
# register() - register for a specific message type and pass an object
#              reference.  will call that object's deliver() method to
#              deliver messages
#
# post()     - send a message of a specific type
#
# The current list of types is
#
#     UIREG    Register a UI component, message is the component type
#              and the element and reference to the
#              object registering (comes from any component)
#
#     TICKD    Occurs when an hour has passed since the last TICKD (this
#              is generated by the POPFile::Logger module)
#
#     LOGIN    Occurs when a proxy logs into a remote server, the message
#              is the username sent
#
#     COMIT    Sent when an item is committed to the history through a call
#              to POPFile::History::commit_slot
#
# Copyright (c) 2001-2004 John Graham-Cumming
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

use POSIX ":sys_wait_h";

#----------------------------------------------------------------------------
# new
#
#   Class new() function
#----------------------------------------------------------------------------
sub new
{
    my $type = shift;
    my $self = POPFile::Module->new();

    # These are the individual queues of message, indexed by type
    # and written to by post().

    $self->{queue__} = {};

    # These are the registered objects for each type

    $self->{waiters__} = {};

    # List of file handles to read from active children, this
    # maps the PID for each child to its associated pipe handle

    $self->{children__}        = {};

    # Record the parent process ID so that we can tell when post is
    # called whether we are in a child process or not

    $self->{pid__}             = $$;

    bless $self, $type;

    $self->name( 'mq' );

    return $self;
}

#----------------------------------------------------------------------------
#
# service
#
# Called to handle pending tasks for the module.  Here we flush all queues
#
#----------------------------------------------------------------------------
sub service
{
    my ( $self ) = @_;

    # See if any of the children have passed up messages through their
    # pipes and deal with it now

    for my $kid (keys %{$self->{children__}}) {
        $self->flush_child_data_( $self->{children__}{$kid} );
    }

    # Iterate through all the messages in all the queues

    for my $type (sort keys %{$self->{queue__}}) {
         while ( my $ref = shift @{$self->{queue__}{$type}} ) {
             for my $waiter (@{$self->{waiters__}{$type}}) {
                my @message   = @$ref;

                my $flat = join(':', @message);
                $self->log_( 2, "Delivering message $type ($flat) to " .
                    $waiter->name() );

                $waiter->deliver( $type, @message );
            }
        }
    }

    return 1;
}

#----------------------------------------------------------------------------
#
# stop
#
# Called when POPFile is closing down, this is the last method that
# will get called before the object is destroyed.  There is not return
# value from stop().
#
#----------------------------------------------------------------------------
sub stop
{
    my ( $self ) = @_;

    # Call service() so that any remaining items are flushed and delivered

    $self->service();

    for my $kid (keys %{$self->{children__}}) {
        close $self->{children__}{$kid};
        delete $self->{children__}{$kid};
    }
}

#----------------------------------------------------------------------------
#
# yield_
#
# Called by a child process to allow the parent to do work, this only
# does anything in the case where we didn't fork for the child process
#
#----------------------------------------------------------------------------
sub yield_
{
    my ( $self, $pipe, $pid ) = @_;

    if ( $pid != 0 ) {
        $self->flush_child_data_( $pipe )
    }
}

#----------------------------------------------------------------------------

#
# forked
#
# This is called when some module forks POPFile and is within the
# context of the child process so that this module can close any
# duplicated file handles that are not needed.
#
# $writer            The writing end of a pipe that can be used to send up from
#                    the child
#
# There is no return value from this method
#
#----------------------------------------------------------------------------
sub forked
{
    my ( $self, $writer ) = @_;

    $self->{writer__} = $writer;

    for my $kid (keys %{$self->{children__}}) {
        close $self->{children__}{$kid};
        delete $self->{children__}{$kid};
    }
}

#----------------------------------------------------------------------------
#
# postfork
#
# This is called when some module has just forked POPFile.  It is
# called in the parent process.
#
# $pid              The process ID of the new child process
# $reader      The reading end of a pipe that can be used to read messages
# from the child
#
# There is no return value from this method
#
#----------------------------------------------------------------------------
sub postfork
{
    my ( $self, $pid, $reader ) = @_;

    $self->{children__}{"$pid"} = $reader;
}

#----------------------------------------------------------------------------
#
# reaper
#
# Called when a child process terminates somewhere in POPFile.  The
# object should check to see if it was one of its children and do any
# necessary processing by calling waitpid() on any child handles it
# has
#
# There is no return value from this method
#
#----------------------------------------------------------------------------
sub reaper
{
    my ( $self ) = @_;

    # Look for children that have completed and then flush the data
    # from their associated pipe and see if any of our children have
    # data ready to read from their pipes,

    my @kids = keys %{$self->{children__}};

    if ( $#kids >= 0 ) {
        for my $kid (@kids) {
            if ( waitpid( $kid, &WNOHANG ) == $kid ) {
                $self->flush_child_data_( $self->{children__}{$kid} );
                close $self->{children__}{$kid};
                delete $self->{children__}{$kid};

                $self->log_( 0, "Done with $kid (" . scalar(keys %{$self->{children__}}) . " to go)" );
            }
        }
    }
}

#----------------------------------------------------------------------------
#
# read_pipe_
#
# reads a single message from a pipe in a cross-platform way.
# returns undef if the pipe has no message
#
# $handle   The handle of the pipe to read
#
#----------------------------------------------------------------------------
sub read_pipe_
{
    my ( $self, $handle ) = @_;

    if ( $^O eq "MSWin32" ) {

        # bypasses bug in -s $pipe under ActivePerl

        my $message;         # PROFILE PLATFORM START MSWin32

        if ( &{ $self->{pipeready_} }($handle) ) {

            # add data to the pipe cache whenever the pipe is ready

            sysread($handle, my $string, -s $handle);

            # push messages onto the end of our cache

            $self->{pipe_cache__} .= $string;
        }

        # pop the oldest message;

        $message = $1 if (defined($self->{pipe_cache__}) &&
                          ( $self->{pipe_cache__} =~ s/(.*?\n)// ) );

        return $message;        # PROFILE PLATFORM STOP
    } else {

        # do things normally

        if ( &{ $self->{pipeready_} }($handle) ) {
            return <$handle>;
        }
    }

    return undef;
}

#----------------------------------------------------------------------------
#
# flush_child_data_
#
# Called to flush data from the pipe of each child as we go, I did
# this because there appears to be a problem on Windows where the pipe
# gets a lot of read data in it and then causes the child not to be
# terminated even though we are done.  Also this is nice because we
# deal with the messages on the fly
#
# $handle   The handle of the child's pipe
#
#----------------------------------------------------------------------------

sub flush_child_data_
{
    my ( $self, $handle ) = @_;

    my $stats_changed = 0;
    my $message;

    while ( ($message = $self->read_pipe_( $handle )) && defined($message) )
    {
        if ( $message =~ /([^:]+):([^\r\n]*)/ ) {
            my @parameters = split( ':', $2 || '' );
            $self->post( $1, @parameters );
        }
    }
}

#----------------------------------------------------------------------------
#
# register
#
#   When a module wants to receive specific message types it calls this
#   method with the type of message is wants to receive and the address
#   of a callback function that will receive the messages
#
#   $type        A string identifying the message type
#   $callback    Reference to a function that takes three parameters
#
#----------------------------------------------------------------------------
sub register
{
    my ( $self, $type, $callback ) = @_;

    push @{$self->{waiters__}{$type}}, ( $callback );
}

#----------------------------------------------------------------------------
#
# post
#
#   Called to send a message through the message queue
#
#   $type        A string identifying the message type
#   @message     The message (list of parameters)
#
#----------------------------------------------------------------------------
sub post
{
    my ( $self, $type, @message ) = @_;

    my $flat = join( ':', @message );
    $self->log_( 2, "post $type ($flat)" );

    # If we are in the parent process then just stick this on the queue,
    # otherwise write it up the pipe.

    if ( $$ == $self->{pid__} ) {
        push @{$self->{queue__}{$type}}, \@message;
    } else {
        my $pipe = $self->{writer__};
        print $pipe "$type:$flat\n";
    }
}

1;
