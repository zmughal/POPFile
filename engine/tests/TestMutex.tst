# ----------------------------------------------------------------------------
#
# Tests for Mutex.pm
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
#   Modified by     Sam Schinke (sschinke@users.sourceforge.net)
#
# ----------------------------------------------------------------------------

use POPFile::Mutex;
use POSIX ":sys_wait_h";

my $m1 = new POPFile::Mutex( 'first' );
my $m2 = new POPFile::Mutex( 'first' );
my $m3 = new POPFile::Mutex( 'second' );

test_assert( $m1->acquire() );
$m1->release();
test_assert( $m1->acquire() );
$m1->release();
test_assert( $m1->acquire() );
test_assert( !$m1->acquire() );
test_assert( $m3->acquire() );
test_assert( !$m2->acquire(1) );
$m1->release();
$m2->release();
$m3->release();

my $pid = fork();

if ( $pid == 0 ) {
    select( undef,undef,undef,1);
    test_assert( $m1->acquire() );
    select( undef,undef,undef,5);
    $m1->release();
    exit 0;
} else {
    select( undef,undef,undef,2);
    test_assert( $m2->acquire() );
    select( undef,undef,undef,1);
    $m2->release();
    while ( waitpid( -1, &WNOHANG ) > 0 ) {
        sleep 1;
    }
}

