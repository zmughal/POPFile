# ----------------------------------------------------------------------------
#
# Tests for NNTP.pm
#
# Copyright (c) 2001-2014 John Graham-Cumming
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
use warnings;
no warnings qw(redefine);

use POPFile::Configuration;
use POPFile::MQ;
use POPFile::Logger;
use POPFile::History;
use Proxy::SMTP;
use Classifier::Bayes;
use Classifier::WordMangle;
use IO::Handle;
use IO::Socket;
use Digest::MD5;


use POSIX ":sys_wait_h";

my $cr = "\015";
my $lf = "\012";

my $eol = "$cr$lf";
my $timeout = 2;

rmtree( 'corpus' );
test_assert( rec_cp( 'corpus.base', 'corpus' ) );
rmtree( 'corpus/.svn' );
rmtree( 'messages' );

my $c  = new POPFile::Configuration;
my $mq = new POPFile::MQ;
my $l  = new POPFile::Logger;
my $b  = new Classifier::Bayes;
my $w  = new Classifier::WordMangle;
my $h  = new POPFile::History;

sub forker
{
    pipe my $reader, my $writer;
    $l->log_( 2, "Created pipe pair $reader and $writer" );
    $b->prefork();
    $mq->prefork();
    $h->prefork();
    my $pid = fork();

    if ( !defined( $pid ) ) {
        close $reader;
        close $writer;
        return (undef, undef);
    }

    if ( $pid == 0 ) {
        $b->forked( $writer );
        $mq->forked( $writer );
        $h->forked( $writer );
        close $reader;

        use IO::Handle;
        $writer->autoflush(1);

        return (0, $writer);
    }

    $l->log_( 2, "Child process has pid $pid" );

    $b->postfork( $pid, $reader );
    $mq->postfork( $pid, $reader );
    $h->postfork( $pid, $reader );
    close $writer;
    return ($pid, $reader);
}

$c->configuration( $c );
$c->mq( $mq );
$c->logger( $l );

$c->initialize();

$l->configuration( $c );
$l->mq( $mq );
$l->logger( $l );

$l->initialize();
$l->config_( 'level', 2 );
$l->version( 'svn-b0_22_2' );

$w->configuration( $c );
$w->mq( $mq );
$w->logger( $l );

$w->start();

$mq->configuration( $c );
$mq->mq( $mq );
$mq->logger( $l );
$mq->pipeready( \&pipeready );

$b->configuration( $c );
$b->mq( $mq );
$b->logger( $l );

$h->configuration( $c );
$h->mq( $mq );
$h->logger( $l );

$b->history( $h );
$h->classifier( $b );

$h->initialize();

$b->initialize();
$b->module_config_( 'html', 'port', 8080 );
$b->module_config_( 'html', 'language', 'English' );
$b->config_( 'hostname', '127.0.0.1' );
$b->{parser__}->mangle( $w );
$b->start();
$h->start();
$l->start();

my $s = new Proxy::SMTP;

$s->configuration( $c );
$s->mq( $mq );
$s->logger( $l );
$s->classifier( $b );

$s->forker( \&forker );
$s->pipeready( \&pipeready );

$s->{version_} = 'test suite';
$s->initialize();

my $port = 9000 + int(rand(1000));
my $port2 = $port + 1;

$s->config_( 'port', $port );
$s->config_( 'force_fork', 0 );
$s->config_( 'chain_server', 'localhost' );
$s->config_( 'chain_port', $port2 );
$s->global_config_( 'timeout', $timeout );

$s->config_( 'enabled', 0 );
test_assert_equal( $s->start(), 2 );
$s->config_( 'enabled', 1 );
test_assert_equal( $s->start(), 1 );
$s->{api_session__} = $b->get_session_key( 'admin', '' );
$s->history( $h );

# some tests require this directory to be present

mkdir( 'messages' );

# This pipe is used to send signals to the child running
# the server to change its state, the following commands can
# be sent

pipe my $dserverreader, my $dserverwriter;
pipe my $userverreader, my $userverwriter;

my ( $pid, $pipe ) = forker();

if ( $pid == 0 ) {

    # CHILD THAT WILL RUN THE SMTP SERVER

    close $dserverwriter;
    close $userverreader;

    $userverwriter->autoflush(1);

    my $server = IO::Socket::INET->new( Proto     => 'tcp',
                                        LocalAddr => 'localhost',
                                        LocalPort => $port2,
                                        Listen    => SOMAXCONN,
                                        Reuse     => 1 );

    my $selector = new IO::Select( $server );

    while ( 1 ) {
        if ( defined( $selector->can_read(0) ) ) {
            if ( my $client = $server->accept() ) {
                last if !server($client);
                close $client;
            }
        }

        if ( pipeready( $dserverreader ) ) {
            my $command = <$dserverreader>;
        }
        select undef, undef, undef, 0.01;
    }

    close $server;
    $b->stop();
    exit 0;
} else {

    # This pipe is used to send signals to the child running
    # the proxy to change its state, the following commands can
    # be sent
    #
    # __QUIT      Causes the child to terminate proxy service and
    #             exit

    pipe my $dreader, my $dwriter;
    pipe my $ureader, my $uwriter;

    my ( $pid2, $pipe ) = forker();

    if ( $pid2 == 0 ) {

        # CHILD THAT WILL RUN THE SMTP PROXY

        close $dwriter;
        close $ureader;

        $uwriter->autoflush(1);

        while ( 1 ) {
            last if !$s->service();

            if ( pipeready( $dreader ) ) {
                my $command = <$dreader>;

                if ( $command =~ /__QUIT/ ) {
                    print $uwriter "OK$eol";
                    last;
                }
            }
            select undef, undef, undef, 0.01;
        }

        close $dreader;
        close $uwriter;
        $b->stop();
        exit 0;
    } else {

        # PARENT THAT WILL SEND COMMAND TO THE PROXY

        close $dreader;
        close $uwriter;
        $dwriter->autoflush(1);

        close $dserverreader;
        close $userverwriter;
        $dserverwriter->autoflush(1);

        sleep 5;

        my $client = connect_proxy();

        test_assert( defined( $client ) );
        test_assert( $client->connected );

        wait_proxy();

        # Make sure that POPFile sends an appropriate banner

        my $result = <$client>;
        test_assert_equal( $result,
            "220 SMTP POPFile (test suite) welcome$eol" );

        wait_proxy();

        # Some commands before HELO

        print $client "NOOP$eol";
        $result = <$client>;
        test_assert_equal( $result, "554 Transaction failed$eol" );

        print $client "BAD COMMAND$eol";
        $result = <$client>;
        test_assert_equal( $result, "500 unknown command or bad syntax$eol" );

        close $client;

        $client = connect_proxy();
        wait_proxy();

        $result = <$client>;
        test_assert_equal( $result,
            "220 SMTP POPFile (test suite) welcome$eol" );

        # HELO and several commands

        print $client "HELO example.com$eol";
        $result = <$client>;
        test_assert_equal( $result, "250 Simple SMTP Server ready$eol" );

        print $client "VRFY <test\@example.com>$eol";
        $result = <$client>;
        test_assert_equal( $result, "502 Command not implemented$eol" );

        print $client "EXPN Test-Mail-List$eol";
        $result = <$client>;
        test_assert_equal( $result, "502 Command not implemented$eol" );

        print $client "NOOP$eol";
        $result = <$client>;
        test_assert_equal( $result, "250 OK$eol" );

        print $client "HELP$eol";
        $result = <$client>;
        test_assert_equal( $result, "211 Some HELP message$eol" );

        print $client "MAIL FROM:<sender\@example.com>$eol";
        $result = <$client>;
        test_assert_equal( $result, "250 Sender OK$eol" );

        print $client "RCPT TO:<receiver\@example.com>$eol";
        $result = <$client>;
        test_assert_equal( $result, "250 Recipient OK$eol" );

        print $client "RCPT TO:<nouser\@example.com>$eol";
        $result = <$client>;
        test_assert_equal( $result, "550 No such user$eol" );

        print $client "RSET$eol";
        $result = <$client>;
        test_assert_equal( $result, "250 OK$eol" );

        print $client "BAD COMMAND$eol";
        $result = <$client>;
        test_assert_equal( $result, "500 unknown command or bad syntax$eol" );

        # Relaying a message

        my @messages = sort glob 'TestMails/TestMailParse*.msg';

        print $client "MAIL FROM:<sender1\@example.com>$eol";
        $result = <$client>;
        test_assert_equal( $result, "250 Sender OK$eol" );

        print $client "RCPT TO:<recipient1\@example.com>$eol";
        $result = <$client>;
        test_assert_equal( $result, "250 Recipient OK$eol" );

        print $client "DATA$eol";
        $result = <$client>;
        test_assert_equal( $result, "354 Start mail input; end with <CRLF>.<CRLF>$eol" );

        test_assert( open FILE, "<$messages[0]" );
        binmode FILE;
        while ( <FILE> ) {
            my $line = $_;
            $line =~ s/[$cr$lf]+/$cr$lf/g;
            print $client $line;
        }
        close FILE;

        print $client ".$eol";
        $result = <$client>;
        test_assert_equal( $result, "250 OK$eol" );

        print $client "QUIT$eol";
        $result = <$client>;
        test_assert_equal( $result, "221 Bye$eol" );

        close $client;
        sleep 1;

        # EHLO command test

        $client = connect_proxy();

        test_assert( defined( $client ) );
        test_assert( $client->connected );

        wait_proxy();

        $result = <$client>;
        test_assert_equal( $result,
            "220 SMTP POPFile (test suite) welcome$eol" );

        wait_proxy();

        print $client "EHLO example.com$eol";
        $result = <$client>;
        test_assert_equal( $result, "250-Simple SMTP Server ready$eol" );
        $result = <$client>;
        test_assert_equal( $result, "250-HELP$eol" );
        $result = <$client>;
        test_assert_equal( $result, "250 8BITMIME$eol" );

        # Tell the test server to die

        my $line;

        print $client "__QUIT__$eol";
        $result = <$client>;
        test_assert_equal( $result, "221 Bye$eol" );

        close $client;
        sleep 1;

        # Tell the proxy to die

        print $dwriter "__QUIT$eol";
        $line = <$ureader>;
        test_assert_equal( $line, "OK$eol" );
        close $dwriter;
        close $ureader;

        while ( waitpid( -1, 0 ) != -1 ) { }

        $mq->reaper();
        $s->stop();
        $h->stop();
        $b->stop();
        $l->stop();
#        $c->stop();
    }
}

sub connect_proxy
{
    my $client = IO::Socket::INET->new(
                    Proto    => "tcp",
                    PeerAddr => 'localhost',
                    PeerPort => $port );

    return $client;
}

sub wait_proxy
{
    my $cd = 10;
    while ( $cd-- ) {
        select( undef, undef, undef, 0.1 );
        $mq->service();
        $h->service();
    }
}

sub pipeready
{
    my ( $pipe ) = @_;

    if ( !defined( $pipe ) ) {
        return 0;
    }

    if ( $^O eq 'MSWin32' ) {
        return ( defined( fileno( $pipe ) ) && ( ( -s $pipe ) > 0 ) );
    } else {
        my $rin = '';
        vec( $rin, fileno( $pipe ), 1 ) = 1;
        my $ready = select( $rin, undef, undef, 0.01 );
        return ( $ready > 0 );
    }
}

sub server
{
    my ( $client ) = @_;
    my @messages = sort glob 'TestMails/TestMailParse*.msg';
    my $msg_num = 0;
    my $sender = '';
    my @recipients = ();

    my $time = time;

    print $client "220 Ready$eol";

    while  ( <$client> ) {
        my $command;

        $command = $_;
        $command =~ s/($cr|$lf)//g;

        if ( $command =~ /^HELO (.*)/i ) {
            print $client "250 Simple SMTP Server ready$eol";
            next;
        }

        if ( $command =~ /^EHLO (.*)/i ) {
            print $client "250-Simple SMTP Server ready$eol";
            print $client "250-CHUNKING$eol";  # Suppressed
            print $client "250-XEXCH50$eol";   # Suppressed
            print $client "250-HELP$eol";
            print $client "250 8BITMIME$eol";
            next;
        }

        if ( $command =~ /^(VRFY|EXPN) (.*)/i ) {
            print $client "502 Command not implemented$eol";
            next;
        }

        if ( $command =~ /^NOOP$/i ) {
            print $client "250 OK$eol";
            next;
        }

        if ( $command =~ /^HELP *(.*)/i ) {
            print $client "211 Some HELP message$eol";
            next;
        }

        if ( $command =~ /^RSET$/i ) {
            $sender = '';
            @recipients = ();
            print $client "250 OK$eol";
            next;
        }

        if ( $command =~ /^MAIL FROM: *(.*)/i ) {
            $sender = $1;
            print $client "250 Sender OK$eol";
            $msg_num = $1 if ( $sender =~ /sender([\d]+)/ );
            next;
        }

        if ( $command =~ /^RCPT TO: *(.*)/i ) {
            my $user = $1;
            if ( $user =~ /nouser/ ) {
                print $client "550 No such user$eol";
            } else {
                push @recipients, $user;
                print $client "250 Recipient OK$eol";
            }
            next;
        }

        if ( $command =~ /^DATA$/i ) {
            print $client "354 Start mail input; end with <CRLF>.<CRLF>$eol";

            my $cam = $messages[$msg_num - 1];
            $cam =~ s/msg$/cam/;

            test_assert( open FILE, "<$cam" );
            binmode FILE;

            while ( <FILE> ) {
                my $line = $_;
                my $result = <$client>;

                $result =~ s/view=1/view=popfile0=0.msg/;
                $result =~ s/[$cr$lf]+//g;
                $line   =~ s/[$cr$lf]+//g;
                test_assert_equal( $result, $line );
            }
            close FILE;

            my $result = <$client>;
            test_assert_equal( $result, ".$eol" );

            print $client "250 OK$eol";
            next;
        }

        if ( $command =~ /^QUIT/i ) {
            print $client "221 Bye$eol";
            last;
        }

        if ( $command =~ /__QUIT__/i ) {
            print $client "221 Bye$eol";
            return 0;
        }

        if ( $command =~ /^[ \t]*$/i ) {
            next;
        }

        print $client "500 unknown command or bad syntax$eol";
    }

    return 1;
}

1;
