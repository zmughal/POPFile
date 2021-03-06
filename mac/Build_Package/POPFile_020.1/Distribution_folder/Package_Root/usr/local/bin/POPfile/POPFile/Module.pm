#----------------------------------------------------------------------------
#
# This is POPFile's top level Module object.
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

package POPFile::Module;

# ---------------------------------------------------------------------------------------------
#
# This module implements the base class for all POPFile Loadable Modules and
# contains collection of methods that are common to all POPFile modules and only
# selected ones need be overriden by subclasses
#
# POPFile is constructed from a collection of classes which all have special
# PUBLIC interface functions:
#
# initialize() - called after the class is created to set default values for internal
#                variables and global configuration information
#
# start()      - called once all configuration has been read and POPFile is ready to start
#                operating
#
# stop()       - called when POPFile is shutting down
#
# service()    - called by the main POPFile process to allow a submodule to do its own
#                work (this is optional for modules that do not need to perform any service)
#
# prefork()    - called when a module has requested a fork, but before the fork happens
#
# forked()     - called when a module has forked the process.  This is called within the child
#                process and should be used to clean up
#
# postfork()   - called in the parent process to tell it that the fork has occurred.  This is
#                like forked but in the parent
#
# reaper()     - called when a process has terminated to give a module a chance to do
#                whatever clean up is needed
#
# name()       - returns a simple name for the module by which other modules can get access
#                through the %components hash.  The name returned here will be the name
#                used as the key for this module in %components
#
# deliver()    - called by the message queue to deliver a message
#
# The following methods are PROTECTED and should be accessed by sub classes:
#
# log_()       - sends a string to the logger
#
# config_()    - gets or sets a configuration parameter for this module
#
# mq_post_()   - post a message to the central message queue
#
# mq_register_() register for messages from the message queue
#
# register_configuration_item_() register a UI configuration item
#
# A note on the naming
#
# A method or variable that ends with an underscore is PROTECTED and should not be accessed
# from outside the class (or subclass; in C++ its protected), to access a PROTECTED variable
# you will find an equivalent getter/setter method with no underscore.
#
# Truly PRIVATE variables are indicated by a double underscore at the end of the name and
# should not be accessed outside the class without going through a getter/setter and may
# not be directly accessed by a subclass.
#
# For example
#
# $c->foo__() is a private method
# $c->{foo__} is a private variable
# $c->foo_() is a protected method
# $c->{foo_} is a protected variable
# $c->foo() is a public method that modifies $c->{foo_} it always returns the current
# value of the variable it is referencing and if passed a value sets that corresponding
# variable
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
# ---------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------
# new
#
#   Class new() function, all real work gets done by initialize and 
#   the things set up here are more for documentation purposes than
#   anything so that you know that they exists
#
#----------------------------------------------------------------------------
sub new
{
    my $type = shift;
    my $self;

    # A reference to the POPFile::Configuration module, every module is
    # able to get configuration information through this, note that it
    # is valid when initialize is called, however, the configuration is not
    # read from disk until after initialize has been called

    $self->{configuration__} = 0; # PRIVATE

    # A reference to the POPFile::Logger module

    $self->{logger__}        = 0; # PRIVATE

    # A reference to the POPFile::MQ module

    $self->{mq__}            = 0;

    # The name of this module

    $self->{name__}          = ''; # PRIVATE

    # Used to tell any loops to terminate

    $self->{alive_}          = 1;

    # This is a reference to the pipeready() function in popfile.pl that it used
    # to determine if a pipe is ready for reading in a cross platform way

    $self->{pipeready_}      = 0;

    # This is a reference to a function (forker) in popfile.pl that performs a fork
    # and informs modules that a fork has occurred

    $self->{forker_}         = 0;

    return bless $self, $type;
}

# ---------------------------------------------------------------------------------------------
#
# initialize
#
# Called to initialize the module, the main task that this function should perform is
# setting up the default values of the configuration options for this object.  This is done
# through the configuration_ hash value that will point the configuration module.
#
# Note that the configuration is not loaded from disk until after every module's initialize
# has been called, so do not use any of these values until start() is called as they may
# change
#
# The method should return 1 to indicate that it initialized correctly, if it returns
# 0 then POPFile will abort loading immediately
#
# ---------------------------------------------------------------------------------------------
sub initialize
{
    my ( $self ) = @_;

    return 1;
}

# ---------------------------------------------------------------------------------------------
#
# start
#
# Called when all configuration information has been loaded from disk.
#
# The method should return 1 to indicate that it started correctly, if it returns
# 0 then POPFile will abort loading immediately
#
# ---------------------------------------------------------------------------------------------
sub start
{
    my ( $self ) = @_;

    return 1;
}

# ---------------------------------------------------------------------------------------------
#
# stop
#
# Called when POPFile is closing down, this is the last method that will get called before
# the object is destroyed.  There is not return value from stop().
#
# ---------------------------------------------------------------------------------------------
sub stop
{
    my ( $self ) = @_;
}

# ---------------------------------------------------------------------------------------------
#
# reaper
#
# Called when a child process terminates somewhere in POPFile.  The object should check
# to see if it was one of its children and do any necessary processing by calling waitpid()
# on any child handles it has
#
# There is no return value from this method
#
# ---------------------------------------------------------------------------------------------
sub reaper
{
    my ( $self ) = @_;
}

# ---------------------------------------------------------------------------------------------
#
# service
#
# service() is a called periodically to give the module a chance to do housekeeping work.
#
# If any problem occurs that requires POPFile to shutdown service() should return 0 and
# the top level process will gracefully terminate POPFile including calling all stop()
# methods.  In normal operation return 1.
#
# ---------------------------------------------------------------------------------------------
sub service
{
    my ( $self ) = @_;

    return 1;
}

# ---------------------------------------------------------------------------------------------
#
# prefork
#
# This is called when some module is about to fork POPFile
#
# There is no return value from this method
#
# ---------------------------------------------------------------------------------------------
sub prefork
{
    my ( $self ) = @_;
}

# ---------------------------------------------------------------------------------------------
#
# forked
#
# This is called when some module forks POPFile and is within the context of the child
# process so that this module can close any duplicated file handles that are not needed.
#
# There is no return value from this method
#
# ---------------------------------------------------------------------------------------------
sub forked
{
    my ( $self ) = @_;
}

# ---------------------------------------------------------------------------------------------
#
# postfork
#
# This is called when some module has just forked POPFile.  It is called in the parent
# process.
#
# There is no return value from this method
#
# ---------------------------------------------------------------------------------------------
sub postfork
{
    my ( $self ) = @_;
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
}

# ---------------------------------------------------------------------------------------------
#
# log_
#
# Called by a subclass to send a message to the logger, the logged message will be prefixed
# by the name of the module in use
#
# $message           The message to log
#
# There is no return value from this method
#
# ---------------------------------------------------------------------------------------------
sub log_
{
    my ( $self, $message ) = @_;

    $self->{logger__}->debug( $self->{name__} . ': ' . $message );
}

# ---------------------------------------------------------------------------------------------
#
# config_
#
# Called by a subclass to get or set a configuration parameter
#
# $name              The name of the parameter (e.g. 'port')
# $value             (optional) The value to set
#
# If called with just a $name then config_() will return the current value
# of the configuration parameter.
#
# ---------------------------------------------------------------------------------------------
sub config_
{
    my ( $self, $name, $value ) = @_;

    return $self->module_config_( $self->{name__}, $name, $value );
}

# ---------------------------------------------------------------------------------------------
#
# mq_post_
#
# Called by a subclass to post a message to the message queue
#
# $type              Type of message to send
# $message           Message to send
# $parameter         Message parameters
#
# ---------------------------------------------------------------------------------------------
sub mq_post_
{
    my ( $self, $type, $message, $parameter ) = @_;

    return $self->{mq__}->post( $type, $message, $parameter );
}

# ---------------------------------------------------------------------------------------------
#
# mq_register_
#
# Called by a subclass to register with the message queue for messages
#
# $type              Type of message to send
# $object            Callback object
#
# ---------------------------------------------------------------------------------------------
sub mq_register_
{
    my ( $self, $type, $object ) = @_;

    return $self->{mq__}->register( $type, $object );
}

# ---------------------------------------------------------------------------------------------
#
# global_config_
#
# Called by a subclass to get or set a global (i.e. not module specific) configuration parameter
#
# $name              The name of the parameter (e.g. 'port')
# $value             (optional) The value to set
#
# If called with just a $name then global_config_() will return the current value
# of the configuration parameter.
#
# ---------------------------------------------------------------------------------------------
sub global_config_
{
    my ( $self, $name, $value ) = @_;

    return $self->module_config_( 'GLOBAL', $name, $value );
}

# ---------------------------------------------------------------------------------------------
#
# module_config_
#
# Called by a subclass to get or set a module specific configuration parameter
#
# $module            The name of the module that owns the parameter (e.g. 'pop3')
# $name              The name of the parameter (e.g. 'port')
# $value             (optional) The value to set
#
# If called with just a $module and $name then module_config_() will return the current value
# of the configuration parameter.
#
# ---------------------------------------------------------------------------------------------
sub module_config_
{
    my ( $self, $module, $name, $value ) = @_;

    return $self->{configuration__}->parameter( $module . "_" . $name, $value );
}

# ---------------------------------------------------------------------------------------------
#
# register_configuration_item_
#
# Called by a subclass to register a UI element
#
# $type, $name, $object     See register_configuration_item in UI::HTML
#
# ---------------------------------------------------------------------------------------------
sub register_configuration_item_
{
    my ( $self, $type, $name, $object ) = @_;

    return $self->mq_post_( 'UIREG', "$type:$name", $object );
}

# GETTER/SETTER methods.  Note that I do not expect documentation of these unless they
# are non-trivial since the documentation would be a waste of space
#
# The only thing to note is the idiom used, stick to that and there's no need to
# document these
#
#   sub foo
#   {
#       my ( $self, $value ) = @_;
#
#       if ( defined( $value ) ) {
#           $self->{foo_} = $value;
#       }
#
#       return $self->{foo_};
#   }
#
# This method access the foo_ variable for reading or writing, $c->foo() read foo_ and
# $c->foo( 'foo' ) writes foo_

sub mq
{
    my ( $self, $value ) = @_;

    if ( defined( $value ) ) {
        $self->{mq__} = $value;
    }

    return $self->{mq__};
}

sub configuration
{
    my ( $self, $value ) = @_;

    if ( defined( $value ) ) {
        $self->{configuration__} = $value;
    }

    return $self->{configuration__};
}

sub forker
{
    my ( $self, $value ) = @_;

    if ( defined( $value ) ) {
        $self->{forker_} = $value;
    }

    return $self->{forker_};
}

sub logger
{
    my ( $self, $value ) = @_;

    if ( defined( $value ) ) {
        $self->{logger__} = $value;
    }

    return $self->{logger__};
}

sub pipeready
{
    my ( $self, $value ) = @_;

    if ( defined( $value ) ) {
        $self->{pipeready_} = $value;
    }

    return $self->{pipeready_};
}

sub alive
{
    my ( $self, $value ) = @_;

    if ( defined( $value ) ) {
        $self->{alive_} = $value;
    }

    return $self->{alive_};
}

sub name
{
    my ( $self, $value ) = @_;

    if ( defined( $value ) ) {
        $self->{name__} = $value;
    }

    return $self->{name__};
}

sub version
{
    my ( $self, $value ) = @_;

    if ( defined( $value ) ) {
        $self->{version_} = $value;
    }

    return $self->{version_};
}

sub last_ten_log_entries
{
    my ( $self ) = @_;

    return $self->{logger__}->last_ten();
}

1;
