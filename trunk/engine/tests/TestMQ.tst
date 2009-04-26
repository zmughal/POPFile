# ----------------------------------------------------------------------------
#
# Tests for MQ.pm
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

my %valid = ( 'POPFile/Logger' => 1,
              'POPFile/MQ'     => 1,
              'POPFile/Configuration' => 1 );

$POPFile->CORE_load( 0, \%valid );
$POPFile->CORE_initialize();
$POPFile->CORE_config( 1 );
$POPFile->CORE_start();

my $mq = $POPFile->get_module( 'POPFile/MQ' );

# Basic configuration
test_assert_equal( $mq->name(), 'mq' );

# This is a helper object with a deliver
# function that can be called by the message queue
# and a read function that we can call to check that
# messages are getting delivered

use Test::MQReceiver;
my $r = new Test::MQReceiver;

# Register three different message types

$mq->register( 'MESG1', $r );
$mq->register( 'MSG1',  $r );
$mq->register( 'MSG2',  $r );
$mq->register( 'MSG3',  $r );

# Now send messages and check for their receipt

# First send a single message and check that it is
# received
$mq->post( 'MESG1', 'Message1', 'Param1' );
$mq->service();
my @messages = $r->read();
test_assert_equal( $#messages, 0 );
test_assert_equal( $messages[0][0], 'MESG1' );
test_assert_equal( $messages[0][1][0], 'Message1' );
test_assert_equal( $messages[0][1][1], 'Param1' );

# Now send three messages and check that they are
# received
$mq->post( 'MSG1', 'message1', 'param1' );
$mq->post( 'MSG2', 'message2', 'param2' );
$mq->post( 'MSG3', 'message3', 'param3' );
$mq->service();
my @messages = $r->read();
test_assert_equal( $#messages, 2 );
test_assert_equal( $messages[0][0], 'MSG1' );
test_assert_equal( $messages[0][1][0], 'message1' );
test_assert_equal( $messages[0][1][1], 'param1' );
test_assert_equal( $messages[1][0], 'MSG2' );
test_assert_equal( $messages[1][1][0], 'message2' );
test_assert_equal( $messages[1][1][1], 'param2' );
test_assert_equal( $messages[2][0], 'MSG3' );
test_assert_equal( $messages[2][1][0], 'message3' );
test_assert_equal( $messages[2][1][1], 'param3' );

# Now send a message that we have not registered
# and check that we do not receive it
$mq->post( 'MSG4', 'message4', 'param4' );
$mq->service();
my @messages = $r->read();
test_assert_equal( $#messages, -1 );

# Now register for it and try to get the message
# this should fail as it should have been cleared
$mq->register( 'MSG3', $r );
$mq->service();
my @messages = $r->read();
test_assert_equal( $#messages, -1 );

# Now try sending the same message multiple times
$mq->post( 'MSG1', 'message1', 'param1' );
$mq->post( 'MSG1', 'message1', 'param1' );
$mq->post( 'MSG1', 'message1', 'param1' );
$mq->service();
my @messages = $r->read();
test_assert_equal( $#messages, 2 );
test_assert_equal( $messages[0][0], 'MSG1' );
test_assert_equal( $messages[0][1][0], 'message1' );
test_assert_equal( $messages[0][1][1], 'param1' );
test_assert_equal( $messages[1][0], 'MSG1' );
test_assert_equal( $messages[1][1][0], 'message1' );
test_assert_equal( $messages[1][1][1], 'param1' );
test_assert_equal( $messages[1][0], 'MSG1' );
test_assert_equal( $messages[1][1][0], 'message1' );
test_assert_equal( $messages[1][1][1], 'param1' );

$POPFile->CORE_stop();

1;
