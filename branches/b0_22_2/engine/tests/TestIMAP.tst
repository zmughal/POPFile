# ---------------------------------------------------------------------------------------------
#
# Tests for POP3.pm
#
# Copyright (c) 2001-2008 John Graham-Cumming
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
#   Originally created by Manni Heumann (mannih2001@users.sourceforge.net)
#
# ---------------------------------------------------------------------------------------------
# TODO:
# IMAP.pm:
# * fail while statusing
# * duplicate hash value => duplicate message in inbox
# * fail while fetching a part
# * fail while fetching_header_fields
#
# Client.pm
# * ssl connection (difficult)
# * fail while saying something
# * say no to copy msg

use POPFile::Configuration;
use POPFile::MQ;
use POPFile::Logger;
use POPFile::History;
use Services::IMAP;
use UI::HTML;
use Classifier::Bayes;
use Classifier::WordMangle;
use File::Copy;
use HTML::Template;

$SIG{CHLD} = 'IGNORE';

# This test will fork itself. The child will run
# the test server, the parent will run the tests.

my $pid = fork();
die "Cannot fork: $!" unless defined( $pid );

# child: runs the server
if ( $pid == 0 ) {
    system 'perl IMAP_test_server.pl';
    exit 0;
}
# parent: runs the tests:
else {
    # First, start POPFile.
    my ( $c, $mq, $l, $b, $w, $h ) = start_popfile();
    my $im = new Services::IMAP;
    my $session = $b->get_session_key( 'admin', '' );

    # Configure the IMAP module so it will
    # talk to the server.
    configure_imap_module( $im, $c, $mq, $l, $b, $h );
    test_imap_ui( $im );
    configure_imap_module( $im, $c, $mq, $l, $b, $h );
    test_imap_module( $im, $c, $mq, $l, $b, $h );
    test_imap_client( $im );

    $mq->stop();
    $h->stop();
    $im->stop();
    $b->stop();
    $c->stop();
    rmtree( 'imap.spool' );
}


#################################################################################
# Tests for Services::IMAP
# Test classification, reclassification, UI stuff and error handling
##

sub test_imap_module {
    my ( $im, $c, $mq, $l, $b, $h ) = @_;

    my $session = $b->get_session_key( 'admin', '' );
    test_assert( $im->start() );

    # The module is not supposed to do anything when the update
    # interval hasn't elapsed yet:
    my $last_update = time - 2;
    $im->{last_update__} = $last_update;
    $im->service();
    test_assert_equal( $im->{last_update__}, $last_update );
    $im->{last_update__} = 0;

    # Login. The server doesn't have any messages for us yet
    $im->log_( 0, "---- testing login to empty server (uidnext and uidvalidity)" );
    $im->config_( 'login', 'someone' );
    $im->service();

    test_assert_equal( $im->{last_update__}, time );

    foreach my $folder (qw/ INBOX personal spam other / ) {
        my $client = $im->{folders__}{$folder}{imap};
        test_assert( $client );

        # Did we get the UIDVALIDITY values correctly?
        test_assert_equal( $client->uid_validity( $folder ), 1 );

        # Did we note the correct UIDNEXT values?
        test_assert_equal( $client->uid_next( $folder ), 1 );
    }

    # We change the uidvalidity and see whether the module detects
    # the difference between the (manipulated) stored value and
    # the value from the server.
    my $client = $im->{folders__}{spam}{imap};
    $client->uid_validity( 'spam', 50 );
    $im->{last_update__} = 0;
    $im->service();
    test_assert_equal( $client->uid_validity( 'spam' ), 1 );

    $im->disconnect_folders__();

    # Let the INBOX have four new messages, make sure they are
    # classified correctly and moved to the according folders.
    $im->log_( 0, "---- testing classify with 6 new messages" );
    $im->config_( 'login', 'new_INBOX_007_003_004_005_013_021' );
    $b->create_magnet( $session, 'other', 'from', 'cxcse231@yahoo.com' );
    $im->{last_update__} = 0;
    $im->service();
    $mq->service();
    $h->service();

    # The message must have ended up as spam and must have been
    # moved to the spam folder, except for the magneted msg.

    test_assert( -e 'imap.spool/spam/1' );
    test_assert( -e 'imap.spool/spam/2' );
    test_assert( -e 'imap.spool/spam/3' );
    test_assert( -e 'imap.spool/spam/4' );
    test_assert( -e 'imap.spool/spam/5' );
    test_assert( -e 'imap.spool/other/1' );

    # The module should not allow reclassification to the same
    # bucket.
    my $hash = ( $h->get_slot_fields( 1 ) )[6];
    test_assert( ! $im->can_reclassify__( $hash, 'spam' ) );
    # If the hash is unknown, it should reclassify either
    test_assert( ! $im->can_reclassify__( 'hash', 'other' ) );
    # But with a good hash and a valid bucket:
    test_assert( $im->can_reclassify__( $hash, 'other' ) );

    # move msgs 1, 2, and 3 to folder personal
    $client = $im->{folders__}{'spam'}{imap};
    test_assert( $client );
    test_assert_equal( $client->select( 'spam' ), 1 );
    test_assert_equal( $client->move_message( 1, 'personal' ), 1 );
    test_assert_equal( $client->move_message( 2, 'personal' ), 1 );
    test_assert_equal( $client->move_message( 3, 'personal' ), 1 );

    # move msgs 4 and 5 to folder other
    test_assert_equal( $client->move_message( 4, 'other' ), 1 );
    test_assert_equal( $client->move_message( 5, 'other' ), 1 );

    # let the IMAP module have a look
    $im->log_( 0, "---- Testing reclassification" );
    $im->{last_update__} = 0;
    $im->service();
    $mq->service();
    $h->service();

    # check classification stored in history
    test_assert_equal( ($h->get_slot_fields( 1 ))[8], 'personal' );
    test_assert_equal( ($h->get_slot_fields( 2 ))[8], 'personal' );
    test_assert_equal( ($h->get_slot_fields( 3 ))[8], 'personal' );
    test_assert_equal( ($h->get_slot_fields( 4 ))[8], 'other' );
    test_assert_equal( ($h->get_slot_fields( 5 ))[8], 'other' );

    # check that history knows that the msgs were reclassfified
    test_assert_equal( ($h->get_slot_fields( 1 ))[9], 4 );
    test_assert_equal( ($h->get_slot_fields( 2 ))[9], 4 );
    test_assert_equal( ($h->get_slot_fields( 3 ))[9], 4 );
    test_assert_equal( ($h->get_slot_fields( 4 ))[9], 4 );
    test_assert_equal( ($h->get_slot_fields( 5 ))[9], 4 );

    # history should also know about the used manget
    test_assert_equal( ($h->get_slot_fields( 6 ))[11], 'cxcse231@yahoo.com' );

    # get the msgs hashes and ask the imap module whether those messages
    # can be reclassified. It should say 'no!'
    foreach ( 1 .. 6 ) {
        $hash = ($h->get_slot_fields( $_ ))[6];
        test_assert_equal( $im->can_reclassify__( $hash, 'spam' ), undef );
        test_assert( ! $im->can_classify__( $hash ) );
    }

    # check that a fresh classification confirms the reclassification
    test_assert_equal( $b->classify( $session, 'TestMails/TestMailParse007.msg' ), 'personal' );

    # Now let's see whether the words in one of the reclassified messages
    # actually ended up in the corpus

    my %words;

    open WORDS, "<TestMails/TestMailParse013.wrd";
    while ( <WORDS> ) {
        if ( /(.+) (\d+)/ ) {
            $words{$1} = $2;
        }
    }
    close WORDS;

    foreach my $word (keys %words) {
        test_assert( $b->get_count_for_word( $session, 'other', $word ) > 0, "other: $word $words{$word}" );
    }

    $im->disconnect_folders__();

    # Change the UIDVALIDITY values and then log in again
    $im->log_( 0, '---- changing uidvalies' );
    $im->config_('login', 'someone');
    my $uidvalis = $im->config_('uidvalidities');
    my $newvalis = $uidvalis;
    $newvalis =~ s/-->(\d+)-->/'-->' . ( $1 +2 ) . '-->'/ge;
    $im->config_( 'uidvalidities', $newvalis );
    $im->{last_update__} = 0;
    $im->service();
    $im->disconnect_folders__();
    test_assert_equal( $im->config_( 'uidvalidities' ), $uidvalis );
    $im->config_( 'uidvalidities', $uidvalis );

    # The module is supposed to retrieve the list of mailboxes if it
    # hasn't got any yet.
    $im->log_( 0, '---- using invalid uidvalidities' );
    $im->{mailboxes__} = [];
    $im->{last_update__} = 0;
    $im->service();
    test_assert_equal( scalar @{$im->{mailboxes__}}, 5 );
    $im->disconnect_folders__();

    # Give an invalid configuration string for uidnexts and uidvalidities
    # and see whether we react in a graceful manner
    $newvalis = $uidvalis;
    $newvalis =~ s/-->(\d+)-->/-->-->/;
    $im->config_( 'uidvalidities', $newvalis );
    $im->{last_update__} = 0;
    $im->service();
    test_assert_equal( $im->config_('uidvalidities'), $uidvalis );

    # What happens when we get unsolicited responses from the server?
    $im->disconnect_folders__();
    $im->log_( 0, "---- Testing unsolicited BYE response" );
    $im->config_( 'login', 'unsolicitedBYE' );
    $im->{last_update__} = 0;
    $im->service();
    test_assert( ! %{$im->{folders__}}, 'Folder hash is empty' );


    # Check what happens when we time out
    $im->log_( 0, "---- Testing time-out behaviour for the module." );
    $im->config_( 'login', 'timeOut1' );
    $im->{last_update__} = 0;
    $im->service();
    $im->disconnect_folders__();

    # Make the server drop the connection and make sure we don't crash
    $im->log_( 0, "---- Testing dropped-connection behaviour for the module." );
    $im->config_( 'login', 'dropConnection3' );
    $im->{last_update__} = 0;
    $im->service();

    $im->log_( 0, "---- Testing train_on_archive." );
    $im->config_( login => 'new_INBOX_007_003_004_005_013_021' );
    $im->{last_update__} = 0;
    $client = $im->new_imap_client();
    $client->select( 'INBOX' );
    $client->move_message( 7, 'personal' );
    $client->move_message( 8, 'other' );
    $client->move_message( 9, 'spam' );
    $client->move_message( 10, 'personal' );
    $client->move_message( 11, 'other' );
    $client->move_message( 12, 'spam' );

    $im->config_( 'training_mode', 1 );
    $im->config_( login => 'someone' );
    $im->service();
    test_assert_equal( $im->config_( 'training_mode' ), 0 );
}


#################################################################################
# Tests for Services::IMAP::Client
# Test the code that actually talks to the IMAP
# server
##

sub test_imap_client {
    my $im = shift;

    $im->log_( 0, "---- Testing various client methods" );
    $im->config_( 'login', 'someone' );
    my $client = $im->new_imap_client();

    test_assert( $client, "Have we got a valid imap client?" );
    test_assert( $client->connected() );
    my @mailboxes = $client->get_mailbox_list();
    test_assert_equal( scalar @mailboxes, 5 );

    test_assert_equal( 1, $client->noop() );
    my $info = $client->status( 'INBOX' );
    test_assert_equal( $info->{UIDNEXT}, 13 );
    test_assert_equal( $info->{UIDVALIDITY}, 1 );
    test_assert_equal( $client->select( 'INBOX' ), 1 );

    test_assert_equal( $client->uid_next( 'INBOX' ), 7  );
    test_assert_equal( $client->uid_validity( 'INBOX' ), 1 );

    $client->uid_next( 'INBOX', 100 );
    test_assert_equal( $client->uid_next( 'INBOX' ), 100 );

    $client->uid_validity( 'INBOX', 99 );
    test_assert_equal( $client->uid_validity( 'INBOX' ), 99 );

    $client->uid_validity( 'INBOX', 1 );
    test_assert_equal( $client->uid_validity( 'INBOX' ), 1 );

    test_assert_equal( 1, $client->expunge() );

    $client->say( 'unknown command' );
    test_assert_equal( $client->get_response(), -1 );

    test_assert_equal( $client->select( 'personal' ), 1 );
    $client->uid_next( 'personal', 0 );
    my @msgs = $client->get_new_message_list();
    test_assert_equal( scalar @msgs, 5 );

    $client->move_message( 1, 'spam' );
    $client->uid_next( 'spam', 0 );
    $client->select( 'spam' );
    @msgs = $client->get_new_message_list();
    test_assert_equal( scalar @msgs, 3 );

    test_assert( $client->logout());

    $im->log_( 0, "---- testing client methods with 3 new messages." );
    $im->config_( 'login', 'new_INBOX_003_002_001' );
    $client = $im->new_imap_client();
    $client->uid_next( 'INBOX', 0 );
    @msgs = $client->get_new_message_list_unselected( 'INBOX' );
    test_assert_equal( scalar @msgs, 3 );

    # Now get the messages and compare them to the originals
    foreach my $msg_number ( qw/ 003 002 001 / ) {
        my $uid = shift @msgs;
        my ( $ok, @msg_lines ) = $client->fetch_message_part( $uid, '' );
        test_assert_equal( $ok, 1 );
        my $filename = "TestMails/TestMailParse$msg_number.msg";
        if ( open my $ORG, '<', $filename ) {
            my @org_lines = ();
            while ( <$ORG> ) {
                push @org_lines, $_;
            }
            close $ORG;
            foreach my $org_line ( @org_lines ) {
                my $msg_line = shift @msg_lines;
                $org_line =~ s/[\r\n]//g;
                $msg_line =~ s/[\r\n]//g;
                test_assert_equal( $msg_line, $org_line );
            }
            $uid++;
        }
        else {
            die "Could not open message $filename ($!)";
        }
    }

    $im->log_( 0, "---- Testing failing login behaviour for client" );
    $im->config_( 'login', 'fail' );
    $im->new_imap_client();
    test_assert_equal( $im->{imap_error}, 'NO_LOGIN' );

    $im->log_( 0, "---- testing time-out behaviour in client" );
    $im->config_( 'login', 'timeOut1' );
    $client = $im->new_imap_client();
    eval {
        $client->get_mailbox_list();
    };
    test_assert( $@ );
    test_assert_regexp( $@, 'POPFILE-IMAP-EXCEPTION: ' );
    # sleep 3;

    $im->log_( 0, "---- testing something with the client here." );
    $im->config_( 'login', 'new_INBOX_003_002_001' );

    $im->log_( 0, "shutting down the test server by logging in as user 'shutdown'." );
    # close the server process by logging in as user "shutdown"
    $im->config_( 'login', 'shutdown' );
    eval {
        $im->new_imap_client();
    };
    test_assert( $im->{imap_error} );
    test_assert_equal( $im->{imap_error}, 'NO_LOGIN' );
}

#################################################################################
# test_imap_ui
# Test the UI widgets of the IMAP module. All we are going to have to do
# here is test the two methods configure_item and validate_item
##

sub test_imap_ui {
    my $im = shift;

    # We are going to set up a template object that we will pass into
    # configure_item and validate_item.
    # Later, we'll test whether the correct parameters are set to the
    # correct values.

    # Here's a list of all the templates we have to test:
    #   imap-connection-details.thtml
    #   imap-watch-folders.thtml
    #   imap-watch-more-folders.thtml
    #   imap-bucket-folders.thtml
    #   imap-update-mailbox-list.thtml
    #   imap-options.thtml

    # We also need to provide those methods with a language hash:
    my $html = UI::HTML->new();
    $html->{configuration__} = $im->{configuration__};
    $html->load_language( 'English' );
    my $language = $html->{language__};

    # Start with the connection details
    # imap-connection-details.thtml

    my $tmpl = HTML::Template->new( filename => '../skins/default/imap-connection-details.thtml' );

    # Test the template itself. Does it contain all the variables that it must contain
    test_assert_equal( $tmpl->query( name => 'IMAP_hostname'), 'VAR' );
    test_assert_equal( $tmpl->query( name => 'IMAP_port' ), 'VAR' );
    test_assert_equal( $tmpl->query( name => 'IMAP_password' ), 'VAR' );
    test_assert_equal( $tmpl->query( name => 'IMAP_login' ), 'VAR' );

    # Now let the IMAP module populate the template
    $im->config_( hostname => 'some host' );
    $im->config_( port => 1234 );
    $im->config_( password => 'some password' );
    $im->config_( login => 'some login' );

    $im->configure_item( 'imap_0_connection_details', $tmpl, $language );

    test_assert_equal( $tmpl->param( 'IMAP_hostname'), 'some host' );
    test_assert_equal( $tmpl->param( 'IMAP_port' ), 1234 );
    test_assert_equal( $tmpl->param( 'IMAP_password' ), 'some password' );
    test_assert_equal( $tmpl->param( 'IMAP_login' ), 'some login' );


    # imap-watch-folders.thtml
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-watch-folders.thtml' );

    test_assert_equal( $tmpl->query( name => 'IMAP_if_mailboxes' ), 'VAR' );
    test_assert_equal( $tmpl->query( name => 'IMAP_loop_watched_folders' ), 'LOOP' );
    test_assert_equal( $tmpl->query( name => ['IMAP_loop_watched_folders', 'IMAP_loop_counter'] ), 'VAR' );
    test_assert_equal( $tmpl->query( name => ['IMAP_loop_watched_folders', 'IMAP_WatchedFolder_Msg' ] ), 'VAR' );
    test_assert_equal( $tmpl->query( name => ['IMAP_loop_watched_folders', 'IMAP_loop_mailboxes'] ), 'LOOP' );
    test_assert_equal( $tmpl->query( name => ['IMAP_loop_watched_folders', 'IMAP_loop_mailboxes', 'IMAP_mailbox' ] ), 'VAR' );
    test_assert_equal( $tmpl->query( name => ['IMAP_loop_watched_folders', 'IMAP_loop_mailboxes', 'IMAP_selected' ] ), 'VAR' );

    # We set both, the mailboxes__ arrayref and the list of watched folders, to be empty
    $im->{mailboxes__} = [];
    $im->config_( 'watched_folders', '' );
    $im->configure_item( 'imap_1_watch_folders', $tmpl, $language );
    test_assert( ! $tmpl->param( 'IMAP_if_mailboxes' ) );

    # Now we set only one to a non-empty list
    $im->{mailboxes__} = [ 1 ];
    $im->configure_item( 'imap_1_watch_folders', $tmpl, $language );
    test_assert( ! $tmpl->param( 'IMAP_if_mailboxes' ) );

    $im->{mailboxes__} = [];
    $im->watched_folders__( 'INBOX' );
    $im->configure_item( 'imap_1_watch_folders', $tmpl, $language );
    test_assert( ! $tmpl->param( 'IMAP_if_mailboxes' ) );

    # Finally, both get a value
    $im->{mailboxes__} = ['INBOX','something', 'other', 'second'];
    $im->watched_folders__( 'INBOX', 'second' );
    $im->configure_item( 'imap_1_watch_folders', $tmpl, $language );
    test_assert( $tmpl->param( 'IMAP_if_mailboxes' ) );

    # This should be an arrayref containing a hash for each
    # iteration of the loop, ie for each watched folder
    my $params =  $tmpl->param('IMAP_loop_watched_folders');

    # since we have two watched folders, we should have to elements
    # in our params array
    test_assert_equal( scalar @$params, 2 );

    my $inner_loop = $params->[0]->{IMAP_loop_mailboxes};
    # since we have four mailboxes, this inner loop should have
    # four elements
    test_assert_equal( scalar @$inner_loop, 4 );
    my %included_mailboxes = ();
    foreach ( @$inner_loop ) {
        $included_mailboxes{ $_->{IMAP_mailbox} } = 1;
        if ( $_->{IMAP_mailbox} eq 'INBOX' ) {
            test_assert_equal( $_->{IMAP_selected}, 'selected="selected"' );
        }
        else {
            test_assert_equal( $_->{IMAP_selected}, '' );
        }
    }
    test_assert_equal( scalar keys %included_mailboxes, 4 );
    foreach ( @{$im->{mailboxes__}} ) {
        test_assert_equal( $included_mailboxes{ $_ }, 1 );
    }

    # and the same for the second watched folder:
    $inner_loop = $params->[1]->{IMAP_loop_mailboxes};
    # since we have four mailboxes, this inner loop should have
    # four elements
    test_assert_equal( scalar @$inner_loop, 4 );
    %included_mailboxes = ();
    foreach ( @$inner_loop ) {
        $included_mailboxes{ $_->{IMAP_mailbox} } = 1;
        if ( $_->{IMAP_mailbox} eq 'second' ) {
            test_assert_equal( $_->{IMAP_selected}, 'selected="selected"' );
        }
        else {
            test_assert_equal( $_->{IMAP_selected}, '' );
        }
    }
    test_assert_equal( scalar keys %included_mailboxes, 4 );
    foreach ( @{$im->{mailboxes__}} ) {
        test_assert_equal( $included_mailboxes{ $_ }, 1 );
    }

    test_assert_equal( $params->[0]->{IMAP_loop_counter}, 1 );
    test_assert_equal( $params->[1]->{IMAP_loop_counter}, 2 );


    # imap-watch-more-folders.thtml
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-watch-more-folders.thtml' );

    test_assert_equal( $tmpl->query( name => 'IMAP_if_mailboxes' ), 'VAR' );

    $im->{mailboxes__} = [];
    $im->configure_item( 'imap_2_watch_more_folders', $tmpl, $language );
    test_assert( ! $tmpl->param( 'IMAP_if_mailboxes' ) );

    $im->{mailboxes__} = [1];
    $im->configure_item( 'imap_2_watch_more_folders', $tmpl, $language );
    test_assert( $tmpl->param( 'IMAP_if_mailboxes' ) );


    # imap-bucket-folders.thtml
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-bucket-folders.thtml' );
    test_assert_equal( $tmpl->query( name => 'IMAP_if_mailboxes' ), 'VAR' );
    $im->{mailboxes__} = [];
    $im->configure_item( 'imap_3_bucket_folders', $tmpl, $language );
    test_assert( ! $tmpl->param( 'IMAP_if_mailboxes' ) );

    $im->{mailboxes__} = ['INBOX', 'spam', 'other', 'personal', 'unclassified'];
    $im->watched_folders__( 'INBOX' );

    $im->configure_item( 'imap_3_bucket_folders', $tmpl, $language );
    test_assert( $tmpl->param( 'IMAP_if_mailboxes' ) );
    my $selected = 0;
    foreach my $record ( @{$tmpl->param('imap_loop_buckets')} ) {
        $record->{IMAP_Bucket_Header} =~ m|<b>(.+)</b>|;
        my $bucket = $1;
        test_assert( $bucket );
        my $inner_loop = $record->{IMAP_loop_mailboxes};
        test_assert( $inner_loop );
        test_assert_equal( ref $inner_loop, 'ARRAY' );

        foreach my $inner_record ( @$inner_loop ) {
            if ( $inner_record->{IMAP_mailbox} eq $bucket ) {
                test_assert_equal( $inner_record->{IMAP_selected}, 'selected="selected"' );
                $selected++;
            }
            else {
                test_assert_equal( $inner_record->{IMAP_selected}, '' );
            }
        }
    }
    test_assert_equal( $selected, 4 );
    test_assert_equal( $selected, scalar @{$tmpl->param('imap_loop_buckets')} );


    # imap-update-mailbox-list.thtml
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-update-mailbox-list.thtml' );
    test_assert_equal( $tmpl->query( name => 'IMAP_if_connection_configured' ), 'VAR' );
    $im->config_( 'hostname', '' );
    $im->configure_item( 'imap_4_update_mailbox_list', $tmpl, $language );
    test_assert( ! $tmpl->param('IMAP_if_connection_configured' ) );
    $im->config_( 'hostname', 'test-host' );
    $im->configure_item( 'imap_4_update_mailbox_list', $tmpl, $language );
    test_assert( $tmpl->param('IMAP_if_connection_configured' ) );

    # imap-options.thtml
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-options.thtml' );
    $im->config_( 'expunge', 1 );
    $im->configure_item( 'imap_5_options', $tmpl, $language );
    test_assert_equal( $tmpl->param( 'IMAP_expunge_is_checked' ), 'checked="checked"' );

    $im->config_( 'expunge', 0 );
    $im->config_( 'update_interval', 99 );
    $im->configure_item( 'imap_5_options', $tmpl, $language );
    test_assert_equal( $tmpl->param( 'IMAP_expunge_is_checked' ), '' );
    test_assert_equal( $tmpl->param( 'IMAP_interval', '99' ) );

    # We now will have to test validate_item.

    # imap-connection-details.thtml
    my $form = {};
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-connection-details.thtml' );
    $form->{update_imap_0_connection_details} = 1;
    $form->{imap_hostname} = 'hostname';
    $form->{imap_port} = 123;
    $form->{imap_login} = 'username';
    $form->{imap_password} = 'secret';
    $form->{imap_use_ssl} = 1;
    $im->validate_item( 'imap_0_connection_details', $tmpl, $language, $form );
    test_assert_equal( $im->config_( 'use_ssl' ), 1 );
    test_assert_equal( $im->config_( 'password' ), 'secret' );
    test_assert_equal( $im->config_( 'login' ), 'username' );
    test_assert_equal( $im->config_( 'port' ), 123 );
    test_assert_equal( $im->config_( 'hostname' ), 'hostname' );

    $form->{imap_use_ssl} = undef;
    $im->validate_item( 'imap_0_connection_details', $tmpl, $language, $form );
    test_assert_equal( $im->config_( 'use_ssl' ), 0 );

    # After updating the connection details, the module must disconnect
    # and empty its folders hash:
    test_assert_equal( scalar keys %{$im->{folders__}}, 0 );

    # Now test some values that should NOT validate:

    # all the parameters need to be set to something (except for use_ssl)
    foreach ( qw/ imap_hostname imap_port imap_login imap_password / ) {
        my %invalid_form = %$form;
        delete $invalid_form{$_};
        $tmpl = HTML::Template->new( filename => '../skins/default/imap-connection-details.thtml' );
        $im->validate_item( 'imap_0_connection_details', $tmpl, $language, \%invalid_form );
        my $template_param = $_;
        $template_param =~ s/imap_//;
        $template_param = 'IMAP_connection_if_' . $template_param . '_error';
        test_assert_equal( $tmpl->param( $template_param ), 1, $_ );
    }


    # imap-watch-folders.thtml
    $form = {};
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-watch-folders.thtml' );
    $form->{imap_folder_1} = 'first watched folder';
    $form->{imap_folder_2} = 'second watched folder';
    $form->{update_imap_1_watch_folders} = 1;
    $im->watched_folders__( '1', '2' );
    $im->validate_item( 'imap_1_watch_folders', $tmpl, $language, $form );
    test_assert_equal( $im->{folder_change_flag__}, 1 );
    my @folders = $im->watched_folders__();
    test_assert_equal( scalar @folders, 2 );
    test_assert_equal( $folders[0], 'first watched folder' );
    test_assert_equal( $folders[1], 'second watched folder' );

    # imap-watch-more-folders.thtml
    $form = {};
    $form->{imap_2_watch_more_folders} = 1;
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-watch-more-folders.thtml' );
    $im->validate_item( 'imap_2_watch_more_folders', $tmpl, $language, $form );
    @folders = $im->watched_folders__();
    test_assert_equal( scalar @folders, 3 );
    test_assert_equal( pop @folders, 'INBOX' );

    # imap-bucket-folders.thtml
    $form = {};
    $form->{imap_3_bucket_folders} = 1;
    $form->{imap_folder_for_other} = 'personal';
    $form->{imap_folder_for_personal} = 'other';

    $tmpl = HTML::Template->new( filename => '../skins/default/imap-bucket-folders.thtml' );
    $im->validate_item('imap_3_bucket_folders', $tmpl, $language, $form );
    test_assert_equal( $im->{folder_change_flag__}, 1 );
    test_assert_equal( $im->folder_for_bucket__( 'other' ), 'personal' );
    test_assert_equal( $im->folder_for_bucket__( 'personal' ), 'other' );

    # The module should not let you map more than one bucket to a folder:
    $form = {};
    $form->{imap_3_bucket_folders} = 1;
    $form->{imap_folder_for_other} = 'other';
    $form->{imap_folder_for_personal} = 'other';
    $im->validate_item('imap_3_bucket_folders', $tmpl, $language, $form );
    test_assert( $tmpl->param('IMAP_buckets_to_folders_if_error') );
    test_assert_equal( $im->folder_for_bucket__( 'other' ), 'personal' );
    test_assert_equal( $im->folder_for_bucket__( 'personal' ), 'other' );

    # The same goes for pseudo buckets:
    $form = {};
    $form->{imap_3_bucket_folders} = 1;
    $form->{imap_folder_for_unclassified} = 'other';
    $form->{imap_folder_for_personal} = 'other';
    $im->validate_item('imap_3_bucket_folders', $tmpl, $language, $form );
    test_assert( $tmpl->param('IMAP_buckets_to_folders_if_error') );
    test_assert_equal( $im->folder_for_bucket__( 'unclassified' ), 'unclassified' );
    test_assert_equal( $im->folder_for_bucket__( 'personal' ), 'other' );

    # imap-update-mailbox-list.thtml
    $form = {};
    $form->{do_imap_4_update_mailbox_list} = 1;
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-update-mailbox-list.thtml' );
    $im->config_( 'hostname', '127.0.0.1' );
    $im->config_( 'password', 'password' );
    $im->config_( 'login', 'someone' );
    $im->config_( 'port', '1143' );
    $im->config_( 'update_interval', 10 );
    $im->config_( 'use_ssl', 0 );
    $im->validate_item( 'imap_4_update_mailbox_list', $tmpl, $language, $form );
    test_assert_equal( scalar @{$im->{mailboxes__}}, 5 );
    test_assert( ! $tmpl->param( 'IMAP_update_list_failed' ) );

    $im->config_( 'login', 'someone' );
    $im->config_( 'hostname', '' );
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-update-mailbox-list.thtml' );
    $im->validate_item( 'imap_4_update_mailbox_list', $tmpl, $language, $form );
    test_assert( $tmpl->param( 'IMAP_update_list_failed' ) );

    $im->config_( 'hostname', '127.0.0.1' );
    $im->config_( 'port', '12345' );
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-update-mailbox-list.thtml' );
    $im->validate_item( 'imap_4_update_mailbox_list', $tmpl, $language, $form );
    test_assert( $tmpl->param( 'IMAP_update_list_failed' ) );

    $im->config_( 'port', 1143 );
    $im->config_( 'login', 'fail' );
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-update-mailbox-list.thtml' );
    $im->validate_item( 'imap_4_update_mailbox_list', $tmpl, $language, $form );
    test_assert( $tmpl->param( 'IMAP_update_list_failed' ) );


    # imap-options.thtml
    $form = {};
    $tmpl = HTML::Template->new( filename => '../skins/default/imap-options.thtml' );
    $form->{update_imap_5_options} = 1;
    $form->{imap_options_expunge} = 1;
    $form->{imap_options_update_interval} = 1234;
    $im->validate_item( 'imap_5_options', $tmpl, $language, $form );
    test_assert_equal( $im->config_( 'expunge' ), 1 );
    test_assert_equal( $im->config_( 'update_interval' ), 1234 );

    $form->{imap_options_expunge} = undef;
    $im->validate_item( 'imap_5_options', $tmpl, $language, $form );
    test_assert_equal( $im->config_( 'expunge' ), 0 );

    $form->{imap_options_update_interval} = 0;
    $im->validate_item( 'imap_5_options', $tmpl, $language, $form );
    test_assert_equal( $tmpl->param('IMAP_if_interval_error'), 1 );
}


#################################################################################
# configure_imap_module
# Tweak our configuration settings to prepare the test environment
##

sub configure_imap_module {
    my ( $im, $c, $mq, $l, $b, $h ) = @_;
    $im->configuration( $c );
    $im->mq( $mq );
    $im->logger( $l );
    $im->classifier( $b );
    $im->history ( $h );
    $im->initialize();
    # We should not do anything when we're not enabled:
    $im->config_( 'enabled', 0 );
    test_assert_equal( $im->start(), 2 );
    $im->config_( 'enabled', 1 );
    $im->config_( 'expunge', 1 );
    $im->config_( 'hostname', '127.0.0.1' );
    $im->config_( 'password', 'password' );
    $im->config_( 'port', '1143' );
    $im->config_( 'update_interval', 10 );
    $im->config_( 'watched_folders', '' );

    $im->global_config_( 'message_cutoff', 100000 );
    $im->global_config_( 'timeout', 4 );

    $im->{last_update__} = 0;
    $im->watched_folders__( 'INBOX' );
    $im->folder_for_bucket__( 'spam', 'spam' );
    $im->folder_for_bucket__( 'personal', 'personal' );
    $im->folder_for_bucket__( 'other', 'other' );
    $im->folder_for_bucket__( 'unclassified', 'unclassified' );
}


#################################################################################
# start_popfile
# Bring up the POPFile engine and prepare the test environment
##

sub start_popfile {
    my $c = new POPFile::Configuration;
    my $mq = new POPFile::MQ;
    my $l = new POPFile::Logger;
    my $b = new Classifier::Bayes;
    my $w = new Classifier::WordMangle;
    my $h = new POPFile::History;

    foreach ( $c, $l, $w, $mq, $h, $b ) {
        $_->configuration( $c );
        $_->mq( $mq );
        $_->logger( $l ) unless $_ == $l;
    }

    $c->initialize();

    $b->history( $h );
    $h->classifier( $b );
    $h->initialize();

    $b->module_config_( 'html', 'language', 'English' );
    $b->module_config_( 'html', 'port', '8080' );

    $b->{parser__}->mangle( $w );
    $b->initialize();

    test_assert( $b->start() );
    test_assert( $h->start() );

    $l->initialize();
    $l->config_( 'level', 1 );

    $l->service();

    return ( $c, $mq, $l, $b, $w, $h );
}


1;
