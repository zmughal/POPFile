# ----------------------------------------------------------------------------
#
# Tests for Configuration.pm
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

use locale;
use POSIX qw( locale_h );
setlocale( LC_COLLATE, 'C' );

use POPFile::Loader;
my $POPFile = POPFile::Loader->new();
$POPFile->CORE_loader_init();
$POPFile->CORE_signals();

my %valid = ( 'POPFile/Logger' => 1,
              'POPFile/MQ'     => 1,
              'POPFile/Configuration' => 1 );

$POPFile->CORE_load( 0, \%valid );
my $c = $POPFile->get_module( 'POPFile/Configuration' );

# Check that we can get and set a parameter
$c->parameter( 'testparam', 'testvalue' );
test_assert_equal( $c->parameter( 'testparam' ), 'testvalue' );

# Check that we can get the full hash of parameters
my @all = $c->configuration_parameters();
test_assert_equal( $#all, 0 );
test_assert_equal( $all[0], 'testparam' );

$POPFile->CORE_initialize();
$POPFile->CORE_config( 1 );
$POPFile->CORE_start();

# Basic tests
test_assert_equal( $c->name(), 'config' );

# Parameters
test_assert_equal( $c->initialize(), 1 );
test_assert_equal( $c->config_( 'piddir' ), './' );
test_assert_equal( $c->global_config_( 'timeout' ), 60 );
test_assert_equal( $c->global_config_( 'msgdir' ), 'messages/' );

# Save STDERR

open my $old_stderr, ">&STDERR";

# Check that the PID file gets created and then deleted and
# contains the correct process ID

$c->config_( 'piddir', '../tests/' );
$c->{pid_delay__} = 1;
open (STDERR, ">stdout.tmp");

test_assert_equal( $c->start(), 1 );
test_assert( $c->check_pid_() );
test_assert_equal( $c->get_pid_(), $$ );

test_assert_equal( $c->start(), 1 );
$c->stop();
test_assert( !$c->check_pid_() );

# enable logging

$c->global_config_( 'debug', 1 );

# Check instance coordination via PID file

$c->start();
$c->{pid_delay__} = 1;

my $process = fork;

if ($process != 0) {
    #parent loop
    test_assert_equal( $c->start(), 0 );
    test_assert( !defined( $c->live_check_() ) );
} elsif ($process == 0) {
    #child loop
    select(undef, undef, undef, $c->{pid_delay__});
    $c->service();
    exit(0);
}

   select(undef, undef, undef, 4 * $c->{pid_delay__});

if ($process != 0) {
    #parent loop
    select(undef, undef, undef, $c->{pid_delay__});
    $c->service();
} elsif ($process == 0) {
    #child loop
    test_assert_equal( $c->start(), 0 );
    test_assert( !defined( $c->live_check_() ) );

    exit(0);
}

close STDERR;
$c->stop();

# Check if unexpected message is recorded

my $l = $POPFile->get_module( 'POPFile/Logger' );
my @last_ten = $l->last_ten();
test_assert_not_regexp( pop @last_ten, /Can't write to the configuration file/, "Unexpected log message." );

# Check that the popfile.cfg was written

my @expected_config = (
 'GLOBAL_ca_file ./certs/ca.pem',
 'GLOBAL_cert_file ./certs/server-cert.pem',
 'GLOBAL_crypt_device ',
 'GLOBAL_crypt_strength 0',
 'GLOBAL_debug 1',
 'GLOBAL_key_file ./certs/server-key.pem',
 'GLOBAL_language English',
 'GLOBAL_message_cutoff 100000',
 'GLOBAL_msgdir messages/',
 'GLOBAL_random_module Crypt::OpenSSL::Random',
 'GLOBAL_session_timeout 1800',
 'GLOBAL_single_user 1',
 'GLOBAL_timeout 60',
 'config_pidcheck_interval 5',
 'config_piddir ../tests/',
 'logger_format default',
 'logger_level 0',
 'logger_logdir ./',
 'testparam testvalue',
);

open FILE, "<popfile.cfg";
foreach ( @expected_config ) {
    my $line = <FILE>;
    chomp $line;
    test_assert_equal( $line, $_ );
}
close FILE;

# Now add a parameter and reload the configuration
# testparam2 gets defined so is kept, testparam3
# is not defined and is discarded on load

open FILE, ">>popfile.cfg";
print FILE "testparam2 testvalue2\n";
print FILE "testparam3 testvalue3\n";
close FILE;

$c->parameter( 'testparam2', 'wrong' );
$c->load_configuration();
test_assert_equal( $c->parameter( 'testparam2' ), 'testvalue2' );
test_assert_equal( $c->parameter( 'testparam3' ), '' );

# Check that parameter upgrading works

my %upgrades = (     'corpus',                   'bayes_corpus',
                     'unclassified_probability', 'bayes_unclassified_probability',
                     'piddir',                   'config_piddir',
                     'debug',                    'GLOBAL_debug',
                     'msgdir',                   'GLOBAL_msgdir',
                     'timeout',                  'GLOBAL_timeout',
                     'logdir',                   'logger_logdir',
                     'localpop',                 'pop3_local',
                     'port',                     'pop3_port',
                     'sport',                    'pop3_secure_port',
                     'server',                   'pop3_secure_server',
                     'separator',                'pop3_separator',
                     'toptoo',                   'pop3_toptoo',
                     'archive',                  'history_archive',
                     'archive_classes',          'history_archive_classes',
                     'archive_dir',              'history_archive_dir',
                     'history_days',             'history_history_days',
                     'language',                 'html_language',
                     'last_reset',               'html_last_reset',
                     'last_update_check',        'html_last_update_check',
                     'localui',                  'html_local',
                     'page_size',                'html_page_size',
                     'password',                 'html_password',
                     'send_stats',               'html_send_stats',
                     'skin',                     'html_skin',
                     'test_language',            'html_test_language',
                     'update_check',             'html_update_check',
                     'ui_port',                  'html_port' );

foreach my $param (sort keys %upgrades) {
    test_assert_equal( $upgrades{$param}, $c->upgrade_parameter__( $param ) );
}

test_assert_equal( 'random', $c->upgrade_parameter__( 'random' ) );

# Check command line parsing
@ARGV = ( '--set', '-config_piddir=test2/' );
test_assert( $c->parse_command_line() );
test_assert_equal( $c->module_config_( 'config', 'piddir' ), 'test2/' );
@ARGV = ( '--set', 'config_piddir=test3/' );
test_assert( $c->parse_command_line() );
test_assert_equal( $c->module_config_( 'config', 'piddir' ), 'test3/' );
@ARGV = ( '--', '-config_piddir' );
open (STDERR, ">stdout.tmp");
test_assert( !$c->parse_command_line() );
close STDERR;
open OUTPUT, "<stdout.tmp";
<OUTPUT>;
my $line = <OUTPUT>;
close OUTPUT;
test_assert_regexp( $line, 'Missing argument for -config_piddir' );
test_assert_equal( $c->module_config_( 'config', 'piddir' ), 'test3/' );
@ARGV = ( '--', '-config_foobar' );
open (STDERR, ">stdout.tmp");
test_assert( !$c->parse_command_line() );
close STDERR;
open OUTPUT, "<stdout.tmp";
<OUTPUT>;
my $line = <OUTPUT>;
close OUTPUT;
test_assert_regexp( $line, 'Unknown option: -config_foobar' );
@ARGV = ( '--', '-config_piddir', 'test4/' );
test_assert( $c->parse_command_line() );
test_assert_equal( $c->module_config_( 'config', 'piddir' ), 'test4/' );
@ARGV = ( '--doesnotexist', '-config_piddir', 'test4/' );
open (STDERR, ">stdout.tmp");
test_assert( !$c->parse_command_line() );
close STDERR;
open OUTPUT, "<stdout.tmp";
<OUTPUT>;
my $line = <OUTPUT>;
close OUTPUT;
test_assert_regexp( $line, 'Unknown option: --doesnotexist' );
@ARGV = ( '--set', 'baz' );
open (STDERR, ">stdout.tmp");
test_assert( !$c->parse_command_line() );
close STDERR;
open OUTPUT, "<stdout.tmp";
<OUTPUT>;
my $line = <OUTPUT>;
close OUTPUT;
test_assert_regexp( $line, 'Bad option: baz' );
@ARGV = ( '--', 'baz' );
open (STDERR, ">stdout.tmp");
test_assert( !$c->parse_command_line() );
close STDERR;
open OUTPUT, "<stdout.tmp";
<OUTPUT>;
my $line = <OUTPUT>;
close OUTPUT;
test_assert_regexp( $line, 'Expected a command line option and got baz' );

# Restore STDERR

open STDERR, ">&", $old_stderr;

# path_join__

test_assert_equal( $c->path_join( 'foo', '/root', 0 ), '/root' );
test_assert_equal( $c->path_join( 'foo', '/', 0 ), '/' );
test_assert_equal( $c->path_join( 'foo', 'c:\\root', 0 ), 'c:\\root' );
test_assert_equal( $c->path_join( 'foo', 'c:\\', 0 ), 'c:\\' );

test_assert( !defined( $c->path_join( 'foo', '/root' ) ) );
test_assert( !defined( $c->path_join( 'foo', '/' ) ) );
test_assert( !defined( $c->path_join( 'foo', 'c:\\root' ) ) );
test_assert( !defined( $c->path_join( 'foo', 'c:\\' ) ) );

test_assert_equal( $c->path_join( '/foo', 'bar' ), '/foo/bar' );
test_assert_equal( $c->path_join( '/foo/', 'bar' ), '/foo/bar' );
test_assert_equal( $c->path_join( 'foo/', 'bar' ), 'foo/bar' );
test_assert_equal( $c->path_join( 'foo', 'bar' ), 'foo/bar' );
test_assert_equal( $c->path_join( 'foo', '\\\\bar', 0 ), '\\\\bar' );
test_assert( !defined( $c->path_join( 'foo', '\\\\bar' ) ) );

# get_user_path (note Makefile sets POPFILE_USER to ../tests/)

test_assert_equal( $c->get_user_path( 'foo' ), '../tests/foo' );
test_assert_equal( $c->get_user_path( '/foo', 0 ), '/foo' );
test_assert( !defined( $c->get_user_path( '/foo' ) ) );
test_assert_equal( $c->get_user_path( 'foo/' ), '../tests/foo/' );
$c->{popfile_user__} = './';
test_assert_equal( $c->get_user_path( 'foo' ), './foo' );
test_assert_equal( $c->get_user_path( '/foo', 0 ), '/foo' );
test_assert( !defined( $c->get_user_path( '/foo' ) ) );
test_assert_equal( $c->get_user_path( 'foo/' ), './foo/' );
$c->{popfile_user__} = '.';
test_assert_equal( $c->get_user_path( 'foo' ), './foo' );
test_assert_equal( $c->get_user_path( '/foo', 0 ), '/foo' );
test_assert( !defined( $c->get_user_path( '/foo' ) ) );
test_assert_equal( $c->get_user_path( 'foo/' ), './foo/' );
$c->{popfile_user__} = '../tests/';

# get_root_path (note Makefile sets POPFILE_ROOT to ../)

test_assert_equal( $c->get_root_path( 'foo' ), '../foo' );
test_assert_equal( $c->get_root_path( '/foo', 0 ), '/foo' );
test_assert( !defined( $c->get_root_path( '/foo' ) ) );
test_assert_equal( $c->get_root_path( 'foo/' ), '../foo/' );
$c->{popfile_root__} = './';
test_assert_equal( $c->get_root_path( 'foo' ), './foo' );
test_assert_equal( $c->get_root_path( '/foo', 0 ), '/foo' );
test_assert( !defined( $c->get_root_path( '/foo' ) ) );
test_assert_equal( $c->get_root_path( 'foo/' ), './foo/' );
$c->{popfile_root__} = '.';
test_assert_equal( $c->get_root_path( 'foo' ), './foo' );
test_assert_equal( $c->get_root_path( '/foo', 0 ), '/foo' );
test_assert( !defined( $c->get_root_path( '/foo' ) ) );
test_assert_equal( $c->get_root_path( 'foo/' ), './foo/' );
$c->{popfile_root__} = '../';

# TODO : multi user test

$POPFile->CORE_stop();

unlink 'stdout.tmp';

1;
