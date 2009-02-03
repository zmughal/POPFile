# ---------------------------------------------------------------------------------------------
#
# Tests for insert.pl
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
# ---------------------------------------------------------------------------------------------

# global to store STDOUT when doing backticks

my @stdout;

my $insert = 'perl -I ../ ../insert.pl';

# One or no command line arguments

@stdout = `$insert`;
$code = ($? >> 8);
test_assert( $code != 0 );

my $line = shift @stdout;

test_assert_regexp( $line, 'insert mail messages into' );

@stdout = `$insert personal`;
test_assert( ($? >> 8) != 0 );
test_assert_regexp( shift @stdout, 'insert mail messages into' );

# Save STDERR

open my $old_stderr, ">&STDERR";

# Bad bucket name

open STDERR, ">temp.tmp";
system("$insert none TestMails/TestMailParse021.wrd");
close STDERR;
$code = ($? >> 8);
test_assert( $code != 0 );
open TEMP, "<temp.tmp";
$line = <TEMP>;
close TEMP;
test_assert_regexp( $line, 'Error: Bucket `none\' does not exist, insert aborted' );

# Bad file name

open STDERR, ">temp.tmp";
system("$insert personal doesnotexist");
$code = ($? >> 8);
close STDERR;

test_assert( $code != 0 );
open TEMP, "<temp.tmp";
$line = <TEMP>;
close TEMP;
test_assert_regexp( $line, 'Error: File `doesnotexist\' does not exist, insert aborted' );


# Check that insertion actually works

my %words;

open WORDS, "<TestMails/TestMailParse021.wrd";
while ( <WORDS> ) {
    if ( /(.+) (\d+)/ ) {
        $words{$1} = $2;
    }
}
close WORDS;

open STDERR, ">temp.tmp";
@stdout =`$insert personal TestMails/TestMailParse021.msg`;
$code = ($? >> 8);
close STDERR;

# Restore STDERR

open STDERR, ">&", $old_stderr;

test_assert_equal( $code, 0 );

$line = shift @stdout;

test_assert_regexp( $line, 'Added 1 files to `personal\'' );

use Classifier::Bayes;
use POPFile::Configuration;
use POPFile::MQ;
use POPFile::Logger;

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

$b->module_config_( 'html', 'language', 'English' );

$b->initialize();

test_assert( $b->start() );

my $session = $b->get_session_key( 'admin', '' );

foreach my $word (keys %words) {
    test_assert_equal( $b->get_base_value_( $session, 'personal', $word ), $words{$word}, "personal: $word $words{$word}" );
}

$b->release_session_key( $session );
$b->stop();


1;


