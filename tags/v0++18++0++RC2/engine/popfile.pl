#!/usr/bin/perl
# ---------------------------------------------------------------------------------------------
#
# popfile.pl --- POP3 mail analyzer and sorter
#
# Acts as a POP3 server and client designed to sit between a real mail client and a real mail
# server using POP3.  Inserts an extra header X-Text-Classification: into the mail header to 
# tell the client whether the mail is spam or not based on a text classification algorithm
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
# ---------------------------------------------------------------------------------------------

use strict;
use locale;

# NOTE: POPFile is constructed from a collection of classes which all have special
# interface functions and variables:
#
# initialize() - called after the class is created to set default values for internal
#                variables and global configuration information
# start()      - called once all configuration has been read and POPFile is ready to start
#                operating
# stop()       - called when POPFile is shutting down
#
# service()    - called by the main POPFile process to allow a submodule to do its own
#                work (this is optional for modules that do not need to perform any service)
#
# forked()     - called when a module has forked the process.  This is called within the child
#                process and should be used to clean up 
#
# alive        - Gets set to 1 when the parent wants to kill all the running sub modules
#
# forker       - This is a reference to a function (forker) in this file that performs a fork
#                and informs modules that a fork has occurred.
#
# The POPFile classes are stored by reference in the %components hash
my %components;

# This is the ONLY PIECE OF PLATFORM SPECIFIC CODE IN POPFILE and all it does is 
# force Windows users to have v5.8.0 because that's the version with good fork() support
# everyone else can use 5.6.1.  This is probably only temporary because at some point
# I am going to force 5.8.0 for everyone because of the better Unicode support

if ( $^O eq 'MSWin32' ) {
	require v5.8.0;
} else {
	require v5.6.1;
}

use Classifier::Bayes;          # Use the Naive Bayes classifier
use UI::HTML;                   # Load the POPFile HTML user interface
use POPFile::Configuration;     # POPFile's configuration is handled by this module
use Proxy::POP3;                # The POP3 proxy engine
use POPFile::Logger;            # POPFile's logging mechanism

# A handy boolean that tells us whether we are alive or not.  When this is set to 1 then the
# proxy works normally, when set to 0 (typically by the aborting() function called from a signal)
# then we will terminate gracefully
my $alive = 1;

# ---------------------------------------------------------------------------------------------
#
# aborting    
#
# Called if we are going to be aborted or are being asked to abort our operation. Sets the 
# alive flag to 0 that will cause us to abort at the next convenient moment
#
# ---------------------------------------------------------------------------------------------
sub aborting 
{
    $alive = 0;
    for my $c (keys %components) {
        $components{$c}->{alive} = 0;
	    $components{$c}->stop();
    }
}

# ---------------------------------------------------------------------------------------------
#
# forker
#
# Called to fork POPFile.  Calls every module's forked function in the child process to give
# then a chance to clean up
#
# Returns the return value from fork() and a file handle that form a pipe in the
# direction child to parent.  There is no need to close the file handles that are unused as
# would normally be the case with a pipe and fork as forker takes care that in each process
# only one file handle is open (be it the reader or the writer)
#
# ---------------------------------------------------------------------------------------------
sub forker
{
    # Create the pipe that will be used to send data from the child to the parent process, 
    # $writer will be returned to the child process and $reader to the parent process
    
    pipe my $reader, my $writer;
    my $pid = fork();
    
    # If fork() returns an undefined value then we failed to fork and are
    # in serious trouble (probably out of resources) so we return undef
    
    if ( !defined( $pid ) ) {
        close $reader;
        close $writer;
        return (undef, undef);
    }

    # If fork returns a PID of 0 then we are in the child process so close the
    # reading pipe file handle, inform all modules that are fork has occurred and 
    # then return 0 as the PID so that the caller knows that we are in the child
    
    if ( $pid == 0 ) {
        for my $c (sort keys %components) {
            $components{$c}->forked();
        }
        
        close $reader;
        return (0, $writer);
    }
    
    # Reach here because we are in the parent process, close out the writer pipe
    # file handle and return our PID (non-zero) indicating that this is the parent
    # process
    
    close $writer;
    return ($pid, $reader);
}

#
#
# MAIN
#
#

$SIG{QUIT}  = \&aborting;
$SIG{ABRT}  = \&aborting;
$SIG{KILL}  = \&aborting;
$SIG{STOP}  = \&aborting;
$SIG{TERM}  = \&aborting;
$SIG{INT}   = \&aborting;
$SIG{CHLD}  = 'IGNORE';

# Create the main objects that form the core of POPFile.  Consists of the configuration
# modules, the classifier, the UI (currently HTML based), and the POP3 proxy.
$components{config}     = new POPFile::Configuration;
$components{classifier} = new Classifier::Bayes;
$components{ui}         = new UI::HTML;
$components{pop3}       = new Proxy::POP3;
$components{logger}     = new POPFile::Logger;

# This version number
$components{config}->{major_version} = 0;
$components{config}->{minor_version} = 18;
$components{config}->{build_version} = 0;

print "POPFile Engine v$components{config}->{major_version}.$components{config}->{minor_version}.$components{config}->{build_version} starting\n";

# Link each of the main objects with the configuration object so that they can set their
# default parameters.
$components{classifier}->{configuration} = $components{config};
$components{ui}->{configuration}         = $components{config};
$components{pop3}->{configuration}       = $components{config};
$components{logger}->{configuration}     = $components{config};

# The POP3 proxy and UI need to know about the classifier
$components{pop3}->{classifier}          = $components{classifier};
$components{ui}->{classifier}            = $components{classifier};

# The classifier needs to talk to the UI
$components{classifier}->{ui}            = $components{ui};

# The proxy uses the logger
$components{pop3}->{logger}              = $components{logger};
$components{classifier}->{logger}        = $components{logger};

print "    Initializing... ";

# Tell each module to initialize itself
for my $c (sort keys %components) {
    print "{$c} ";
    if ( $components{$c}->initialize() == 0 ) {
        die "Failed to start while initializing the $c module";
    }
    
    $components{$c}->{alive}  = 1;
    $components{$c}->{forker} = \&forker;
}

# Load the configuration from disk and then apply any command line
# changes that override the saved configuration
$components{config}->load_configuration();
$components{config}->parse_command_line();

print "\n    Starting...     ";

# Now that the configuration is set tell each module to begin operation
for my $c (sort keys %components) {
    print "{$c} ";
    if ( $components{$c}->start() == 0 ) {
        die "Failed to start while starting the $c module";
    }
}

print "\nPOPFile Engine v$components{config}->{major_version}.$components{config}->{minor_version}.$components{config}->{build_version} running\n";

# MAIN LOOP - Call each module's service() method to all it to
#             handle its own requests
while ( $alive == 1 ) {
    for my $c (keys %components) {
        if ( $components{$c}->service() == 0 ) {
            $alive = 0;
            last;
        }
    }
    
    # Sleep for 0.05 of a second to ensure that POPFile does not hog the machine's
    # CPU
    select(undef, undef, undef, 0.05);
}

print "    Stopping... ";

# Shutdown all the modules
for my $c (sort keys %components) {
    print "{$c} ";
    $components{$c}->{alive} = 0;
    $components{$c}->stop();
}

print "\n    Saving configuration\n";

# Write the final configuration to disk
$components{config}->save_configuration();

print "POPFile Engine v$components{config}->{major_version}.$components{config}->{minor_version}.$components{config}->{build_version} terminating\n";

# ---------------------------------------------------------------------------------------------