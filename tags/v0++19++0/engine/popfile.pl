#!/usr/bin/perl
# ---------------------------------------------------------------------------------------------
#
# popfile.pl --- Message analyzer and sorter
#
# Acts as a server and client designed to sit between a real mail/news client and a real mail
# news server using POP3.  Inserts an extra header X-Text-Classification: into the header to
# tell the client which category the message belongs in.
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
# ---------------------------------------------------------------------------------------------

use strict;
use locale;

# The POPFile classes are stored by reference in the %components hash, the top level key is
# the type of the component (see load_modules) and then the name of the component derived from
# calls to each loadable modules name() method and which points to the actual module

my %components;

my $on_windows = 0;

if ( $^O eq 'MSWin32' ) {
    require v5.8.0;
    $on_windows = 1;
}

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
    foreach my $type (keys %components) {
        foreach my $name (keys %{$components{$type}}) {
            $components{$type}{$name}->alive(0);
            $components{$type}{$name}->stop();
        }
    }
}

# ---------------------------------------------------------------------------------------------
#
# pipeready
#
# Returns 1 if there is data available to be read on the passed in pipe handle
#
# $pipe        Pipe handle
#
# ---------------------------------------------------------------------------------------------
sub pipeready
{
    my ( $pipe ) = @_;

    # Check that the $pipe is still a valid handle

    if ( !defined( $pipe ) ) {
        return 0;
    }

    if ( $on_windows ) {

        # I am NOT doing a select() here because that does not work
        # on Perl running on Windows.  -s returns the "size" of the file
        # (in this case a pipe) and will be non-zero if there is data to read

        return ( ( -s $pipe ) > 0 );
    } else {

        # Here I do a select because we are not running on Windows where
        # you can't select() on a pipe

        my $rin = '';
        vec( $rin, fileno( $pipe ), 1 ) = 1;
        my $ready = select( $rin, undef, undef, 0.01 );
        return ( $ready > 0 );
    }
}



# ---------------------------------------------------------------------------------------------
#
# reaper
#
# Called if we get SIGCHLD and asks each module to do whatever reaping is needed
#
# ---------------------------------------------------------------------------------------------
sub reaper
{
    foreach my $type (keys %components) {
        foreach my $name (keys %{$components{$type}}) {
            $components{$type}{$name}->reaper();
        }
    }

    $SIG{CHLD} = \&reaper;
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
    # Tell all the modules that a fork is about to happen

    foreach my $type (keys %components) {
        foreach my $name (keys %{$components{$type}}) {
            $components{$type}{$name}->prefork();
        }
    }

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
          foreach my $type (keys %components) {
               foreach my $name (keys %{$components{$type}}) {
                 $components{$type}{$name}->forked();
              }
        }

        close $reader;

        # Set autoflush on the write handle so that output goes straight through
        # to the parent without buffering it until the socket closes

        use IO::Handle;
        $writer->autoflush(1);

        return (0, $writer);
    }

    # Reach here because we are in the parent process, close out the writer pipe
    # file handle and return our PID (non-zero) indicating that this is the parent
    # process

    close $writer;
    return ($pid, $reader);
}

# ---------------------------------------------------------------------------------------------
#
# load_modules
#
# Called to load all the POPFile loadable modules (implemented as .pm files with special
# comment on first line) in a specific subdirectory
#
# $directory          The directory to search for loadable modules
# $type                    The 'type' of module being loaded (e.g. proxy, core, ui) which is used
#                        below when fixing up references between modules (e.g. proxy modules all
#                         need access to the classifier module)
#
#
# ---------------------------------------------------------------------------------------------
sub load_modules
{
     my ( $directory, $type ) = @_;

     print "\n         {$type:";

     # Look for all the .pm files in named directory and then see which of them
     # are POPFile modules indicated by the first line of the file being and
     # comment (# POPFILE LOADABLE MODULE) and load that module into the %components
     # hash getting the name from the module by calling name()

     my @modules = glob "$directory/*.pm";

     foreach my $module (@modules) {
          if ( open MODULE, "<$module" ) {
               my $first = <MODULE>;
               close MODULE;

               if ( $first =~ /^# POPFILE LOADABLE MODULE/ ) {
                    require $module;

                    $module =~ s/\//::/;
                    $module =~ s/\.pm//;

                    my $mod = new $module;
                    my $name = $mod->name();

                    $components{$type}{$name} = $mod;

                    print " $name";
               }
          }
     }

     print '} ';
}

#
#
# MAIN
#
#

my ( $major_version, $minor_version, $build_version ) = ( 0, 19, 0 );
my $version_string = "v$major_version.$minor_version.$build_version";

print "\nPOPFile Engine $version_string loading\n";

$SIG{QUIT}  = \&aborting;
$SIG{ABRT}  = \&aborting;
$SIG{KILL}  = \&aborting;
$SIG{STOP}  = \&aborting;
$SIG{TERM}  = \&aborting;
$SIG{INT}   = \&aborting;

# Yuck.  On Windows SIGCHLD isn't calling the reaper under ActiveState 5.8.0
# so we detect Windows and ignore SIGCHLD and call the reaper code below

$SIG{CHLD}  = $on_windows?'IGNORE':\&reaper;

# Create the main objects that form the core of POPFile.  Consists of the configuration
# modules, the classifier, the UI (currently HTML based), and the POP3 proxy.

print "\n    Loading... ";

# Look for a module called Platform::<platform> where <platform> is the value of $^O
# and if it exists then load it as a component of POPFile.  IN this way we can have
# platform specific code (or not) encapsulated.  Note that such a module needs to be
# a POPFile Loadable Module and a subclass of POPFile::Module to operate correctly

my $platform = $^O;

if ( -e "Platform/$platform.pm" ) {
   require "Platform/$platform.pm";
   $platform = "Platform::$platform";
   my $mod  = new $platform;
   my $name = $mod->name();
   $components{core}{$name} = $mod;
   print "\n         {core: $name}";
}

load_modules( 'POPFile',    'core'       );
load_modules( 'Classifier', 'classifier' );
load_modules( 'UI',         'interface' );
load_modules( 'Proxy',      'proxy'      );

print "\n\nPOPFile Engine $version_string starting";

# Link each of the main objects with the configuration object so that they can set their
# default parameters all or them also get access to the logger

foreach my $type (keys %components) {
     foreach my $name (keys %{$components{$type}}) {
          $components{$type}{$name}->version(       $version_string           );
          $components{$type}{$name}->configuration( $components{core}{config} );
          $components{$type}{$name}->logger(        $components{core}{logger} ) if ( $name ne 'logger' );
     }
}

# All proxies need access to the classifier and the interface

foreach my $name (keys %{$components{proxy}}) {
     $components{proxy}{$name}->classifier( $components{classifier}{bayes} );
     $components{proxy}{$name}->ui(         $components{interface}{html} );
}

# All interface components need access to the classifier and the UI

foreach my $name (keys %{$components{interface}}) {
     $components{interface}{$name}->classifier( $components{classifier}{bayes} );
     $components{interface}{$name}->ui(         $components{interface}{html} ) if ( $name ne 'html' );
}

print "\n\n    Initializing... ";

# Tell each module to initialize itself

foreach my $type (keys %components) {
     print "\n         {$type:";
     foreach my $name (keys %{$components{$type}}) {
          print " $name";
          flush STDOUT;
          if ( $components{$type}{$name}->initialize() == 0 ) {
               die "Failed to start while initializing the $name module";
          }

          $components{$type}{$name}->alive(     1 );
          $components{$type}{$name}->forker(    \&forker );
          $components{$type}{$name}->pipeready( \&pipeready );
     }
     print '} ';
}

# Load the configuration from disk and then apply any command line
# changes that override the saved configuration

$components{core}{config}->load_configuration();
$components{core}{config}->parse_command_line();

print "\n\n    Starting...     ";

# Now that the configuration is set tell each module to begin operation

foreach my $type (keys %components) {
     print "\n         {$type:";
     foreach my $name (keys %{$components{$type}}) {
          print " $name";
          flush STDOUT;
          if ( $components{$type}{$name}->start() == 0 ) {
               die "Failed to start while starting the $name module";
          }
     }
     print '} ';
}

print "\n\nPOPFile Engine $version_string running\n";
flush STDOUT;

# MAIN LOOP - Call each module's service() method to all it to
#             handle its own requests

while ( $alive == 1 ) {
     foreach my $type (keys %components) {
          foreach my $name (keys %{$components{$type}}) {
               if ( $components{$type}{$name}->service() == 0 ) {
                    $alive = 0;
                    last;
               }
          }
    }

    # Sleep for 0.05 of a second to ensure that POPFile does not hog the machine's
    # CPU

    select(undef, undef, undef, 0.05);

    # If we are on Windows then reap children here

    if ( $on_windows ) {
          foreach my $type (keys %components) {
               foreach my $name (keys %{$components{$type}}) {
                    $components{$type}{$name}->reaper();
               }
          }
    }
}

print "\n\nPOPFile Engine $version_string stopping\n";
flush STDOUT;

print "\n    Stopping... ";

# Shutdown all the modules

foreach my $type (keys %components) {
      print "\n         {$type:";
     foreach my $name (keys %{$components{$type}}) {
          print " $name";
	  flush STDOUT;
          $components{$type}{$name}->alive(0);
          $components{$type}{$name}->stop();
     }

     print '} ';
}

print "\n\n    Saving configuration\n";
flush STDOUT;

# Write the final configuration to disk

$components{core}{config}->save_configuration();

print "\nPOPFile Engine $version_string terminated\n";

# ---------------------------------------------------------------------------------------------