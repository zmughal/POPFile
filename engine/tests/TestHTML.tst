# ---------------------------------------------------------------------------------------------
#
# Tests for HTML.pm
#
# Copyright (c) 2003 John Graham-Cumming
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
# ---------------------------------------------------------------------------------------------

# Set up the test corpus and use the Test msg and cls files
# to create a current history set

test_assert( `rm -rf corpus` == 0 );
test_assert( `cp -R corpus.base corpus` == 0 );
test_assert( `rm -rf corpus/CVS` == 0 );
test_assert( `rm -rf messages` == 0 );

mkdir 'messages';
my @messages = glob '*.msg';

my $count = 0;
foreach my $msg (@messages) {
    test_assert( `cp $msg messages/popfile0=$count.msg` == 0 );
    $msg =~ s/\.msg$/\.cls/;
    test_assert( `cp $msg messages/popfile0=$count.cls` == 0 );
    $count += 1;
}

use POSIX ":sys_wait_h";

use HTML::Form;
my @forms;

# Helper function that finds an input with a specific name
# in the @forms collection and returns or sets its value

sub form_input
{
    my ( $name, $value ) = @_;

    foreach my $form (@forms) {
        my $input = $form->find_input( $name );

        if ( defined( $input ) ) {
            $input->value( $value ) if defined( $value );
            return $input->value();
	}
    }

    test_assert( 0, "Unable to find form element '$name'" );

    return undef;
}

sub pipeready
{
    my ( $pipe ) = @_;

    if ( !defined( $pipe ) ) {
        return 0;
    }

    if ( $^O eq 'MSWin32' ) {
        return ( ( -s $pipe ) > 0 );
    } else {
        my $rin = '';
        vec( $rin, fileno( $pipe ), 1 ) = 1;
        my $ready = select( $rin, undef, undef, 0.01 );
        return ( $ready > 0 );
    }
}

use Classifier::Bayes;
use UI::HTML;
use POPFile::Configuration;
use POPFile::MQ;
use POPFile::Logger;
use Proxy::POP3;

my $c = new POPFile::Configuration;
my $mq = new POPFile::MQ;
my $l = new POPFile::Logger;
my $b = new Classifier::Bayes;

$c->configuration( $c );
$c->mq( $mq );
$c->logger( $l );
$c->initialize();

$l->configuration( $c );
$l->mq( $mq );
$l->logger( $l );

$l->initialize();

$mq->configuration( $c );
$mq->mq( $mq );
$mq->logger( $l );

$b->configuration( $c );
$b->mq( $mq );
$b->logger( $l );

$b->initialize();

my $p = new Proxy::POP3;

$p->configuration( $c );
$p->mq( $mq );
$p->logger( $l );
$p->classifier( $b );
$p->version( 'testsuite' );
$p->initialize();

our $h = new UI::HTML;

$h->configuration( $c );
$h->mq( $mq );
$h->logger( $l );
$h->classifier( $b );
$h->initialize();
$h->version( 'testsuite' );
our $version = $h->version();

our $sk = $h->{session_key__};

$mq->service();

test_assert_equal( $h->url_encode_( ']' ), '%5d' );
test_assert_equal( $h->url_encode_( '[' ), '%5b' );
test_assert_equal( $h->url_encode_( '[]' ), '%5b%5d' );
test_assert_equal( $h->url_encode_( '[foo]' ), '%5bfoo%5d' );

our $port = 9000 + int(rand(1000));
pipe my $dreader, my $dwriter;
pipe my $ureader, my $uwriter;
my $pid = fork();

if ( $pid == 0 ) {

    # CHILD THAT WILL RUN THE HTML INTERFACE

    close $dwriter;
    close $ureader;

    $h->config_( 'port', $port );
    $h->start();

    while ( 1 ) {
        last if !$h->service();

        if ( pipeready( $dreader ) ) {
            my $command = <$dreader>;

            if ( $command =~ /__QUIT/ ) {
                print $uwriter "OK\n";
                last;
	    }
	}
    }

    close $dreader;
    close $uwriter;

    exit(0);
} else {

    # PARENT THAT WILL SEND COMMANDS TO THE WEB INTERFACE

    close $dreader;
    close $uwriter;
    $dwriter->autoflush(1);

    use LWP::Simple;
    use URI::URL;
    use String::Interpolate 'interpolate';

    our $url;
    our $content;
    open SCRIPT, "<TestHTML.script";

    while ( my $line = <SCRIPT> ) {
        $line =~ s/^[\t ]+//g;
        $line =~ s/[\r\n\t ]+$//g;

        if ( $line =~ /^#/ ) {
            next;
	}

        $line = interpolate( $line );

        if ( $line =~ /^URL (.+)$/ ) {
            $url = url( $1 );
            next;
	}

        if ( $line =~ /^INPUTIS (.+) (.+)$/ ) {
            test_assert_equal( form_input( $1 ), $2 );
            next;
	}

        if ( $line =~ /^GET$/ ) {
            $content = get($url);
            @forms   = HTML::Form->parse( $content, "http://127.0.0.1:$port" );
            next;
	}

        if ( $line =~ /^MATCH (.+)$/ ) {
            test_assert_regexp( $content, "\Q$1\E" );
            next;
        }

        if ( $line =~ /^MATCH$/ ) {
            my $block;

            while ( $line = <SCRIPT> ) {
                $line =~ s/^[\t ]+//g;
                $line =~ s/[\r\n\t ]+$//g;

                $line = interpolate( $line );

	        if ( $line =~ /^ENDMATCH$/ ) {
                    last;
	        }

                $block .= "\n" unless ( $block eq '' );
                $block .= $line;
	    }

            test_assert_regexp( $content, "\Q$block\E" );
            next;
        }

        if ( $line =~ /^CODE$/ ) {
            my $block;

            while ( $line = <SCRIPT> ) {
                $line =~ s/^[\t ]+//g;
                $line =~ s/[\r\n\t ]+$//g;

	        if ( $line =~ /^ENDCODE$/ ) {
                    last;
	        }

                $block .= "\n" unless ( $block eq '' );
                $block .= $line;
	    }

            eval( $block );
            next;
        }
    }

    close SCRIPT;

    # TODO Validate every page in the interface against the W3C HTML 4.01
    # validation service

    print $dwriter "__QUIT\n";
    $content = <$ureader>;
    test_assert_equal( $content, "OK\n" );
    close $dwriter;
    close $ureader;

    while ( waitpid( $pid, &WNOHANG ) != $pid ) {
    }
}


