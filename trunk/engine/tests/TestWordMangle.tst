# ----------------------------------------------------------------------------
#
# Tests for WordMangle.pm
#
# Copyright (c) 2003-2006 John Graham-Cumming
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

my %valid = ( 'Classifier/WordMangle' => 1,
              'POPFile/Logger' => 1,
              'POPFile/MQ'     => 1,
              'POPFile/Configuration' => 1 );

$POPFile->CORE_load( 0, \%valid );
$POPFile->CORE_initialize();
$POPFile->CORE_config( 1 );
unlink 'stopwords';
$POPFile->CORE_start();

my $w = $POPFile->get_module( 'Classifier/WordMangle' );

# Test basic mangling functions

test_assert_equal( $w->mangle( 'BIGWORD' ), 'bigword' );
test_assert_equal( $w->mangle( 'BIG+/?*|()[]{}^$\\.WORD' ), 'big...............word' );
test_assert_equal( $w->mangle( 'awordthatisfartolongtobeacceptableforuseinclassification' ), '' );
test_assert_equal( $w->mangle( 'A1234BEF66' ), '' );
test_assert_equal( $w->mangle( 'BIG:WORD' ), 'bigword' );
test_assert_equal( $w->mangle( 'BIG:WORD', 1 ), 'BIG:WORD' );

# Test stop words
test_assert_equal( $w->mangle( 'BIGWORD' ), 'bigword' );
test_assert_equal( $w->add_stopword( 'bigword', 'English' ), 1 );
test_assert_equal( $w->mangle( 'BIGWORD' ), '' );
test_assert_equal( $w->remove_stopword( 'bigword', 'Nihongo' ), 1 );
test_assert_equal( $w->mangle( 'BIGWORD' ), 'bigword' );
test_assert_equal( $w->add_stopword( '', 'English' ), 0 );
test_assert_equal( $w->remove_stopword( '', 'English' ), 0 );
test_assert_equal( $w->add_stopword( 'A1234bef66', 'English' ), 0 );
test_assert_equal( $w->remove_stopword( 'A1234bef66', 'English' ), 0 );
test_assert_equal( $w->add_stopword( 'b*ox', 'English' ), 0 );

# Test Japanese
test_assert_equal( $w->add_stopword( chr(0x8e) . chr(0xa0), 'Nihongo' ), 0 );
test_assert_equal( $w->remove_stopword( chr(0x8e) . chr(0xa0), 'Nihongo' ), 0 );

# Getter/setter
my %stops = ( 'oneword', 1 );
$w->stopwords( \%stops );
test_assert_equal( $w->mangle( 'oneWORD' ), '' );
my @stopwords = $w->stopwords();
test_assert_equal( $#stopwords, 0 );
test_assert_equal( $stopwords[0], 'oneword' );
$w->load_stopwords();

# Make sure that stopwords got to disk
test_assert_equal( $w->add_stopword( 'bigword', 'English' ), 1 );
open WORDS, "<stopwords";
my $found = 0;
while (<WORDS>) {
    if ( $_ =~ /bigword/ ) {
        $found = 1;
        last;
    }
}
close WORDS;
test_assert( $found );
test_assert_equal( $w->remove_stopword( 'bigword', 'English' ), 1 );

# Make sure that stopping and starting reloads the stopwords
test_assert_equal( $w->add_stopword( 'anotherbigword', 'English' ), 1 );

$w->stop();

$w->start();
my @stopwords = $w->stopwords();
test_assert_equal( $#stopwords, 0 );
test_assert_equal( $stopwords[0], 'anotherbigword' );

$POPFile->CORE_stop();

1;
