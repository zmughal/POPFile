# ----------------------------------------------------------------------------
#
# Tests for Bayes.pm
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

use Classifier::Bayes;
use POPFile::Configuration;
use POPFile::MQ;
use POPFile::Logger;
use Classifier::WordMangle;
use POPFile::History;

# Load the test corpus
my $c = new POPFile::Configuration;
my $mq = new POPFile::MQ;
my $l = new POPFile::Logger;
my $b = new Classifier::Bayes;
my $w = new Classifier::WordMangle;
my $h = new POPFile::History;

$c->configuration( $c );
$c->mq( $mq );
$c->logger( $l );

$c->initialize();

$l->configuration( $c );
$l->mq( $mq );
$l->logger( $l );

$l->initialize();

$w->configuration( $c );
$w->mq( $mq );
$w->logger( $l );

$w->start();

$mq->configuration( $c );
$mq->mq( $mq );
$mq->logger( $l );

$b->configuration( $c );
$b->mq( $mq );
$b->logger( $l );

$h->configuration( $c );
$h->mq( $mq );
$h->logger( $l );

$b->history( $h );
$h->classifier( $b );

$h->initialize();

$b->module_config_( 'html', 'language', 'English' );
$b->{parser__}->mangle( $w );
$b->initialize();

test_assert( $b->start() );
test_assert( $h->start() );

# Test the unclassified_probability parameter

test_assert_equal( $b->{unclassified__}, log(100) );
$b->config_( 'unclassified_weight', 9 );
test_assert( $b->start() );
test_assert_equal( $b->{unclassified__}, log(9) );
$b->config_( 'unclassified_weight', 5 );
test_assert( $b->start() );
test_assert_equal( $b->{unclassified__}, log(5) );

# test the API functions

# Test getting and releasing a session key

my $session;
$session = $b->get_session_key( 'baduser', 'badpassword' );
test_assert( !defined( $session ) );
$session = $b->get_session_key( 'admin', 'badpassword' );
test_assert( !defined( $session ) );

$session = $b->get_session_key( 'admin', '' );
test_assert( defined( $session ) );
test_assert( $session ne '' );
$b->release_session_key( $session );
$session = $b->get_session_key( 'admin', '' );
test_assert( $session ne '' );

# get_all_buckets

my @all_buckets = sort $b->get_all_buckets( $session );
test_assert_equal( $#all_buckets, 3 );
test_assert_equal( $all_buckets[0], 'other' );
test_assert_equal( $all_buckets[1], 'personal' );
test_assert_equal( $all_buckets[2], 'spam' );
test_assert_equal( $all_buckets[3], 'unclassified' );

# is_bucket

test_assert(  $b->is_bucket( $session, 'personal'     ) );
test_assert( !$b->is_bucket( $session, 'impersonal'   ) );
test_assert( !$b->is_bucket( $session, 'unclassified' ) );

# get_pseudo_buckets

my @pseudo_buckets = $b->get_pseudo_buckets( $session );
test_assert_equal( $#pseudo_buckets, 0 );
test_assert_equal( $pseudo_buckets[0], 'unclassified' );

# is_pseudo_bucket

test_assert( !$b->is_pseudo_bucket( $session, 'personal' ) );
test_assert(  $b->is_pseudo_bucket( $session, 'unclassified' ) );
test_assert( !$b->is_pseudo_bucket( $session, 'impersonal2' ) );

test_assert( !$b->is_bucket( $session, 'impersonal2' ) );

# get_buckets

my @buckets = sort $b->get_buckets( $session );
test_assert_equal( $#buckets, 2 );
test_assert_equal( $buckets[0], 'other'    );
test_assert_equal( $buckets[1], 'personal' );
test_assert_equal( $buckets[2], 'spam'     );
test_assert( !defined($buckets[3]) );

# get_bucket_id, get_bucket_name

my $spam_id = $b->get_bucket_id( $session, 'spam' );
test_assert( defined( $spam_id ) );
test_assert_equal( $b->get_bucket_name( $session, $spam_id ), 'spam' );

test_assert( !defined($b->get_bucket_id( $session, 'badbucket' )) );
test_assert_equal( $b->get_bucket_name( $session, -1 ), '' );

# get_bucket_word_count

test_assert_equal( $b->get_bucket_word_count( $session, $buckets[0]), 1785 );
test_assert_equal( $b->get_bucket_word_count( $session, $buckets[1]), 103 );
test_assert_equal( $b->get_bucket_word_count( $session, $buckets[2]), 12114 );

# get_bucket_word_list and prefixes

my @words = $b->get_bucket_word_prefixes( $session, 'personal' );
test_assert_equal( $#words, 1 );
test_assert_equal( $words[0], 'b' );
test_assert_equal( $words[1], 'f' );

@words = $b->get_bucket_word_list( $session, 'personal', 'b' );
test_assert_equal( $#words, 1 );
test_assert_equal( $words[0], 'bar' );
test_assert_equal( $words[1], 'baz' );

@words = $b->get_bucket_word_list( $session, 'personal', 'f' );
test_assert_equal( $#words, 0 );
test_assert_equal( $words[0], 'foo' );

# get_word_count

test_assert_equal( $b->get_word_count( $session ), 14002 );

# get_count_for_word

test_assert_equal( $b->get_count_for_word( $session, $buckets[0], 'foo'), 0 );
test_assert_equal( $b->get_count_for_word( $session, $buckets[1], 'foo'), 1 );
test_assert_equal( $b->get_count_for_word( $session, $buckets[2], 'foo'), 0 );

# Test validation of sql

my $sql = "SELECT * FROM words WHERE word IN ( 'f\x00oo', 'baz' )";
my $sth = $b->validate_sql_prepare_and_execute( $sql );
test_assert_equal( ref $sth, 'DBI::st' );
test_assert_equal( scalar @{$sth->fetchall_arrayref}, 2 );
$sth->finish;
undef $sth;

# same thing with bind-params
$sql = "SELECT * FROM words WHERE word IN ( ?, ? )";
$sth = $b->validate_sql_prepare_and_execute( $sql, "f\x00oo", 'baz' );
test_assert_equal( ref $sth, 'DBI::st' );
test_assert_equal( scalar @{$sth->fetchall_arrayref}, 2 );
$sth->finish;
undef $sth;

test_assert_equal( $b->db_quote("foo\x00bar" ), "'foobar'" );

# get_unique_word_count

test_assert_equal( $b->get_unique_word_count( $session ), 4012 );

# get_bucket_unique_count

test_assert_equal( $b->get_bucket_unique_count( $session, $buckets[0]), 656 );
test_assert_equal( $b->get_bucket_unique_count( $session, $buckets[1]), 3 );
test_assert_equal( $b->get_bucket_unique_count( $session, $buckets[2]), 3353 );

# get_bucket_color

test_assert_equal( $b->get_bucket_color( $session, $buckets[0] ), 'red'   );
test_assert_equal( $b->get_bucket_color( $session, $buckets[1] ), 'green' );
test_assert_equal( $b->get_bucket_color( $session, $buckets[2] ), 'blue'  );
test_assert_equal( $b->get_bucket_color( $session, 'notabucket'), ''      );

# get_buckets

@buckets = $b->get_buckets( $session );
test_assert_equal( $#buckets, 2 );
test_assert_equal( $buckets[0], 'other' );
test_assert_equal( $buckets[1], 'personal' );
test_assert_equal( $buckets[2], 'spam' );

# set_bucket_color

test_assert_equal( $b->get_bucket_color( $session, $buckets[0]), 'red' );
$b->set_bucket_color( $session, $buckets[0], 'yellow' );
test_assert_equal( $b->get_bucket_color( $session, $buckets[0]), 'yellow' );
$b->set_bucket_color( $session, $buckets[0], 'red' );
test_assert_equal( $b->get_bucket_color( $session, $buckets[0]), 'red' );

# get_bucket_parameter

test_assert( !defined( $b->get_bucket_parameter( $session, $buckets[0], 'dummy' ) ) );
test_assert_equal( $b->get_bucket_parameter( $session, $buckets[0], 'quarantine' ), 0 );
test_assert_equal( $b->get_bucket_parameter( $session, $buckets[0], 'subject' ), 1 );

# set_bucket_parameter

test_assert_equal( $b->get_bucket_parameter( $session, $buckets[0], 'quarantine' ), 0 );
test_assert( $b->set_bucket_parameter( $session, $buckets[0], 'quarantine', 1 ) );
test_assert_equal( $b->get_bucket_parameter( $session, $buckets[0], 'quarantine' ), 1 );
test_assert( $b->set_bucket_parameter( $session, $buckets[0], 'quarantine', 0 ) );

test_assert( !$b->set_bucket_parameter( $session, 'badbucket', 'quarantine', 0 ) );

# get_html_colored_message

my $html = $b->get_html_colored_message(  $session, 'TestMails/TestMailParse019.msg' );
open FILE, "<TestMails/TestMailParse019.clr";
my $check = <FILE>;
close FILE;
test_assert_equal( $html, $check );

if ( $html ne $check ) {
    my $color_test = 'get_html_colored_message';
    open FILE, ">$color_test.expecting.html";
    print FILE $check;
    close FILE;
    open FILE, ">$color_test.got.html";
    print FILE $html;
    close FILE;
}

# create_bucket

test_assert( $b->create_bucket( $session, 'zebra' ) );
test_assert( !$b->create_bucket( $session, 'zebra' ) );

@buckets = $b->get_buckets( $session );
test_assert_equal( $#buckets, 3 );
test_assert_equal( $buckets[0], 'other' );
test_assert_equal( $buckets[1], 'personal' );
test_assert_equal( $buckets[2], 'spam' );
test_assert_equal( $buckets[3], 'zebra' );

test_assert_equal( $b->get_bucket_parameter(  $session, 'zebra', 'count' ), 0 );
test_assert_equal( $b->get_bucket_parameter(  $session, 'zebra', 'subject' ), 1 );
test_assert_equal( $b->get_bucket_parameter(  $session, 'zebra', 'quarantine' ), 0 );

test_assert_equal( $b->get_bucket_word_count(  $session, 'zebra' ), 0 );
test_assert_equal( $b->get_bucket_unique_count(  $session, 'zebra' ), 0 );

test_assert_equal( $b->get_word_count( $session ), 14002 );

# rename_bucket

test_assert( $b->rename_bucket(  $session, 'zebra', 'zeotrope' ) );

@buckets = $b->get_buckets( $session );
test_assert_equal( $#buckets, 3 );
test_assert_equal( $buckets[0], 'other' );
test_assert_equal( $buckets[1], 'personal' );
test_assert_equal( $buckets[2], 'spam' );
test_assert_equal( $buckets[3], 'zeotrope' );

test_assert_equal( $b->get_bucket_parameter( $session, 'zeotrope', 'count' ), 0 );
test_assert_equal( $b->get_bucket_parameter( $session, 'zeotrope', 'subject' ), 1 );
test_assert_equal( $b->get_bucket_parameter( $session, 'zeotrope', 'quarantine' ), 0 );

test_assert_equal( $b->get_bucket_word_count( $session, 'zeotrope' ), 0 );
test_assert_equal( $b->get_bucket_unique_count( $session, 'zeotrope' ), 0 );

test_assert_equal( $b->get_word_count( $session ), 14002 );

test_assert( !$b->rename_bucket( $session, 'badbucket', 'badbucket2' ) );
test_assert( !$b->rename_bucket( $session, 'spam',      'zeotrope'   ) );

# add_message_to_bucket

my %words;

open WORDS, "<TestMails/TestMailParse021.wrd";
while ( <WORDS> ) {
    if ( /(.+) (\d+)/ ) {
        $words{$1} = $2;
    }
}
close WORDS;

test_assert( $b->add_message_to_bucket( $session, 'zeotrope', 'TestMails/TestMailParse021.msg' ) );

foreach my $word (keys %words) {
    test_assert_equal( $b->get_base_value_( $session, 'zeotrope', $word ), $words{$word}, "zeotrope: $word $words{$word}" );
}

test_assert( $b->add_message_to_bucket( $session, 'zeotrope', 'TestMails/TestMailParse021.msg' ) );

foreach my $word (keys %words) {
    test_assert_equal( $b->get_base_value_( $session, 'zeotrope', $word ), $words{$word}*2, "zeotrope: $word $words{$word}" );
}

# remove_message_from_bucket

test_assert( $b->remove_message_from_bucket( $session, 'zeotrope', 'TestMails/TestMailParse021.msg' ) );
test_assert( $b->remove_message_from_bucket( $session, 'zeotrope', 'TestMails/TestMailParse021.msg' ) );

test_assert_equal( $b->get_bucket_word_count( $session, 'zeotrope' ), 0 );
test_assert_equal( $b->get_bucket_unique_count( $session, 'zeotrope' ), 0 );

# add_messages_to_bucket

test_assert( $b->add_messages_to_bucket( $session, 'zeotrope', ( 'TestMails/TestMailParse021.msg', 'TestMails/TestMailParse021.msg' ) ) );

foreach my $word (keys %words) {
    test_assert_equal( $b->get_base_value_( $session, 'zeotrope', $word ), $words{$word}*2, "zeotrope: $word $words{$word}" );
}

# Test corrupting the corpus

#open FILE, ">corpus/zeotrope/table";
#print FILE "__CORPUS__ __VERSION__ 2\n";
#close FILE;

#open STDERR, ">temp.tmp";
#test_assert( !$b->load_bucket_( 'zeotrope' ) );
#close STDERR;
#open FILE, "<temp.tmp";
#my $line = <FILE>;
#test_assert_regexp( $line, 'Incompatible corpus version in zeotrope' );
#close FILE;

#open FILE, ">corpus/zeotrope/table";
#close FILE;

#open STDERR, ">temp.tmp";
#test_assert( !$b->load_bucket_( 'zeotrope' ) );
#close STDERR;
#open FILE, "<temp.tmp";
#$line = <FILE>;
#test_assert( !defined( $line ) );
#close FILE;

# create_magnet

test_assert_equal( $b->magnet_count( $session ), 4 );
$b->create_magnet( $session, 'zeotrope', 'from', 'francis' );
test_assert_equal( $b->magnet_count( $session ), 5 );

# get_buckets_with_magnets

my @mags = $b->get_buckets_with_magnets( $session );
test_assert_equal( $#mags, 1 );
test_assert_equal( $mags[0], 'personal' );
test_assert_equal( $mags[1], 'zeotrope' );

# get_magnet_type_in_bucket

my @types = $b->get_magnet_types_in_bucket(  $session, 'zeotrope' );
test_assert_equal( $#types, 0 );
test_assert_equal( $types[0], 'from' );

@types = $b->get_magnet_types_in_bucket(  $session, 'personal' );
test_assert_equal( $#types, 2 );
test_assert_equal( $types[0], 'from' );
test_assert_equal( $types[1], 'subject' );
test_assert_equal( $types[2], 'to' );

# get_magnets

my @magnets = $b->get_magnets(  $session, 'zeotrope', 'from' );
test_assert_equal( $#magnets, 0 );
test_assert_equal( $magnets[0], 'francis' );

@magnets = $b->get_magnets( $session, 'personal', 'from' );
test_assert_equal( $#magnets, 1 );
test_assert_equal( $magnets[0], 'foo' );
test_assert_equal( $magnets[1], 'oldstyle' );
@magnets = $b->get_magnets( $session, 'personal', 'to' );
test_assert_equal( $#magnets, 0 );
test_assert_equal( $magnets[0], 'baz@baz.com' );
@magnets = $b->get_magnets( $session, 'personal', 'subject' );
test_assert_equal( $#magnets, 0 );
test_assert_equal( $magnets[0], 'bar' );

# magnet_match__

test_assert( $b->magnet_match__( $session, 'foo', 'personal', 'from' ) );
test_assert( $b->magnet_match__( $session, 'barfoo', 'personal', 'from' ) );
test_assert( $b->magnet_match__( $session, 'foobar', 'personal', 'from' ) );
test_assert( $b->magnet_match__( $session, 'oldstylemagnet', 'personal', 'from' ) );
test_assert( !$b->magnet_match__( $session, 'fo', 'personal', 'from' ) );
test_assert( !$b->magnet_match__( $session, 'fobar', 'personal', 'from' ) );
test_assert( !$b->magnet_match__( $session, 'oldstylmagnet', 'personal', 'from' ) );

test_assert( $b->magnet_match__( $session, 'baz@baz.com', 'personal', 'to' ) );
test_assert( $b->magnet_match__( $session, 'dobaz@baz.com', 'personal', 'to' ) );
test_assert( $b->magnet_match__( $session, 'dobaz@baz.com.edu', 'personal', 'to' ) );
test_assert( !$b->magnet_match__( $session, 'bam@baz.com', 'personal', 'to' ) );
test_assert( !$b->magnet_match__( $session, 'doba@baz.com', 'personal', 'to' ) );
test_assert( !$b->magnet_match__( $session, 'dobz@baz.com.edu', 'personal', 'to' ) );

$b->create_magnet( $session, 'zeotrope', 'from', '@yahoo.com' );
test_assert( $b->magnet_match__( $session, 'baz@yahoo.com', 'zeotrope', 'from' ) );
test_assert( $b->magnet_match__( $session, 'foo@yahoo.com', 'zeotrope', 'from' ) );
test_assert( !$b->magnet_match__( $session, 'foo@yaho.com', 'zeotrope', 'from' ) );
$b->delete_magnet( $session, 'zeotrope', 'from', '@yahoo.com' );

$b->create_magnet( $session, 'zeotrope', 'from', '__r' );
test_assert( !$b->magnet_match__( $session, 'baz@rahoo.com', 'zeotrope', 'from' ) );
test_assert( $b->magnet_match__( $session, '@__r', 'zeotrope', 'from' ) );
$b->delete_magnet( $session, 'zeotrope', 'from', '__r' );

$b->create_magnet( $session, 'zeotrope', 'from', 'foo$bar' );
test_assert( !$b->magnet_match__( $session, 'foo@bar', 'zeotrope', 'from' ) );
test_assert( !$b->magnet_match__( $session, 'foo$baz', 'zeotrope', 'from' ) );
test_assert( $b->magnet_match__( $session, 'foo$bar', 'zeotrope', 'from' ) );
test_assert( $b->magnet_match__( $session, 'foo$barum', 'zeotrope', 'from' ) );
$b->delete_magnet( $session, 'zeotrope', 'from', 'foo$bar' );

# get_magnet_types

my %mtypes = $b->get_magnet_types( $session );
my @mkeys = keys %mtypes;
test_assert_equal( $#mkeys, 3 );
test_assert_equal( $mtypes{from}, 'From' );
test_assert_equal( $mtypes{to}, 'To' );
test_assert_equal( $mtypes{subject}, 'Subject' );
test_assert_equal( $mtypes{cc}, 'Cc' );

# delete_magnet

$b->delete_magnet( $session, 'zeotrope', 'from', 'francis' );
test_assert_equal( $b->magnet_count( $session ), 4 );

@mags = $b->get_buckets_with_magnets( $session );
test_assert_equal( $#mags, 0 );
test_assert_equal( $mags[0], 'personal' );

# send a message through the mq

test_assert_equal( $b->get_bucket_parameter(  $session, 'zeotrope', 'count' ), 0 );
$b->classified( $session, 'zeotrope' );
$mq->service();
test_assert_equal( $b->get_bucket_parameter(  $session, 'zeotrope', 'count' ), 1 );

# clear_bucket

$b->clear_bucket( $session, 'zeotrope' );
test_assert_equal( $b->get_bucket_word_count( $session, 'zeotrope' ), 0 );

# classify a message using a magnet

$b->create_magnet( $session, 'zeotrope', 'from', 'cxcse231@yahoo.com' );
test_assert_equal( $b->classify( $session, 'TestMails/TestMailParse021.msg' ), 'zeotrope' );
test_assert_equal( $b->{magnet_detail__}, 5 );
test_assert( $b->{magnet_used__} );

# clear_magnets

$b->clear_magnets( $session );
test_assert_equal( $b->magnet_count( $session ), 0 );
@mags = $b->get_buckets_with_magnets( $session );
test_assert_equal( $#mags, -1 );

# delete_bucket

test_assert( $b->delete_bucket( $session, 'zeotrope' ) );

@buckets = $b->get_buckets( $session );
test_assert_equal( $#buckets, 2 );
test_assert_equal( $buckets[0], 'other' );
test_assert_equal( $buckets[1], 'personal' );
test_assert_equal( $buckets[2], 'spam' );

test_assert( !$b->is_bucket( $session, 'zeotrope' ) );
test_assert( !$b->is_pseudo_bucket( $session, 'zeotrope' ) );

test_assert( !$b->delete_bucket( $session, 'badbucket' ) );

# getting and setting values

test_assert_equal( $b->get_value_( $session, 'personal', 'foo' ), log(1/103) );
test_assert_equal( $b->get_sort_value_( $session, 'personal', 'foo' ), log(1/103) );

test_assert_equal( $b->set_value_( $session, 'personal', 'foo', 0 ), 1 );
test_assert_equal( $b->get_value_( $session, 'personal', 'foo' ), 0 );
test_assert_equal( $b->get_sort_value_( $session, 'personal', 'foo' ), $b->{not_likely__}{1} );
test_assert_equal( $b->get_not_likely_( $session ), $b->{not_likely__}{1} );

$b->set_value_( $session, 'personal', 'foo', 100 );
$b->db_update_cache__( $session );
test_assert_equal( $b->get_base_value_( $session, 'personal', 'foo' ), 100 );
test_assert_equal( $b->get_value_( $session, 'personal', 'foo' ), log(100/202) );
test_assert_equal( $b->get_sort_value_( $session, 'personal', 'foo' ), log(100/202) );

# glob the tests directory for files called TestMails/TestMailParse\d+.msg which consist of messages
# to be parsed with the resulting classification in TestMails/TestMailParse.cls

my @class_tests = sort glob 'TestMails/TestMailParse*.msg';

for my $class_test (@class_tests) {
    my $class_file = $class_test;
    $class_file    =~ s/msg/cls/;
    my $class;

    if ( open CLASS, "<$class_file" ) {
        $class = <CLASS>;
        $class =~ s/[\r\n]//g;
        close CLASS;
    }

    test_assert_equal( $b->classify( $session, $class_test ), $class, $class_test );
}

# glob the tests directory for files called TestMails/TestMailParse\d+.msg which consist of messages
# to be sent through classify_and_modify

$b->module_config_( 'html', 'port', 8080 );
$b->module_config_( 'html', 'local', 1 );
$b->module_config_( 'pop3', 'local', 1 );
$b->config_( 'subject_mod_left',  '[' );
$b->config_( 'subject_mod_right', ']' );
$b->config_( 'subject_mod_pos',    1  );

$b->set_bucket_parameter( $session, 'spam', 'subject',    1 );
$b->set_bucket_parameter( $session, 'spam', 'xtc',        1 );
$b->set_bucket_parameter( $session, 'spam', 'xpl',        1 );
$b->set_bucket_parameter( $session, 'spam', 'quarantine', 0 );

my @modify_tests = sort glob 'TestMails/TestMailParse*.msg';

for my $modify_file (@modify_tests) {
    if ( ( open MSG, "<$modify_file" ) && ( open OUTPUT, ">temp.out" ) ) {
        my ( $class, $slot ) = $b->classify_and_modify( $session, \*MSG, \*OUTPUT, 0, '' );
        close MSG;
        close OUTPUT;

        my $output_file = $modify_file;
        $output_file    =~ s/msg/cam/;

        open CAM, "<$output_file";
        open OUTPUT, "<temp.out";
        while ( <OUTPUT> ) {
            my $output_line = $_;
            next if ( $output_line =~ /^X-POPFile-TimeoutPrevention:/ );
            my $cam_line    = <CAM> || '';
            $output_line =~ s/[\r\n]//g;
            $cam_line =~ s/[\r\n]//g;
            if ( ( $output_line ne '.' ) || ( $cam_line ne '' ) ) {
                next if ( $output_line =~ /X-POPFile-Link/ );
                test_assert_equal( $output_line, $cam_line, $modify_file );
            }
        }

        close CAM;
        close OUTPUT;
        $h->delete_slot( $slot );
        unlink( 'temp.out' );
    }
}

# tests for stopwords API

unlink 'stopwords';
open FILE, ">stopwords";
print FILE "notthis\nandnotthat\n";
close FILE;

$b->{parser__}->{mangle__}->load_stopwords();

# get_stopword_list

my @stopwords = sort $b->get_stopword_list( $session );
test_assert_equal( $#stopwords, 1 );
test_assert_equal( $stopwords[0], 'andnotthat' );
test_assert_equal( $stopwords[1], 'notthis' );

# add_stopword

test_assert( $b->add_stopword( $session, 'northat' ) );
@stopwords = sort $b->get_stopword_list( $session );
test_assert_equal( $#stopwords, 2 );
test_assert_equal( $stopwords[0], 'andnotthat' );
test_assert_equal( $stopwords[1], 'northat' );
test_assert_equal( $stopwords[2], 'notthis' );

# remove_stopword

test_assert( $b->remove_stopword( $session, 'northat' ) );
@stopwords = sort $b->get_stopword_list( $session );
test_assert_equal( $#stopwords, 1 );
test_assert_equal( $stopwords[0], 'andnotthat' );
test_assert_equal( $stopwords[1], 'notthis' );

# echo_to_dot_

open FILE, ">messages/one.msg";
print FILE "From: test\@test.com\n";
print FILE "Subject: Your attention please\n\n";
print FILE "This is the body www.supersizewebhosting.com www.gamelink.com\n.\n";
close FILE;

# Four possibilities for echo_to_dot_ depending on whether we give
# it a client handle, a file handle, both or neither

# neither

open MAIL, "<messages/one.msg";
test_assert( $b->echo_to_dot_( \*MAIL ) );
test_assert( eof( MAIL ) );
close MAIL;

# to a handle

open TEMP, ">temp.tmp";
binmode TEMP;
open MAIL, "<messages/one.msg";
binmode MAIL;
test_assert( $b->echo_to_dot_( \*MAIL, \*TEMP ) );
test_assert( eof( MAIL ) );
close MAIL;
close TEMP;

open TEMP, "<temp.tmp";
binmode TEMP;
open MAIL, "<messages/one.msg";
binmode MAIL;
while ( !eof( MAIL ) && !eof( TEMP ) ) {
    my $temp = <TEMP>;
    my $mail = <MAIL>;
    test_assert_regexp( $temp, $mail );
}
test_assert( eof( MAIL ) );
test_assert( eof( TEMP ) );
close MAIL;
close TEMP;

# to a file

unlink( 'temp.tmp' );
open MAIL, "<messages/one.msg";
test_assert( $b->echo_to_dot_( \*MAIL, undef, '>temp.tmp' ) );
test_assert( eof( MAIL ) );
close MAIL;

open TEMP, "<temp.tmp";
open MAIL, "<messages/one.msg";
while ( !eof( MAIL ) && !eof( TEMP ) ) {
    my $temp = <TEMP>;
    my $mail = <MAIL>;
    if ( $mail =~ /^\./ ) {
        last;
    }
    test_assert_regexp( $temp, $mail );
}
test_assert( !eof( MAIL ) );
test_assert( eof( TEMP ) );
close MAIL;
close TEMP;

# both

unlink( 'temp.tmp' );
open TEMP2, ">temp2.tmp";
binmode TEMP2;
open MAIL, "<messages/one.msg";
binmode MAIL;
test_assert( $b->echo_to_dot_( \*MAIL, \*TEMP2, '>temp.tmp' ) );
test_assert( eof( MAIL ) );
close MAIL;
close TEMP2;

open TEMP, "<temp.tmp";
binmode TEMP;
open TEMP2, "<temp2.tmp";
binmode TEMP2;
open MAIL, "<messages/one.msg";
binmode MAIL;
while ( !eof( MAIL ) && !eof( TEMP ) && !eof( TEMP2 ) ) {
    my $temp = <TEMP>;
    my $temp2 = <TEMP2>;
    my $mail = <MAIL>;
    test_assert_regexp( $temp2, $mail );
    last if ( $mail =~ /^\./ );
    test_assert_regexp( $temp, $mail );
}
test_assert( !eof( MAIL ) );
test_assert( eof( TEMP ) );
test_assert( !eof( TEMP2 ) );
close MAIL;
close TEMP;
close TEMP2;

# to a file with before string

unlink( 'temp.tmp' );
open MAIL, "<messages/one.msg";
test_assert( $b->echo_to_dot_( \*MAIL, undef, '>temp.tmp', "before\n" ) );
test_assert( eof( MAIL ) );
close MAIL;

open TEMP, "<temp.tmp";
open MAIL, "<messages/one.msg";
while ( !eof( MAIL ) && !eof( TEMP ) ) {
    my $temp = <TEMP>;
    my $mail = <MAIL>;
    if ( $mail =~ /^\./ ) {
        test_assert_regexp( $temp, 'before' );
        last;
    }
    test_assert_regexp( $temp, $mail );
}
test_assert( eof( MAIL ) );
test_assert( eof( TEMP ) );
close MAIL;
close TEMP;

# echo_to_dot_ with no dot at the end

open FILE, ">messages/one.msg";
print FILE "From: test\@test.com\n";
print FILE "Subject: Your attention please\n\n";
print FILE "This is the body www.supersizewebhosting.com www.gamelink.com\n";
close FILE;

# Four possibilities for echo_to_dot_ depending on whether we give
# it a client handle, a file handle, both or neither

# neither

open MAIL, "<messages/one.msg";
test_assert( !$b->echo_to_dot_( \*MAIL ) );
test_assert( eof( MAIL ) );
close MAIL;

# to a handle

open TEMP, ">temp.tmp";
binmode TEMP;
open MAIL, "<messages/one.msg";
binmode MAIL;
test_assert( !$b->echo_to_dot_( \*MAIL, \*TEMP ) );
test_assert( eof( MAIL ) );
close MAIL;
close TEMP;

open TEMP, "<temp.tmp";
binmode TEMP;
open MAIL, "<messages/one.msg";
binmode MAIL;
while ( !eof( MAIL ) && !eof( TEMP ) ) {
    my $temp = <TEMP>;
    my $mail = <MAIL>;
    test_assert_regexp( $temp, $mail );
}
test_assert( eof( MAIL ) );
test_assert( eof( TEMP ) );
close MAIL;
close TEMP;

# to a file

unlink( 'temp.tmp' );
open MAIL, "<messages/one.msg";
test_assert( !$b->echo_to_dot_( \*MAIL, undef, '>temp.tmp' ) );
test_assert( eof( MAIL ) );
close MAIL;

open TEMP, "<temp.tmp";
binmode TEMP;
open MAIL, "<messages/one.msg";
binmode MAIL;
while ( !eof( MAIL ) && !eof( TEMP ) ) {
    my $temp = <TEMP>;
    my $mail = <MAIL>;
    if ( $mail =~ /^\./ ) {
        last;
    }
    test_assert_regexp( $temp, $mail );
}
test_assert( eof( MAIL ) );
test_assert( eof( TEMP ) );
close MAIL;
close TEMP;

# both

unlink( 'temp.tmp' );
open TEMP2, ">temp2.tmp";
binmode TEMP2;
open MAIL, "<messages/one.msg";
binmode MAIL;
test_assert( !$b->echo_to_dot_( \*MAIL, \*TEMP2, '>temp.tmp' ) );
test_assert( eof( MAIL ) );
close MAIL;
close TEMP2;

open TEMP, "<temp.tmp";
open TEMP2, "<temp2.tmp";
open MAIL, "<messages/one.msg";
binmode TEMP;
binmode TEMP2;
binmode MAIL;
while ( !eof( MAIL ) && !eof( TEMP ) && !eof( TEMP2 ) ) {
    my $temp = <TEMP>;
    my $temp2 = <TEMP2>;
    my $mail = <MAIL>;
    test_assert_regexp( $temp2, $mail );
    test_assert_regexp( $temp, $mail );
}
test_assert( eof( MAIL ) );
test_assert( eof( TEMP ) );
test_assert( eof( TEMP2 ) );
close MAIL;
close TEMP;
close TEMP2;

# to a file with before string

unlink( 'temp.tmp' );
open MAIL, "<messages/one.msg";
test_assert( !$b->echo_to_dot_( \*MAIL, undef, '>temp.tmp', "before\n" ) );
test_assert( eof( MAIL ) );
close MAIL;

open TEMP, "<temp.tmp";
open MAIL, "<messages/one.msg";
while ( !eof( MAIL ) && !eof( TEMP ) ) {
    my $temp = <TEMP>;
    my $mail = <MAIL>;
    test_assert_regexp( $temp, $mail );
}
test_assert( eof( MAIL ) );
test_assert( eof( TEMP ) );
close MAIL;
close TEMP;


# test quarantining of a message

$b->set_bucket_parameter( $session, 'spam', 'quarantine', 1 );

open CLIENT, ">temp.tmp";
open MAIL, "<messages/one.msg";
my ( $class, $slot ) = $b->classify_and_modify( $session, \*MAIL, \*CLIENT, 0, '', 0, 1 );
close CLIENT;
close MAIL;

test_assert_equal( $class, 'spam' );
test_assert( -e $h->get_slot_file( $slot ) );

my @lookfor = ( "--$slot", 'Quarantined Message Detail', ' This is the body', "--$slot", "--$slot"."--", '.' );
open CLIENT, "<temp.tmp";
while ( $#lookfor > -1 ) {
    test_assert( !eof( CLIENT ) );
    my $search = shift @lookfor;
    while ( <CLIENT> ) {
        if ( /^\Q$search\E/ ) {
            last;
        }
    }
}
close CLIENT;

# test no save option

unlink( 'messages/popfile0=0.cls' );
unlink( 'messages/popfile0=0.msg' );
open CLIENT, ">temp.tmp";
open MAIL, "<messages/one.msg";
( $class, $slot ) = $b->classify_and_modify( $session, \*MAIL, \*CLIENT, 1, '', 0, 1 );
close CLIENT;
close MAIL;

test_assert_equal( $class, 'spam' );
test_assert( !(-e $h->get_slot_file( $slot ) ) );

# test no echo option

open CLIENT, ">temp.tmp";
open MAIL, "<messages/one.msg";
( $class, $slot ) = $b->classify_and_modify( $session, \*MAIL, \*CLIENT, 0, '', 0, 0 );
close CLIENT;
close MAIL;

test_assert_equal( $class, 'spam' );
test_assert( -e $h->get_slot_file( $slot ) );

test_assert_equal( ( -s 'temp.tmp' ), 0 );

# test option where we know the classification

open CLIENT, ">temp.tmp";
open MAIL, "<messages/one.msg";
( $class, $slot ) = $b->classify_and_modify( $session, \*MAIL, \*CLIENT, 0, 'other', 0, 1 );
close CLIENT;
close MAIL;

test_assert_equal( $class, 'other' );
test_assert( -e $h->get_slot_file( $slot ) );

# TODO test that stop writes the parameters to disk

# Test Japanese mode

my $have_text_kakasi = 0;

foreach my $prefix (@INC) {
    my $realfilename = "$prefix/Text/Kakasi.pm";
    if (-f $realfilename) {
        $have_text_kakasi = 1;
        last;
    }
}

if ( $have_text_kakasi ) {

    $b->module_config_( 'html', 'language', 'Nihongo' );
    $b->{parser__}->mangle( $w );
    $b->initialize();
    test_assert( $b->start() );

    $b->{parser__}->{lang__} = 'Nihongo';

    # Test Japanese magnet. GOMI means "trash" in Japanese.

    $b->create_bucket( $session, 'gomi' );

    # create_magnet

    $b->clear_magnets( $session );
    $b->create_magnet( $session, 'gomi', 'subject', chr(0xbe) . chr(0xb5) . chr(0xc2) . chr(0xfa) );
    test_assert_equal( $b->classify( $session, 'TestMails/TestNihongo021.msg' ), 'gomi' );

    test_assert_equal( $b->magnet_count( $session ), 1 );
    $b->create_magnet( $session, 'gomi', 'subject', chr(0xa5) . chr(0xc6) . chr(0xa5) . chr(0xb9) . chr(0xa5) . chr(0xc8));
    test_assert_equal( $b->magnet_count( $session ), 2 );

    # get_magnets

    my @magnets = $b->get_magnets( $session, 'gomi', 'subject' );
    test_assert_equal( $#magnets, 1 );
    test_assert_equal( $magnets[0], chr(0xa5) . chr(0xc6) . chr(0xa5) . chr(0xb9) . chr(0xa5) . chr(0xc8) );
    test_assert_equal( $magnets[1], chr(0xbe) . chr(0xb5) . chr(0xc2) . chr(0xfa) );

    # delete_magnet
    $b->delete_magnet( $session, 'gomi', 'subject', chr(0xbe) . chr(0xb5) . chr(0xc2) . chr(0xfa) );
    test_assert_equal( $b->magnet_count( $session ), 1 );

    # add_message_to_bucket

    my %words;

    open WORDS, "<TestMails/TestNihongo021.wrd";
    while ( <WORDS> ) {
        if ( /(.+) (\d+)/ ) {
            $words{$1} = $2;
        }
    }
    close WORDS;

    test_assert( $b->add_message_to_bucket( $session, 'gomi', 'TestMails/TestNihongo021.msg' ) );

    foreach my $word (keys %words) {
        test_assert_equal( $b->get_base_value_( $session, 'gomi', $word ), $words{$word}, "gomi: $word $words{$word}" );
    }

    # get_bucket_word_prefixes

    my @words = $b->get_bucket_word_prefixes( $session, 'gomi' );
    test_assert_equal( $#words, 20 );
    test_assert_equal( $words[18], chr(0xa4) . chr(0xb3) );
    test_assert_equal( $words[19], chr(0xa4) . chr(0xc7) );
    test_assert_equal( $words[20], chr(0xa5) . chr(0xb9) );

    # quarantine test

    $b->set_bucket_parameter( $session, 'gomi', 'quarantine', 1 );

    foreach my $test_message ( 'TestMails/TestNihongo021.msg', 'TestMails/TestNihongo022.msg' ) {
        open CLIENT, ">temp.tmp";
        open MAIL, "<$test_message";
        my ( $class, $slot ) = $b->classify_and_modify( $session, \*MAIL, \*CLIENT, 0, '', 0, 1 );
        close CLIENT;
        close MAIL;
    
        test_assert_equal( $class, 'gomi' );
        test_assert( -e $h->get_slot_file( $slot ) );
    
        open TEMP, "<temp.tmp";
        my $quarantined_message = $test_message;
        $quarantined_message =~ s/\.msg$/.qrn/;
        open MAIL, "<$quarantined_message";
        while ( !eof( MAIL ) && !eof( TEMP ) ) {
            my $mail = <MAIL>;
            next if ( $mail =~ /X-POPFile-TimeoutPrevention/ );
            $mail =~ s/[\r\n]//g;
            my $temp = <TEMP>;
            $temp =~ s/[\r\n]//g;
            test_assert_equal( $temp, $mail );
        }
        close MAIL;
        close TEMP;
    }

    # remove_message_from_bucket

    test_assert( $b->remove_message_from_bucket( $session, 'gomi', 'TestMails/TestNihongo021.msg' ) );
    test_assert_equal( $b->get_bucket_word_count( $session, 'gomi' ), 0 );

} else {
    print "\nWarning: Japanese tests skipped because Text::Kakasi was not found\n";
}

$b->stop();

unlink 'temp.tmp';
unlink 'temp2.tmp';

1;
