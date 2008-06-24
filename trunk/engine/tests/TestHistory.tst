# ---------------------------------------------------------------------------
#
# Tests for History.pm
#
# Copyright (c) 2004-2006 John Graham-Cumming
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
# ---------------------------------------------------------------------------

use strict;

use POPFile::Loader;
my $POPFile = POPFile::Loader->new();
$POPFile->CORE_loader_init();
$POPFile->CORE_signals();

my %valid = ( 'Classifier/Bayes' => 1,
              'Classifier/WordMangle' => 1,
              'POPFile/Logger' => 1,
              'POPFile/Database' => 1,
              'POPFile/History' => 1,
              'POPFile/MQ'     => 1,
              'POPFile/Configuration' => 1 );

$POPFile->CORE_load( 0, \%valid );
$POPFile->CORE_initialize();
$POPFile->CORE_config( 1 );
$POPFile->CORE_start();

my $l = $POPFile->get_module( 'POPFile/Logger' );
$l->global_config_( 'debug', 1 );
$l->config_( 'level', 2 );

# Check the behaviour of reserve_slot.  It should return a valid
# number and create the associated path (but not the file), check
# that get_slot_file returns the same file as reserve_slot

my $h = $POPFile->get_module( 'POPFile/History' );
my $session = $h->classifier_()->get_administrator_session_key();

history_test( $session );

# Check that the directories are gone too

test_assert( !( -e 'messages/00' ) );
test_assert( !( -e 'messages/00/00' ) );
test_assert( !( -e 'messages/00/00/00' ) );

# Multi user mode tests

$h->global_config_( 'single_user', 0 );

my ( $result, $password ) = $h->classifier_()->create_user( $session, 'test' );
test_assert( defined( $result ) );
test_assert_equal( $result, 0 );
test_assert( defined( $password ) );
test_assert( length $password );

my $user_session = $h->classifier_()->get_session_key( 'test', $password );
test_assert( defined( $user_session ) );

$h->classifier_()->create_bucket( $user_session, 'spam' );
$h->classifier_()->create_bucket( $user_session, 'personal' );
$h->classifier_()->create_bucket( $user_session, 'other' );

history_test( $user_session );

$h->classifier_()->release_session_key( $user_session );
$h->classifier_()->release_session_key( $session );

$POPFile->CORE_stop();

1;

sub history_test
{
    my ( $session ) = @_;

    my $userid = $h->classifier_()->get_user_id_from_session( $session );
    test_assert( defined( $userid ) );

    my %bucketids;
    $bucketids{spam} = $h->classifier_()->get_bucket_id( $session, 'spam' );
    $bucketids{personal} = $h->classifier_()->get_bucket_id( $session, 'personal' );

    my ( $slot, $file ) = $h->reserve_slot( $session );

    test_assert( defined( $slot ) );
    test_assert( !( -e $file ) );
    test_assert_equal( $file, $h->get_slot_file( $slot ) );

    my $path = $file;
    $path =~ s/popfile..\.msg//;
    test_assert( ( -e $path ) );
    test_assert( ( -d $path ) );

    open FILE, ">$file";
    print FILE "test\n";
    close FILE;

    # Check that there is an entry and that it has not yet
    # been committed

    my @result = $h->db_()->selectrow_array( "select committed from history where id = $slot;" );
    test_assert_equal( $#result, 0 );
    test_assert( $result[0] != 1 );

    # Check that release_slot removes the entry from the database
    # and deletes the file, and does clean up the directory

    $h->release_slot( $slot );

    test_assert( !( -e $file ) );
    test_assert( !( -e $path ) );

    @result = $h->db_()->selectrow_array( "select committed from history where id = $slot;" );
    test_assert_equal( $#result, -1 );

    # Now try actually adding an element to the history.  Reserve a slot
    # then commit it and call service to get it added.  Ensure that the
    # slot is now committed and has the right fields

    ( $slot, $file ) = $h->reserve_slot( $session );

    open FILE, ">$file";
    print FILE <<EOF;
Received: Today
From: John Graham-Cumming <nospam\@jgc.org>
To: Everyone <nospam-everyone\@jgc.org>
Cc: People <no-spam-people\@jgc.org>
Subject: re: his is the subject line
Date: Sun, 25 Jul 2020 03:46:32 -0700
Message-ID: 1234

This is the message body
EOF
    close FILE;

    my $size = -s $file;
    my $slot1;

    sleep(2);

    ( $slot1, $file ) = $h->reserve_slot( $session );
    open FILE, ">$file";
print FILE <<EOF;
From: Evil Spammer <nospam\@jgc.org>
To: Someone Else <nospam-everyone\@jgc.org>
Subject: Hot Teen Mortgage Enlargers
Date: Sat, 24 Jul 2020 03:46:32 -0700
Message-ID: 12345

This is the message body
EOF
    close FILE;
    my $size2 = -s $file;

    sleep(2);

    # This is a message for testing evil spammer header tricks or
    # unusual header malformations that may end up parsed into our
    # history database

    # Please list tricks or malformations here
    # Subject: =?UNKNOWN?B??= (Should produce a "header missing" string in the
    #                            database rather than an empty string)
    #
    # To: =?utf-8?q?Do you covet to perc?=
    #     =?utf-8?q?eive precious follo?=
    #     =?utf-8?q?wing day ??=
    #
    # (This should decode to "Do you covet to perceive precious following day ?"

    my $slot2;

    ( $slot2, $file ) = $h->reserve_slot( $session );
    open FILE, ">$file";
    print FILE <<EOF;
From: Evil Spammer who does tricks <nospam\@jgc.org>
To: =?utf-8?q?Do you covet to perc?=
 =?utf-8?q?eive precious follo?=
 =?utf-8?q?wing day ??=
Subject: =?UNKNOWN?B??=
Date: Sat, 24 Jul 2020 03:46:32 -0700
Message-ID: 123456

This is the message body
EOF
    close FILE;
    my $size3 = -s $file;

    $h->commit_slot( $session, $slot1, 'spam', 0 );
    $POPFile->CORE_service( 1 );
    $h->commit_slot( $session, $slot, 'personal', 0 );
    $POPFile->CORE_service( 1 );
    $h->commit_slot( $session, $slot2, 'spam', 0 );
    $POPFile->CORE_service( 1 );
    $POPFile->CORE_service( 1 );
    $POPFile->CORE_service( 1 );

    # Check that the message hash mechanism works

    my $hash = $h->get_message_hash( '1234',
        'Sun, 25 Jul 2020 03:46:32 -0700',
        're: his is the subject line',
        'Today' );

    test_assert_equal( $hash, '79499c2f056a026ef7bb4ab6c1f51a18' );
    test_assert_equal( $slot, $h->get_slot_from_hash( $hash ) );

    # Check that the three messages were correctly inserted into
    # the database

    @result = $h->db_()->selectrow_array( "select * from history where id = $slot and userid = $userid;" );
    test_assert_equal( $#result, 17 );
    test_assert_equal( $result[0], $slot ); # id
    test_assert_equal( $result[1], $userid ); # userid
    test_assert_equal( $result[2], 1 ); # committed
    test_assert_equal( $result[3], 'John Graham-Cumming <nospam@jgc.org>' ); # From
    test_assert_equal( $result[4], 'Everyone <nospam-everyone@jgc.org>' ); # To
    test_assert_equal( $result[5], 'People <no-spam-people@jgc.org>' ); # Cc
    test_assert_equal( $result[6], 're: his is the subject line' ); # Subject
    test_assert_equal( $result[7], 1595673992 );
    test_assert_equal( $result[10], $bucketids{personal} ); # bucketid
    test_assert_equal( $result[11], 0 ); # usedtobe
    test_assert_equal( $result[13], 'john graham-cumming nospam@jgc.org' );
    test_assert_equal( $result[14], 'everyone nospam-everyone@jgc.org' ); # To
    test_assert_equal( $result[15], 'people no-spam-people@jgc.org' ); # Cc
    test_assert_equal( $result[16], 'his is the subject line' ); # Subject
    test_assert_equal( $result[17], $size ); # size

    @result = $h->db_()->selectrow_array( "select * from history where id = $slot1;" );
    test_assert_equal( $#result, 17 );
    test_assert_equal( $result[0], $slot1 ); # id
    test_assert_equal( $result[1], $userid ); # userid
    test_assert_equal( $result[2], 1 ); # committed
    test_assert_equal( $result[3], 'Evil Spammer <nospam@jgc.org>' ); # From
    test_assert_equal( $result[4], 'Someone Else <nospam-everyone@jgc.org>' ); # To
    test_assert_equal( $result[5], '' ); # Cc
    test_assert_equal( $result[6], 'Hot Teen Mortgage Enlargers' ); # Subject
    test_assert_equal( $result[7], 1595587592 );
    test_assert_equal( $result[10], $bucketids{spam} ); # bucketid
    test_assert_equal( $result[11], 0 ); # usedtobe
    test_assert_equal( $result[13], 'evil spammer nospam@jgc.org' ); # From
    test_assert_equal( $result[14], 'someone else nospam-everyone@jgc.org' );
    test_assert_equal( $result[15], '' ); # Cc
    test_assert_equal( $result[16], 'hot teen mortgage enlargers' ); # Subject
    test_assert_equal( $result[17], $size2 ); # size

    @result = $h->db_()->selectrow_array( "select * from history where id = $slot2;" );
    test_assert_equal( $#result, 17 );
    test_assert_equal( $result[0], $slot2 ); # id
    test_assert_equal( $result[1], $userid ); # userid
    test_assert_equal( $result[2], 1 ); # committed
    test_assert_equal( $result[3], 'Evil Spammer who does tricks <nospam@jgc.org>' ); # From
    test_assert_equal( $result[4], 'Do you covet to perceive precious following day ?' ); # To
    test_assert_equal( $result[5], '' ); # Cc
    test_assert_equal( $result[6], '<subject header missing>' ); # Subject
    test_assert_equal( $result[7], 1595587592 );
    test_assert_equal( $result[10], $bucketids{spam} ); # bucketid
    test_assert_equal( $result[11], 0 ); # usedtobe
    test_assert_equal( $result[13], 'evil spammer who does tricks nospam@jgc.org' ); # From
    test_assert_equal( $result[14], 'do you covet to perceive precious following day ?' );
    test_assert_equal( $result[15], '' ); # Cc
    test_assert_equal( $result[16], '' ); # subject
    test_assert_equal( $result[17], $size3 ); # size

    # Try a reclassification and undo

    $h->change_slot_classification( 1, 'spam', $session );

    my @fields = $h->get_slot_fields( 1, $session );
    test_assert_equal( $fields[10], $bucketids{spam} );
    test_assert_equal( $fields[9],  $bucketids{personal} );
    test_assert_equal( $fields[8],  'spam' );

    $h->revert_slot_classification( 1, $session );
    @fields = $h->get_slot_fields( 1, $session );
    test_assert_equal( $fields[10], $bucketids{personal} );
    test_assert_equal( $fields[9],  0 );
    test_assert_equal( $fields[8],  'personal' );

    # Check is_valid_slot

    test_assert( $h->is_valid_slot( 1, $session ) );
    test_assert( !$h->is_valid_slot( 100, $session ) );

    # Now that we've got some data in the history test the query
    # interface

    my $q = $h->start_query( $session );

    test_assert( defined( $q ) );
    test_assert_regexp( $q, '[0-9a-f]{8}' );
    test_assert( defined( $h->{queries__}{$q} ) );

    # Unsorted returns in inserted order

    $h->set_query( $q, '', '', '', 0 );

    test_assert_equal( $h->get_query_size( $q ), 3 );

    my @rows = $h->get_query_rows( $q, 1, 3 );

    test_assert_equal( $#rows, 2 );
    test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
    test_assert_equal( $rows[1][1], 'Evil Spammer <nospam@jgc.org>' );
    test_assert_equal( $rows[2][1], 'John Graham-Cumming <nospam@jgc.org>' );


    my @slot_row = $h->get_slot_fields( $rows[0][0], $session );
    test_assert_equal( join(':',@{$rows[0]}), join(':',@slot_row) );

    # Start with the most basic, give me everything query
    # sorted by from/to address

    $h->set_query( $q, '', '', 'from', 0 );
    test_assert_equal( $h->get_query_size( $q ), 3 );
    @rows = $h->get_query_rows( $q, 1, 3 );
    test_assert_equal( $#rows, 2 );
    test_assert_equal( $rows[0][1], 'Evil Spammer <nospam@jgc.org>' );
    test_assert_equal( $rows[1][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
    test_assert_equal( $rows[2][1], 'John Graham-Cumming <nospam@jgc.org>' );

    $h->set_query( $q, '', '', 'to' ,0 );
    @rows = $h->get_query_rows( $q, 1, 3 );
    test_assert_equal( $h->get_query_size( $q ), 3 );
    test_assert_equal( $#rows, 2 );
    test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
    test_assert_equal( $rows[1][1], 'John Graham-Cumming <nospam@jgc.org>' );
    test_assert_equal( $rows[2][1], 'Evil Spammer <nospam@jgc.org>' );

    $h->set_query( $q, '', '', 'from', 0 );
    test_assert_equal( $h->get_query_size( $q ), 3 );
    @rows = $h->get_query_rows( $q, 1, 1 );
    test_assert_equal( $#rows, 0 );
    test_assert_equal( $rows[0][1], 'Evil Spammer <nospam@jgc.org>' );

    $h->set_query( $q, '', '', 'to', 0 );
    test_assert_equal( $h->get_query_size( $q ), 3 );
    @rows = $h->get_query_rows( $q, 2, 1 );
    test_assert_equal( $#rows, 0 );
    test_assert_equal( $rows[0][1], 'John Graham-Cumming <nospam@jgc.org>' );

    $h->set_query( $q, '', '', 'subject', 0 );
    test_assert_equal( $h->get_query_size( $q ), 3 );
    @rows = $h->get_query_rows( $q, 1, 3 );
    test_assert_equal( $#rows, 2 );
    test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
    test_assert_equal( $rows[1][1], 'John Graham-Cumming <nospam@jgc.org>' );
    test_assert_equal( $rows[2][1], 'Evil Spammer <nospam@jgc.org>' );

    # Now try unsorted and filtered on a specific bucket

    $h->set_query( $q, 'spam', '', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), 2 );
    @rows = $h->get_query_rows( $q, 1, 1 );
    test_assert_equal( $#rows, 0 );
    test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
    test_assert_equal( $rows[0][8], 'spam' );

    $h->set_query( $q, 'personal', '', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), 1 );
    @rows = $h->get_query_rows( $q, 1, 1 );
    test_assert_equal( $#rows, 0 );
    test_assert_equal( $rows[0][1], 'John Graham-Cumming <nospam@jgc.org>' );
    test_assert_equal( $rows[0][8], 'personal' );

    # Try a negated bucket filter

    $h->set_query( $q, 'personal', '', '', 1 );
    test_assert_equal( $h->get_query_size( $q ), 2 );
    @rows = $h->get_query_rows( $q, 1, 2 );
    test_assert_equal( $#rows, 1 );
    test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
    test_assert_equal( $rows[0][8], 'spam' );
    test_assert_equal( $rows[1][1], 'Evil Spammer <nospam@jgc.org>' );
    test_assert_equal( $rows[1][8], 'spam' );

    # Now try a search

    $h->set_query( $q, '', 'john', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), 1 );
    @rows = $h->get_query_rows( $q, 1, 1 );
    test_assert_equal( $#rows, 0 );
    test_assert_equal( $rows[0][1], 'John Graham-Cumming <nospam@jgc.org>' );

    $h->set_query( $q, '', 's', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), 3 );
    @rows = $h->get_query_rows( $q, 1, 3 );
    test_assert_equal( $#rows, 2 );
    test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
    test_assert_equal( $rows[1][1], 'Evil Spammer <nospam@jgc.org>' );
    test_assert_equal( $rows[2][1], 'John Graham-Cumming <nospam@jgc.org>' );

    $h->set_query( $q, '', 'subject line', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), 1 );
    @rows = $h->get_query_rows( $q, 1, 1 );
    test_assert_equal( $#rows, 0 );
    test_assert_equal( $rows[0][1], 'John Graham-Cumming <nospam@jgc.org>' );

    # Try negated search

    $h->set_query( $q, '', 's', '', 1 );
    test_assert_equal( $h->get_query_size( $q ), 0 );

    $h->set_query( $q, '', 'john', '', 1 );
    test_assert_equal( $h->get_query_size( $q ), 2 );
    @rows = $h->get_query_rows( $q, 1, 2 );
    test_assert_equal( $#rows, 1 );
    test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
    test_assert_equal( $rows[1][1], 'Evil Spammer <nospam@jgc.org>' );


    # Now try cases that return nothing

    $h->set_query( $q, '', 'zzz', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), 0 );

    $h->set_query( $q, '', 'zzz', '', 1 );
    test_assert_equal( $h->get_query_size( $q ), 3 );

    $h->set_query( $q, 'other', '', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), 0 );

    $h->set_query( $q, 'other', '', '', 1 );
    test_assert_equal( $h->get_query_size( $q ), 3 );

    # Make sure that we don't requery unless necessary

    $h->set_query( $q, '', 's', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), 3 );
    @rows = $h->get_query_rows( $q, 1, 2 );
    $h->set_query( $q, '', 's', '', 0 );
    test_assert_equal( $#{$h->{queries__}{$q}{cache}}, 1 );
    $h->set_query( $q, '', 't', '', 0 );
    test_assert_equal( $#{$h->{queries__}{$q}{cache}}, -1 );

    $h->stop_query( $q );

    if ( $userid eq 1 ) {
        # Make sure that we can upgrade an existing file with a specific
        # classification

        open MSG, '>' . $h->get_user_path_( $h->global_config_( 'msgdir' ) . 'popfile1=1.msg' );
        print MSG <<EOF;
From: Another Person
To: Someone Else
Subject: Something
Date: Sun, 25 Jul 2000 03:46:31 -0700

This is the body of the message
EOF
        close MSG;

        $size = -s $h->get_user_path_( $h->global_config_( 'msgdir' ) . 'popfile1=1.msg' );

        open CLS, '>' . $h->get_user_path_( $h->global_config_( 'msgdir' ) . 'popfile1=1.cls' );
        print CLS <<EOF;
RECLASSIFIED
other
personal
EOF
        close CLS;

        $h->upgrade_history_files__();

        test_assert( !(-e $h->get_user_path_( $h->global_config_( 'msgdir' ) . 'popfile1=1.cls' ) ) );
        test_assert( !(-e $h->get_user_path_( $h->global_config_( 'msgdir' ) . 'popfile1=1.msg' ) ) );

        $POPFile->CORE_service( 1 );

        $q = $h->start_query( $session );

        $h->set_query( $q, '', '', '', 0 );
        test_assert_equal( $h->get_query_size( $q ), 4 );

        $h->set_query( $q, 'other', '', '', 0 );
        test_assert_equal( $h->get_query_size( $q ), 1 );

        @rows = $h->get_query_rows( $q, 1, 1 );
        test_assert_equal( $#rows, 0 );
        test_assert_equal( $rows[0][1], 'Another Person' );
        test_assert_equal( $rows[0][2], 'Someone Else' );
        test_assert_equal( $rows[0][4], 'Something' );
        test_assert_equal( $rows[0][5], 964521991 );
        test_assert_equal( $rows[0][12], $size );

        $h->stop_query( $q );
    }

    $q = $h->start_query( $session );

    # Now check that deletion works

    $h->set_query( $q, '', '', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), ($userid eq 1?4:3) );
    $h->stop_query( $q );

    $file = $h->get_slot_file( $slot1 );
    test_assert( ( -e $file ) );
    $h->start_deleting();
    $h->delete_slot( 2, 0, $session, 0 );
    $h->stop_deleting();
    test_assert( !( -e $file ) );

    $q = $h->start_query( $session );
    $h->set_query( $q, '', '', '', 0 );
    test_assert_equal( $h->get_query_size( $q ), ($userid eq 1?3:2) );

    @rows = $h->get_query_rows( $q, 1, 3 );
    test_assert_equal( $#rows, 2 );
    if ( $userid eq 1 ) {
        test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
        test_assert_equal( $rows[1][1], 'Another Person' );
        test_assert_equal( $rows[2][1], 'John Graham-Cumming <nospam@jgc.org>' );
    } else {
        test_assert_equal( $rows[0][1], 'Evil Spammer who does tricks <nospam@jgc.org>' );
        test_assert_equal( $rows[1][1], 'John Graham-Cumming <nospam@jgc.org>' );
    }

    # Now try history cleanup, should leave nothing

    $h->stop_query( $q );

    $h->user_config_( 1, 'history_days', 0 ); # Clean up userid = 1 only
    sleep( 2 );
    $h->cleanup_history();

    my $qq = $h->start_query( $session );
    $h->set_query( $qq, '', '', '', 0 );
    test_assert_equal( $h->get_query_size( $qq ), ($userid eq 1?0:2) );
    $h->stop_query( $qq );

    test_assert( !defined( $h->{queries__}{$q} ) );
}

