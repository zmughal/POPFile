# ----------------------------------------------------------------------------
#
# Tests for Module.pm
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

use POPFile::Loader;
my $POPFile = POPFile::Loader->new();
$POPFile->CORE_loader_init();
$POPFile->CORE_signals();

my %valid = ( 'POPFile/Module' => 1,
              'POPFile/Logger' => 1,
              'POPFile/MQ'     => 1,
              'POPFile/Configuration' => 1 );

$POPFile->CORE_load( 0, \%valid );
$POPFile->CORE_initialize();
$POPFile->CORE_config( 1 );
$POPFile->CORE_start();

my $m = new POPFile::Module;
$m->loader( $POPFile );

# Check that base functions return good values

test_assert_equal( $m->initialize(), 1 );
test_assert_equal( $m->start(),      1 );
test_assert_equal( $m->service(),    1 );

# Set and get a name

$m->name( 'test' );
test_assert_equal( $m->name(), 'test' );

# Check that the configuration functions work

$m->config_( 'parameter', 'value' );
test_assert_equal( $m->config_( 'parameter' ), 'value' );
$m->module_config_( 'module', 'mparameter', 'mvalue' );
test_assert_equal( $m->module_config_( 'module', 'mparameter' ), 'mvalue' );
$m->global_config_( 'gparameter', 'gvalue' );
test_assert_equal( $m->global_config_( 'gparameter' ), 'gvalue' );

# Call the null methods
$m->prefork();
$m->postfork();
$m->stop();
$m->reaper();
$m->forked();
$m->deliver();

# Check that the MQ interface functions work

$m->mq_register_( 'NOTYPE', $m );
$m->mq_post_( 'NOTYPE', 'msg', 'param' );

my $mq = $POPFile->get_module( 'POPFile/MQ' );

test_assert_equal( $mq->{waiters__}{NOTYPE}[0], $m );
test_assert_equal( $mq->{queue__}{NOTYPE}[0][0], 'msg' );
test_assert_equal( $mq->{queue__}{NOTYPE}[0][1], 'param' );

# Check that register UI item sends the right message
use Test::MQReceiver;
my $r = new Test::MQReceiver;
$m->mq_register_( 'UIREG', $r );

my $c = $POPFile->get_module( 'POPFile/Configuration' );

$m->register_configuration_item_( 'type', 'name', 'templ', $c );
$mq->service();
my @messages = $r->read();
test_assert_equal( $#messages, 0 );
test_assert_equal( $messages[0][0], 'UIREG' );
test_assert_equal( $messages[0][1][0], 'type' );
test_assert_equal( $messages[0][1][1], 'name' );
test_assert_equal( $messages[0][1][2], 'templ' );
test_assert_equal( $messages[0][1][3], $c );

# Check that the logger function works

$m->global_config_( 'debug', 1 );

$m->log_( 0, 'logmsg' );

my $l = $POPFile->get_module( 'POPFile/Logger' );

test_assert( $l->{last_ten__}[0] =~ /-----------------------/ );
my $version = $l->version();
test_assert( $l->{last_ten__}[1] =~ /POPFile $version starting/ );
test_assert( $l->{last_ten__}[2] =~ /logmsg/ );
# TODO: this test does not work
#test_assert_equal( $l->last_ten(), $m->last_ten_log_entries() );

# Check all the setter/getter functions

test_assert_equal( $m->mq_(), $mq );
test_assert_equal( $m->configuration_(), $c );
$m->forker( 'forker' );
test_assert_equal( $m->forker(), 'forker' );
test_assert_equal( $m->logger_(), $l );
$m->pipeready( 'pr' );
test_assert_equal( $m->pipeready(), 'pr' );
test_assert_equal( $m->alive(), 1 );
$m->alive(0);
test_assert_equal( $m->alive(), 0 );
$m->name( 'newname' );
test_assert_equal( $m->name(), 'newname' );
$m->version( 'vt.t.t' );
test_assert_equal( $m->version(), 'vt.t.t' );

# Test the slurp_ function

open TEMP, ">slurp.tmp";
binmode TEMP;
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "Line with no ending";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "Line with no ending" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "Line ends with CR\012";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "Line ends with CR\012" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "Line ends with LF\015";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "Line ends with LF\015" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "Line ends with CRLF\015\012";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "Line ends with CRLF\015\012" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "LF\012LF\012";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "LF\012" );
test_assert_equal( $m->slurp_( \*TEMP ), "LF\012" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "CR\015CR\015";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "CR\015" );
test_assert_equal( $m->slurp_( \*TEMP ), "CR\015" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "CRLF\015\012CRLF\015\012";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "CRLF\015\012" );
test_assert_equal( $m->slurp_( \*TEMP ), "CRLF\015\012" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "\012\012\015\015\012\015";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "\012" );
test_assert_equal( $m->slurp_( \*TEMP ), "\012" );
test_assert_equal( $m->slurp_( \*TEMP ), "\015" );
test_assert_equal( $m->slurp_( \*TEMP ), "\015\012" );
test_assert_equal( $m->slurp_( \*TEMP ), "\015" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP ".\012.\012.\015.\015\012.\015.";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), ".\012" );
test_assert_equal( $m->slurp_( \*TEMP ), ".\012" );
test_assert_equal( $m->slurp_( \*TEMP ), ".\015" );
test_assert_equal( $m->slurp_( \*TEMP ), ".\015\012" );
test_assert_equal( $m->slurp_( \*TEMP ), ".\015" );
test_assert_equal( $m->slurp_( \*TEMP ), "." );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "2345678901234567890123456789012345678901234567890123456789012345678901234567890\015\0121234567890123456789012345678901234567890\0121234567890123456789012345678901234567890\015";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "2345678901234567890123456789012345678901234567890123456789012345678901234567890\015\012" );
test_assert_equal( $m->slurp_( \*TEMP ), "1234567890123456789012345678901234567890\012" );
test_assert_equal( $m->slurp_( \*TEMP ), "1234567890123456789012345678901234567890\015" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;

# Test the slurp_buffer_ function

open TEMP, ">slurp.tmp";
binmode TEMP;
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert( !defined( $m->slurp_buffer_( \*TEMP, 0 ) ) );
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert( !defined( $m->slurp_buffer_( \*TEMP, 1 ) ) );
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert( !defined( $m->slurp_buffer_( \*TEMP, 100 ) ) );
close TEMP;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "A line of text that ends\015\012And another\015\012\015\012";
close TEMP;

open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert( !defined( $m->slurp_buffer_( \*TEMP, 0 ) ) );
test_assert_equal( $m->slurp_buffer_( \*TEMP, 4 ), "A li" );
test_assert_equal( $m->slurp_buffer_( \*TEMP, 1 ), "n" );
test_assert_equal( $m->slurp_( \*TEMP ), "e of text that ends\015\012" );
test_assert_equal( $m->slurp_buffer_( \*TEMP, 12 ), "And another\015" );
test_assert_equal( $m->slurp_( \*TEMP ), "\012" );
test_assert_equal( $m->slurp_( \*TEMP ), "\015\012" );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
test_assert( !defined( $m->slurp_buffer_( \*TEMP, 0 ) ) );
test_assert( !defined( $m->slurp_buffer_( \*TEMP, 10 ) ) );
close TEMP;

# flush_extra_

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "LF\012LF2\n";
close TEMP;

open TEMP2, ">slurp2.tmp";
open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "LF\012" );
$m->flush_extra_( \*TEMP, \*TEMP2, 0 );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;
close TEMP2;
open TEMP2, "<slurp2.tmp";
test_assert_equal( <TEMP2>, "LF2\n" );
close TEMP2;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "LF\012LF2\n";
close TEMP;

open TEMP2, ">slurp2.tmp";
open TEMP, "<slurp.tmp";
binmode TEMP;
test_assert_equal( $m->slurp_( \*TEMP ), "LF\012" );
$m->flush_extra_( \*TEMP, \*TEMP2, 1 );
test_assert( !defined( $m->slurp_( \*TEMP ) ) );
close TEMP;
close TEMP2;
open TEMP2, "<slurp2.tmp";
test_assert( !defined(<TEMP2>) );
close TEMP2;

open TEMP, ">slurp.tmp";
binmode TEMP;
print TEMP "RF\nRF2\n";
close TEMP;

open TEMP2, ">slurp2.tmp";
open TEMP, "<slurp.tmp";
binmode TEMP;
$m->flush_extra_( \*TEMP, \*TEMP2, 0 );
close TEMP;
close TEMP2;
open TEMP2, "<slurp2.tmp";
my $line = <TEMP2>;
test_assert_equal( $line, "RF\n" );
my $line = <TEMP2>;
test_assert_equal( $line, "RF2\n" );
close TEMP2;

open TEMP, ">slurp.tmp";
print TEMP "LF\nLF2\n";
close TEMP;

open TEMP2, ">slurp2.tmp";
open TEMP, "<slurp.tmp";
binmode TEMP;
$m->flush_extra_( \*TEMP, \*TEMP2, 1 );
close TEMP;
close TEMP2;
open TEMP2, "<slurp2.tmp";
test_assert( !defined(<TEMP2>) );
close TEMP2;

unlink 'slurp.tmp';
unlink 'slurp2.tmp';

# get_user_path_ (note Makefile sets POPFILE_USER to ../tests/)

test_assert_equal( $m->get_user_path_( 'foo' ), '../tests/foo' );
test_assert_equal( $m->get_user_path_( '/foo', 0 ), '/foo' );
test_assert_equal( $m->get_user_path_( '/foo' ), undef );
test_assert_equal( $m->get_user_path_( 'foo/' ), '../tests/foo/' );
$c->{popfile_user__} = './';
test_assert_equal( $m->get_user_path_( 'foo' ), './foo' );
test_assert_equal( $m->get_user_path_( '/foo', 0 ), '/foo' );
test_assert_equal( $m->get_user_path_( '/foo' ), undef );
test_assert_equal( $m->get_user_path_( 'foo/' ), './foo/' );
$c->{popfile_user__} = '.';
test_assert_equal( $m->get_user_path_( 'foo' ), './foo' );
test_assert_equal( $m->get_user_path_( '/foo', 0 ), '/foo' );
test_assert_equal( $m->get_user_path_( '/foo' ), undef );
test_assert_equal( $m->get_user_path_( 'foo/' ), './foo/' );
$c->{popfile_user__} = '../tests/';

# get_root_path_ (note Makefile sets POPFILE_ROOT to ../)

test_assert_equal( $m->get_root_path_( 'foo' ), '../foo' );
test_assert_equal( $m->get_root_path_( '/foo', 0 ), '/foo' );
test_assert_equal( $m->get_root_path_( '/foo' ), undef );
test_assert_equal( $m->get_root_path_( 'foo/' ), '../foo/' );
$c->{popfile_root__} = './';
test_assert_equal( $m->get_root_path_( 'foo' ), './foo' );
test_assert_equal( $m->get_root_path_( '/foo', 0 ), '/foo' );
test_assert_equal( $m->get_root_path_( '/foo' ), undef );
test_assert_equal( $m->get_root_path_( 'foo/' ), './foo/' );
$c->{popfile_root__} = '.';
test_assert_equal( $m->get_root_path_( 'foo' ), './foo' );
test_assert_equal( $m->get_root_path_( '/foo', 0 ), '/foo' );
test_assert_equal( $m->get_root_path_( '/foo' ), undef );
test_assert_equal( $m->get_root_path_( 'foo/' ), './foo/' );
$c->{popfile_root__} = '../';

# is_valid_number_

test_assert(  $m->is_valid_number_(     1,    1, 100 ) );
test_assert(  $m->is_valid_number_(   100,    1, 100 ) );
test_assert( !$m->is_valid_number_(     0,    1, 100 ) );
test_assert( !$m->is_valid_number_(    -1,    1, 100 ) );
test_assert( !$m->is_valid_number_(   101,    1, 100 ) );
test_assert( !$m->is_valid_number_( undef,    1, 100 ) );
test_assert( !$m->is_valid_number_( 'a',      1, 100 ) );
test_assert( !$m->is_valid_number_( '12a',    1, 100 ) );
test_assert(  $m->is_valid_number_( '12',     1, 100 ) );
test_assert(  $m->is_valid_number_(    -1,   -1, 100 ) );
test_assert(  $m->is_valid_number_(   -90, -100, -10 ) );
test_assert( !$m->is_valid_number_( 1.234,    1,   2 ) );

test_assert(  $m->is_valid_number_(     1,     1 ) );
test_assert(  $m->is_valid_number_( 10000,     1 ) );
test_assert( !$m->is_valid_number_(     0,     1 ) );
test_assert(  $m->is_valid_number_(   100, undef, 100 ) );
test_assert(  $m->is_valid_number_( -1000, undef, 100 ) );
test_assert( !$m->is_valid_number_( 10000, undef, 100 ) );
test_assert(  $m->is_valid_number_(     1 ) );
test_assert(  $m->is_valid_number_( 10000 ) );
test_assert(  $m->is_valid_number_( -1000 ) );
test_assert( !$m->is_valid_number_( 'abc' ) );
test_assert( !$m->is_valid_number_( 1.234 ) );

# is_valid_port_

test_assert(  $m->is_valid_port_(     1 ) );
test_assert(  $m->is_valid_port_( 65535 ) );
test_assert( !$m->is_valid_port_(     0 ) );
test_assert( !$m->is_valid_port_(    -1 ) );
test_assert( !$m->is_valid_port_( 65536 ) );
test_assert( !$m->is_valid_port_( 'abc' ) );
test_assert( !$m->is_valid_port_( '12a' ) );
test_assert(  $m->is_valid_port_( '123' ) );
test_assert( !$m->is_valid_port_( 1.234 ) );

$POPFile->CORE_stop();

1;
