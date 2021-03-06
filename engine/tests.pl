#!/usr/bin/perl
# ----------------------------------------------------------------------------
#
# tests.pl  - Unit tests for POPFile
#
# Copyright (c) 2001-2011 John Graham-Cumming
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
use utf8;

require IO::Handle;
use File::Copy;
use File::Find;
use File::Path;
use English qw(-no_match_vars);


sub use_base_environment {
    rmtree( 'messages' );
    rmtree( 'corpus' );

    rmtree( 'corpus/.svn' );
    rec_cp( 'corpus.base', 'corpus' );
    unlink 'popfile.db';
    unlink 'stopwords';
    unlink 'popfile.pid';
    unlink 'popfile.cfg';

    copy ( 'stopwords.base', 'stopwords' );

    mkdir 'messages';
}

sub cleanup {
    unlink 'popfile.db';
    unlink 'popfile.pid';
    unlink 'popfile.cfg';
    unlink 'stopwords';
    rmtree 'messages';
}


sub rec_cp
{
    my ( $from, $to ) = @_;
    my $ok = 1;

    my $subref =
        sub {
            my $f = $_;
            my $t = $f;
            $t =~ s/^$from/$to/;
            if ( $t !~ /.svn/ ) {
                if ( -d $f ) {
                    mkdir $t;
                } else {
                    copy( $f, $t ) or $ok = 0;
                }
            }
        };
    my %optref = ( wanted => $subref, no_chdir => 1 );
    find ( \%optref , $from );

    return $ok;
}

# Look for all the TST files in the tests/ subfolder and run each of
# them by including them in this file with the use statement

# This is the total number of tests executed and the total failures

my $test_count    = 0;
my $test_failures = 0;
my $fail_messages = '';
my $last_spin     = '';
my $last_symbol   = 0;

sub spin
{
    my ( $msg ) = @_;

    $msg = '' unless ( defined($msg) );

    my @symbols = ('-','/','|','\\');

    print "\b" x length( $last_spin );

    print $symbols[$last_symbol % 4] . " $msg";

    $last_symbol++;

    $last_spin = "  $msg";
}

# ----------------------------------------------------------------------------
#
# test_report   -        Report whether a test passed or not
#
# $ok           Boolean indicating whether the test passed
# $test                 String containing the test executed
# $file                 The name of the file invoking the test
# $line                 The line in the $file where the test can be found
# $context              (Optional) String containing extra context information
#
# ----------------------------------------------------------------------------

sub test_report
{
    my ( $ok, $test, $file, $line, $context ) = @_;

    spin( $line );

    $test_count += 1;

    if ( !$ok ) {
        $fail_messages .= "\n    $file:$line failed '$test'";
        if ( defined( $context ) ) {
                $fail_messages .= " ($context)";
        }
        $test_failures += 1;
        print "Test fail at $file:$line ($test)";
        print " ($context)" if ( defined($context) );
        print "\n";
    } else {
#        print "Test pass at $file:$line ($test) ($context)\n";
    }

    flush STDOUT;
}

# ----------------------------------------------------------------------------
#
# test_assert   -        Perform a test and assert that its result must be true
#
# $file                 The name of the file invoking the test
# $line                 The line in the $file where the test can be found
# $test                 String containing the test to be executed
# $context              (Optional) String containing extra context information
#
# Example: test_assert( 'function(parameter) == 1' ) YOU DO NOT NEED TO GIVE THE
# $file and $line parameters as this script supplies them automatically
#
# ----------------------------------------------------------------------------

sub test_assert
{
    my ( $file, $line, $test, $context ) = @_;

    my $result = $test;
    test_report( $result, $test, $file, $line, $context );

    return $result;
}

# ----------------------------------------------------------------------------
#
# test_assert_equal     -        Perform a test and assert that its result is equal an expected result
#
# $file                 The name of the file invoking the test
# $line                 The line in the $file where the test can be found
# $test                 The result of the test that was just run
# $expected             The expected result
# $context              (Optional) String containing extra context information
#
# Example: test_assert_equal( function(parameter), 'result' )
# Example: test_assert_equal( function(parameter), 3, 'Banana wumpus subsystem' )
#
# YOU DO NOT NEED TO GIVE THE $file and $line parameters as this script supplies them
# automatically
# ----------------------------------------------------------------------------

sub test_assert_equal
{
    my ( $file, $line, $test, $expected, $context ) = @_;
    my $result;

    $test = '' unless (defined($test));
    $expected = '' unless (defined($expected));

    if ( ( $expected ne '' ) && ( $test ne '' ) &&
         !( $expected =~ /[^0-9]/ ) && !( $test =~ /[^0-9]/ ) ) {

        # This int() and is so that we don't get bitten by odd
        # floating point problems

        my $scale = 1e10;
        $result = ( int( $test * $scale ) == int( $expected * $scale ) );
    } else {
        $result = ( $test eq $expected );
    }

    $test =~ s/\015/0x0D/;
    $test =~ s/\012/0x0A/;
    $expected =~ s/\015/0x0D/;
    $expected =~ s/\012/0x0A/;

    # snip long result

    $test = substr( $test, 0, 100 ) . '...' if ( length( $test ) > 100 );
    $test = substr( $expected, 0, 100 ) . '...' if ( length( $expected ) > 100 );

    test_report( $result, "expecting [$expected] and got [$test]", $file, $line, $context );

   return $result;
}

# ----------------------------------------------------------------------------
#
# test_assert_regexp    -  Perform a test and assert that its result matches a regexp
# test_assert_not_regexp - Perform a test and assert that the regexp does not match
#
# $file                 The name of the file invoking the test
# $line                 The line in the $file where the test can be found
# $test                 The result of the test that was just run
# $expected             The expected result in the form of a regexp
# $context              (Optional) String containing extra context information
#
# Example: test_assert_regexp( function(parameter), '^result' )
# Example: test_assert_regexp( function(parameter), 3, 'Banana.+subsystem' )
#
# YOU DO NOT NEED TO GIVE THE $file and $line parameters as this script supplies them
# automatically
# ----------------------------------------------------------------------------

sub test_assert_regexp
{
    my ( $file, $line, $test, $expected, $context ) = @_;
    my $result = ( $test =~ /$expected/m );

    # snip long result

    $test = substr( $test, 0, 100 ) . '...' if ( length( $test ) > 100 );
    $test = substr( $expected, 0, 100 ) . '...' if ( length( $expected ) > 100 );

    test_report( $result, "expecting to match [$expected] and got [$test]", $file, $line, $context );

    return $result;
}

sub test_assert_not_regexp
{
    my ( $file, $line, $test, $expected, $context ) = @_;
    my $result = !( $test =~ /$expected/m );

    test_report( $result, "unexpected match of [$expected]", $file, $line, $context );

    return $result;
}

# MAIN

my @tests = sort { $b cmp $a } glob '*.tst';

# Either match all the possible tests, or take the first argument
# on the command line and use it as a regular expression that must
# match the name of the TST file for the test suite in that file
# to be run

my @patterns= ( '.*' );
@patterns = split( /,/, $ARGV[0] ) if ( $#ARGV == 0 );

my $code = 0;
my %test_results = ();

foreach my $test (@tests) {

    my $runit = 0;

    foreach my $pattern (@patterns) {
        if ( $test =~ /$pattern/ ) {
            $runit = 1;
            last;
        }
    }

    if ( $runit ) {

        # This works by reading the entire suite into the $suite variable
        # and then changing calls to test_assert_equal so that they include
        # the line number and the file they are from, then the $suite is
        # evaluated

        my $current_test_count  = $test_count;
        my $current_error_count = $test_failures;
        use_base_environment();

        print "\nRunning $test... at line: ";
        flush STDOUT;
        $fail_messages = '';
        $last_spin = '';

        my $suite;
        my $ln   = 0;
        open SUITE, "<$test";
        while (<SUITE>) {
            my $line = $_;
            $ln += 1;
            $line =~ s/(test_assert_not_regexp\()/$1 '$test', $ln,/g;
            $line =~ s/(test_assert_regexp\()/$1 '$test', $ln,/g;
            $line =~ s/(test_assert_equal\()/$1 '$test', $ln,/g;
            $line =~ s/(test_assert\()/$1 '$test', $ln,/g;
            $suite .= $line;
        }
        close SUITE;

        my $ran = eval( $suite );

        print "\b" x length( $last_spin );
        flush STDOUT;

        if ( !defined( $ran ) ) {
            print "Error in $test: $@";
            $code = 1;
        }

        if ( $test_failures > $current_error_count ) {
            print "failed (" . ( $test_count - $current_test_count ) . " ok, " . ( $test_failures - $current_error_count ) . " failed)\n";
            print $fail_messages . "\n";
            $code = 1;
        } else {
            print "ok (" . ( $test_count - $current_test_count ) . " ok)";
        }
        $test_results{$test} = { FAIL => ( $test_failures - $current_error_count ), OK => ( $test_count - $current_test_count ) };
        cleanup();
    }

}

print "\n\n";

# Test report
my $test_report = './test-report.txt';
open REPORT, ">$test_report";

print REPORT "\n\n$test_count tests, " . ( $test_count - $test_failures ) . " ok, $test_failures failed\n\n";

# Display a summary of the results if more than 1 test was run:
if ( scalar keys %test_results > 1 ) {
    foreach ( sort keys %test_results ) {
        if ( $test_results{$_}->{FAIL} == 0 ) {
            printf REPORT "   %-25s    PASS\n", $_;
        }
        else {
            printf REPORT "   %-25s %4d failed %4d OK\n", $_, $test_results{$_}->{FAIL}, $test_results{$_}->{OK};
        }
    }
    print REPORT "\n";
}

# Perl version report
printf REPORT "System : %s\n", $English::OSNAME;
printf REPORT "Perl : %f\n", $English::PERL_VERSION;
print REPORT "\n";

my $packing_list .= '../popfile.pck';

print REPORT "Installed Perl modules\n\n";
if ( open PACKING, "<$packing_list" ) {
    while (<PACKING>) {
        if ( /^(REQUIRED|OPTIONAL-([^\t]+))\t([^\t]+)\t([^\r\n]+)/ ) {
            my ( $required, $why, $version, $module ) = ( $1, $2, $3, $4 );

            # Find the module and set $ver to the loaded version, or -1 if
            # the module was not found

            my $ver = -1;
            eval "require $module;
                \$ver = \$${module}::VERSION;
            ";

            if ( $ver == -1 ) {
                printf REPORT "   %-25s    <not installed>\n", $module;
            }
            else {
                printf REPORT "   %-25s    %2.3f\n", $module, $ver;
            }
        }
    }
    close PACKING;
}
print REPORT "\n";

close REPORT;

# Output report to STDOUT
open REPORT, "<$test_report";
while ( <REPORT> ) {
    print;
}
close REPORT;

if ( $test_failures == 0 ) {
    unlink <popfile*.log>;
}
exit $code;
