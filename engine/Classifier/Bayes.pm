# POPFILE LOADABLE MODULE 3
package Classifier::Bayes;

use POPFile::Module;
@ISA = ("POPFile::Module");

#----------------------------------------------------------------------------
#
# Bayes.pm --- Naive Bayes text classifier
#
# Copyright (c) 2001-2006 John Graham-Cumming
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
#   Modified by              Sam Schinke    (sschinke@users.sourceforge.net)
#   Merged with db code from Scott Leighton (helphand@users.sourceforge.net)
#
#----------------------------------------------------------------------------

use strict;
use warnings;
use locale;
use Classifier::MailParse;
use IO::Handle;
use DBI;
use Digest::MD5 qw( md5_hex );
use Digest::SHA qw( sha256_hex );
use MIME::Base64;

use Crypt::Random;

# This is used to get the hostname of the current machine
# in a cross platform way

use Sys::Hostname;

# A handy variable containing the value of an EOL for networks

my $eol = "\015\012";

# Korean characters definition

my $ksc5601_sym = '(?:[\xA1-\xAC][\xA1-\xFE])';
my $ksc5601_han = '(?:[\xB0-\xC8][\xA1-\xFE])';
my $ksc5601_hanja  = '(?:[\xCA-\xFD][\xA1-\xFE])';
my $ksc5601 = "(?:$ksc5601_sym|$ksc5601_han|$ksc5601_hanja)";

my $eksc = "(?:$ksc5601|[\x81-\xC6][\x41-\xFE])"; #extended ksc

#----------------------------------------------------------------------------
# new
#
#   Class new() function
#----------------------------------------------------------------------------
sub new
{
    my $type = shift;
    my $self = POPFile::Module->new();

    # Set this to 1 to get scores for individual words in message detail

    $self->{wordscores__}        = 0;

    # Choice for the format of the "word matrix" display.

    $self->{wmformat__}          = '';

    # Just our hostname

    $self->{hostname__}        = '';

    # To save time we also 'prepare' some commonly used SQL statements
    # and cache them here, see the function db_prepare__ for details

    $self->{db_get_buckets__} = 0;
    $self->{db_get_wordid__} = 0;
    $self->{db_get_word_count__} = 0;
    $self->{db_put_word_count__} = 0;
    $self->{db_get_bucket_unique_counts__} = 0;
    $self->{db_get_unique_word_count__} = 0;
    $self->{db_get_bucket_word_counts__} = 0;
    $self->{db_get_full_total__} = 0;
    $self->{db_get_bucket_parameter__} = 0;
    $self->{db_set_bucket_parameter__} = 0;
    $self->{db_get_bucket_parameter_default__} = 0;
    $self->{db_get_user_parameter__} = 0;
    $self->{db_set_user_parameter__} = 0;
    $self->{db_get_user_parameter_default__} = 0;
    $self->{db_get_buckets_with_magnets__} = 0;
    $self->{db_delete_zero_words__} = 0;
    $self->{db_get_user_list__} = 0;
    $self->{db_get_user_from_account__} = 0;

    # Caches the name of each bucket and relates it to both the bucket
    # ID in the database and whether it is pseudo or not
    #
    # Subkeys used are:
    #
    # id     The bucket ID in the database
    # pseudo 1 if this is a pseudo bucket

    $self->{db_bucketid__}       = {};

    # Caches the IDs that map to parameter types

    $self->{db_parameterid__}    = {};

    # Caches the IDs that map to user parameter types

    $self->{db_user_parameterid__}    = {};

    # Caches looked up parameter values on a per bucket basis

    $self->{db_parameters__}     = {};

    # Caches looked up user parameter values on a per user basis
    # Subkeys are:
    #
    # lastused      Time the cache entry was last used
    # value         The value for the parameter
    # default       Whether the value is the default or not

    $self->{cached_user_parameters__}     = {};

    # Used to parse mail messages

    $self->{parser__}            = new Classifier::MailParse;

    # The possible colors for buckets
    $self->{possible_colors__} = [ 'red',       'green',      'blue',       'brown', # PROFILE BLOCK START
                                   'orange',    'purple',     'magenta',    'gray',
                                   'plum',      'silver',     'pink',       'lightgreen',
                                   'lightblue', 'lightcyan',  'lightcoral', 'lightsalmon',
                                   'lightgrey', 'darkorange', 'darkcyan',   'feldspar',
                                   'black' ];                                        # PROFILE BLOCK STOP

    # Precomputed per bucket probabilities

    $self->{bucket_start__}      = {};

    # A very unlikely word

    $self->{not_likely__}        = {};

    # The expected corpus version
    #
    # DEPRECATED  This is only used when upgrading old flat file corpus files
    #             to the database

    $self->{corpus_version__}    = 1;

    # The unclassified cutoff this value means that the top
    # probabilily must be n times greater than the second probability,
    # default is 100 times more likely

    $self->{unclassified__}      = log(100);

    # Used to tell the caller whether a magnet was used in the last
    # mail classification

    $self->{magnet_used__}       = 0;
    $self->{magnet_detail__}     = 0;

    # This maps session keys (long strings) to user ids.  If there's
    # an entry here then the session key is valid and can be used in
    # the POPFile API.  See the methods get_session_key and
    # release_session_key for details

    $self->{api_sessions__}      = {};

    # Used to indicate whether we are using SQLite and what the full
    # path and name of the database is if we are.

    $self->{db_is_sqlite__}      = 0;
    $self->{db_name__}           = '';

    # Must call bless before attempting to call any methods

    bless $self, $type;

    $self->name( 'bayes' );

    return $self;
}

#----------------------------------------------------------------------------
#
# initialize
#
# Called to set up the Bayes module's parameters
#
#----------------------------------------------------------------------------
sub initialize
{
    my ( $self ) = @_;

    # The corpus is kept in the 'corpus' subfolder of POPFile
    #
    # DEPRECATED This is only used to find an old corpus that might
    # need to be upgraded

    $self->config_( 'corpus', 'corpus' );

    # Get the hostname for use in the X-POPFile-Link header

    $self->{hostname__} = hostname;

    # Allow the user to override the hostname

    $self->config_( 'hostname', $self->{hostname__} );

    # This parameter is used when the UI is operating in Stealth Mode.
    # If left blank (the default setting) the X-POPFile-Link will use 127.0.0.1
    # otherwise it will use this string instead. The system's HOSTS file should
    # map the string to 127.0.0.1

    $self->config_( 'localhostname', '' );

    # Japanese wakachigaki parser ('kakasi' or 'mecab' or 'internal').
    # TODO: Users can choose the parser engine to use?

    $self->config_( 'nihongo_parser', 'kakasi' );

    $self->mq_register_( 'COMIT', $self );
    $self->mq_register_( 'RELSE', $self );
    $self->mq_register_( 'CREAT', $self );
    $self->mq_register_( 'TICKD', $self );

    $self->{parser__}->{mangle__} = $self->mangle_();

    return 1;
}

#----------------------------------------------------------------------------
#
# deliver
#
# Called by the message queue to deliver a message
#
# There is no return value from this method
#
#----------------------------------------------------------------------------
sub deliver
{
    my ( $self, $type, @message ) = @_;

    if ( $type eq 'COMIT' ) {
        $self->classified( $message[0], $message[2] );
    }

    if ( $type eq 'RELSE' ) {
        $self->release_session_key_private__( $message[0] );
    }

    if ( $type eq 'CREAT' ) {
        my ( $session, $user ) = ( $message[0], $message[1] );
        $self->{api_sessions__}{$session} = $user;
        $self->db_update_cache__( $session );
        $self->log_( 1, "CREAT message on $session for $user" );
    }

    if ( $type eq 'TICKD' ) {
        $self->cleanup_orphan_words__();
    }
}

#----------------------------------------------------------------------------
#
# start
#
# Called to start the Bayes module running
#
#----------------------------------------------------------------------------
sub start
{
    my ( $self ) = @_;

    $self->db_prepare__();

    # In Japanese or Korean mode, explicitly set LC_COLLATE to C.
    #
    # This is to avoid Perl crash on Windows because default
    # LC_COLLATE of Japanese Win is Japanese_Japan.932(Shift_JIS),
    # which is different from the charset POPFile uses for Japanese
    # characters(EUC-JP).

    if ( defined( $self->user_module_config_( 1, 'html', 'language' ) ) &&
       ( $self->user_module_config_( 1, 'html', 'language' ) =~ /^Nihongo|Korean$/ )) {
        use POSIX qw( locale_h );
        setlocale( LC_COLLATE, 'C' );
    }

    # Pass in the current interface language for language specific parsing

    $self->{parser__}->{lang__}  = $self->user_module_config_( 1, 'html', 'language' ) || '';
    $self->{unclassified__} = log( $self->user_config_( 1, 'unclassified_weight' ) );

    $self->upgrade_predatabase_data__();

    # Since Text::Kakasi is not thread-safe, we use it under the
    # control of a Mutex to avoid a crash if we are running on
    # Windows and using the fork.

    if ( $self->{parser__}->{lang__} eq 'Nihongo' ) {
        # Setup Nihongo (Japanese) parser.

        my $nihongo_parser = $self->config_( 'nihongo_parser' );

        $nihongo_parser = $self->{parser__}->setup_nihongo_parser( $nihongo_parser );

        $self->log_( 2, "Use Nihongo (Japanese) parser : $nihongo_parser" );
        $self->config_( 'nihongo_parser', $nihongo_parser );

        # Since Text::Kakasi is not thread-safe, we use it under the
        # control of a Mutex to avoid a crash if we are running on
        # Windows and using the fork.

        if ( ( $nihongo_parser eq 'kakasi' ) && ( $^O eq 'MSWin32' ) &&
             ( ( ( $self->user_module_config_( 1, 'pop3', 'enabled' ) ) &&
                 ( $self->user_module_config_( 1, 'pop3', 'force_fork' ) ) ) ||
               ( ( $self->user_module_config_( 1, 'nntp', 'enabled' ) ) &&
                 ( $self->user_module_config_( 1, 'nntp', 'force_fork' ) ) ) ||
               ( ( $self->user_module_config_( 1, 'smtp', 'enabled' ) ) &&
                 ( $self->user_module_config_( 1, 'smtp', 'force_fork' ) ) ) ) ) {

            $self->{parser__}->{need_kakasi_mutex__} = 1;

            # Prepare the Mutex.
            require POPFile::Mutex;
            $self->{parser__}->{kakasi_mutex__} = new POPFile::Mutex( 'mailparse_kakasi' );
            $self->log_( 2, "Create mutex for Kakasi." );
        }
    }

    return 1;
}

#----------------------------------------------------------------------------
#
# stop
#
# Called when POPFile is terminating
#
#----------------------------------------------------------------------------
sub stop
{
    my ( $self ) = @_;

    $self->db_cleanup__();
    delete $self->{parser__};
    $self->SUPER::stop();
}

#----------------------------------------------------------------------------
#
# forked
#
# Called when POPFile has entered a child process
#
#----------------------------------------------------------------------------
sub forked
{
    my ( $self, $writer ) = @_;

    $self->SUPER::forked( $writer );
    $self->db_prepare__();
}

#----------------------------------------------------------------------------
#
# childexit
#
# Called when POPFile a child process is about to exit
#
#----------------------------------------------------------------------------
sub childexit
{
    my ( $self ) = @_;

    $self->db_cleanup__();
    $self->SUPER::childexit();
}

#----------------------------------------------------------------------------
#
# classified
#
# Called to inform the module about a classification event
#
# There is no return value from this method
#
#----------------------------------------------------------------------------
sub classified
{
    my ( $self, $session, $class ) = @_;

    $self->set_bucket_parameter( $session, $class, 'count',             # PROFILE BLOCK START
        $self->get_bucket_parameter( $session, $class, 'count' ) + 1 ); # PROFILE BLOCK STOP
}

#----------------------------------------------------------------------------
#
# reclassified
#
# Called to inform the module about a reclassification from one bucket
# to another
#
# session            Valid API session
# bucket             The old bucket name
# newbucket          The new bucket name
# undo               1 if this is an undo operation
#
# There is no return value from this method
#
#----------------------------------------------------------------------------
sub reclassified
{
    my ( $self, $session, $bucket, $newbucket, $undo ) = @_;

    $self->log_( 0, "Reclassification from $bucket to $newbucket" );

    my $c = $undo?-1:1;

    if ( $bucket ne $newbucket ) {
        my $count = $self->get_bucket_parameter(
                        $session, $newbucket, 'count' );
        my $newcount = $count + $c;
        $newcount = 0 if ( $newcount < 0 );
        $self->set_bucket_parameter(
            $session, $newbucket, 'count', $newcount );

        $count = $self->get_bucket_parameter(
                     $session, $bucket, 'count' );
        $newcount = $count - $c;
        $newcount = 0 if ( $newcount < 0 );
        $self->set_bucket_parameter(
            $session, $bucket, 'count', $newcount );

        my $fncount = $self->get_bucket_parameter(
                          $session, $newbucket, 'fncount' );
        my $newfncount = $fncount + $c;
        $newfncount = 0 if ( $newfncount < 0 );
        $self->set_bucket_parameter(
            $session, $newbucket, 'fncount', $newfncount );

        my $fpcount = $self->get_bucket_parameter(
                          $session, $bucket, 'fpcount' );
        my $newfpcount = $fpcount + $c;
        $newfpcount = 0 if ( $newfpcount < 0 );
        $self->set_bucket_parameter(
            $session, $bucket, 'fpcount', $newfpcount );
    }
}


#----------------------------------------------------------------------------
# cleanup_orphan_words__
# Removes Words from (words) no longer associated with a bucket
# Called when the TICKD message is received each hour.
#----------------------------------------------------------------------------
sub cleanup_orphan_words__
{
    my ( $self ) = @_;
    $self->db_()->do( "delete from words where words.id in" .                            # PROFILE BLOCK START
                        " (select id from words except select wordid from matrix);" );   # PROFILE BLOCK STOP
}

#----------------------------------------------------------------------------
#
# get_color
#
# Retrieves the color for a specific word, color is the most likely bucket
#
# $session  Session key returned by get_session_key
# $word     Word to get the color of
#
#----------------------------------------------------------------------------
sub get_color
{
    my ( $self, $session, $word ) = @_;

    my $max   = -10000;
    my $color = 'black';

    for my $bucket ($self->get_buckets( $session )) {
        my $prob = $self->get_value_( $session, $bucket, $word );

        if ( $prob != 0 )  {
            if ( $prob > $max )  {
                $max   = $prob;
                $color = $self->get_bucket_parameter( $session, $bucket,
                             'color' );
            }
        }
    }

    return $color;
}

#----------------------------------------------------------------------------
#

# get_not_likely_
#
# Returns the probability of a word that doesn't appear
#
#----------------------------------------------------------------------------
sub get_not_likely_
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    return $self->{not_likely__}{$userid};
}

#----------------------------------------------------------------------------
#
# get_value_
#
# Returns the value for a specific word in a bucket.  The word is
# converted to the log value of the probability before return to get
# the raw value just hit the hash directly or call get_base_value_
#
#----------------------------------------------------------------------------
sub get_value_
{
    my ( $self, $session, $bucket, $word ) = @_;

    my $value = $self->db_get_word_count__( $session, $bucket, $word );

    if ( defined( $value ) && ( $value > 0 ) ) {

        # Profiling notes:
        #
        # I tried caching the log of the total value and then doing
        # log( $value ) - $cached and this turned out to be
        # much slower than this single log with a division in it

        return log( $value /
                    $self->get_bucket_word_count( $session, $bucket ) );
    } else {
        return 0;
    }
}

sub get_base_value_
{
    my ( $self, $session, $bucket, $word ) = @_;

    my $value = $self->db_get_word_count__( $session, $bucket, $word );

    if ( defined( $value ) ) {
        return $value;
    } else {
        return 0;
    }
}

#----------------------------------------------------------------------------
#
# set_value_
#
# Sets the value for a word in a bucket and updates the total word
# counts for the bucket and globally
#
#----------------------------------------------------------------------------
sub set_value_
{
    my ( $self, $session, $bucket, $word, $value ) = @_;

    if ( $self->db_put_word_count__( $session, $bucket,
             $word, $value ) == 1 ) {

        # If we set the word count to zero then clean it up by deleting the
        # entry

        my $userid = $self->valid_session_key__( $session );
        my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
        $self->{db_delete_zero_words__}->execute( $bucketid );

        return 1;
    } else {
        return 0;
    }
}

#----------------------------------------------------------------------------
#
# get_sort_value_ behaves the same as get_value_, except that it
# returns not_likely__ rather than 0 if the word is not found.  This
# makes its result more suitable as a sort key for bucket ranking.
#
#----------------------------------------------------------------------------
sub get_sort_value_
{
    my ( $self, $session, $bucket, $word ) = @_;

    my $v = $self->get_value_( $session, $bucket, $word );

    if ( $v == 0 ) {

        my $userid = $self->valid_session_key__( $session );
        return undef if ( !defined( $userid ) );

        return $self->{not_likely__}{$userid};
    } else {
        return $v;
    }
}

#----------------------------------------------------------------------------
#
# update_constants__
#
# Updates not_likely and bucket_start
#
#----------------------------------------------------------------------------
sub update_constants__
{
    my ( $self, $session ) = @_;

    my $wc = $self->get_word_count( $session );

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    if ( $wc > 0 )  {
        $self->{not_likely__}{$userid} = -log( 10 * $wc );

        foreach my $bucket ($self->get_buckets( $session )) {
            my $total = $self->get_bucket_word_count( $session, $bucket );

            if ( $total != 0 ) {
                $self->{bucket_start__}{$userid}{$bucket} = log( $total /
                                                                 $wc );
            } else {
                $self->{bucket_start__}{$userid}{$bucket} = 0;
            }
        }
    } else {
        $self->{not_likely__}{$userid} = 0;
    }
}

#----------------------------------------------------------------------------
#
# db_prepare__
#
# Prepare various SQL statements
#
#----------------------------------------------------------------------------
sub db_prepare__
{
    my ( $self ) = @_;

    # Now prepare common SQL statements for use, as a matter of convention the
    # parameters to each statement always appear in the following order:
    #
    # user
    # bucket
    # word
    # parameter

    $self->{db_get_buckets__} = $self->db_()->prepare(                                 # PROFILE BLOCK START
             'select name, id, pseudo from buckets
                  where buckets.userid = ?;' );                                         # PROFILE BLOCK STOP

    $self->{db_get_wordid__} = $self->db_()->prepare(                                  # PROFILE BLOCK START
             'select id from words
                  where words.word = ? limit 1;' );                                     # PROFILE BLOCK STOP

    $self->{db_get_userid__} = $self->db_()->prepare(                                  # PROFILE BLOCK START
             'select id from users where name = ?
                                     and password = ? limit 1;' );                      # PROFILE BLOCK STOP

    $self->{db_get_word_count__} = $self->db_()->prepare(                              # PROFILE BLOCK START
             'select matrix.times from matrix
                  where matrix.bucketid = ? and
                        matrix.wordid = ? limit 1;' );                                  # PROFILE BLOCK STOP

    $self->{db_put_word_count__} = $self->db_()->prepare(                              # PROFILE BLOCK START
           'replace into matrix ( bucketid, wordid, times ) values ( ?, ?, ? );' );     # PROFILE BLOCK STOP

    $self->{db_get_bucket_unique_counts__} = $self->db_()->prepare(                    # PROFILE BLOCK START
             'select count(matrix.wordid), buckets.name from matrix, buckets
                  where buckets.userid = ?
                    and matrix.bucketid = buckets.id
                  group by buckets.name;' );                                            # PROFILE BLOCK STOP

    $self->{db_get_bucket_word_counts__} = $self->db_()->prepare(                      # PROFILE BLOCK START
             'select sum(matrix.times), buckets.name from matrix, buckets
                  where matrix.bucketid = buckets.id
                    and buckets.userid = ?
                    group by buckets.name;' );                                          # PROFILE BLOCK STOP

    $self->{db_get_unique_word_count__} = $self->db_()->prepare(                       # PROFILE BLOCK START
             'select count(matrix.wordid) from matrix, buckets
                  where matrix.bucketid = buckets.id and
                        buckets.userid = ?;' );                                         # PROFILE BLOCK STOP

    $self->{db_get_full_total__} = $self->db_()->prepare(                              # PROFILE BLOCK START
             'select sum(matrix.times) from matrix, buckets
                  where buckets.userid = ? and
                        matrix.bucketid = buckets.id;' );                               # PROFILE BLOCK STOP

    $self->{db_get_bucket_parameter__} = $self->db_()->prepare(                        # PROFILE BLOCK START
             'select bucket_params.val from bucket_params
                  where bucket_params.bucketid = ? and
                        bucket_params.btid = ?;' );                                     # PROFILE BLOCK STOP

    $self->{db_set_bucket_parameter__} = $self->db_()->prepare(                        # PROFILE BLOCK START
           'replace into bucket_params ( bucketid, btid, val ) values ( ?, ?, ? );' );  # PROFILE BLOCK STOP

    $self->{db_get_bucket_parameter_default__} = $self->db_()->prepare(                # PROFILE BLOCK START
             'select bucket_template.def from bucket_template
                  where bucket_template.id = ?;' );                                     # PROFILE BLOCK STOP

    $self->{db_get_user_parameter__} = $self->db_()->prepare(                        # PROFILE BLOCK START
             'select user_params.val from user_params
                  where user_params.userid = ? and
                        user_params.utid = ?;' );                                     # PROFILE BLOCK STOP

    $self->{db_set_user_parameter__} = $self->db_()->prepare(                        # PROFILE BLOCK START
           'replace into user_params ( userid, utid, val ) values ( ?, ?, ? );' );  # PROFILE BLOCK STOP

    $self->{db_get_user_parameter_default__} = $self->db_()->prepare(                # PROFILE BLOCK START
             'select user_template.def from user_template
                  where user_template.id = ?;' );                                     # PROFILE BLOCK STOP

    $self->{db_get_buckets_with_magnets__} = $self->db_()->prepare(                    # PROFILE BLOCK START
             'select buckets.name from buckets, magnets
                  where buckets.userid = ? and
                        magnets.id != 0 and
                        magnets.bucketid = buckets.id group by buckets.name order by buckets.name;' );
                                                                                        # PROFILE BLOCK STOP
    $self->{db_delete_zero_words__} = $self->db_()->prepare(                           # PROFILE BLOCK START
             'delete from matrix
                  where matrix.times = 0
                    and matrix.bucketid = ?;' );                                        # PROFILE BLOCK STOP

    $self->{db_get_user_list__} = $self->db_()->prepare(
             'select id, name from users order by name;' );

    $self->{db_get_user_from_account__} = $self->db_()->prepare(
             'select userid from accounts where account = ?' );

    # Get the mapping from parameter names to ids into a local hash

    my $h = $self->db_()->prepare( "select name, id from bucket_template;" );
    $h->execute();
    while ( my $row = $h->fetchrow_arrayref ) {
        $self->{db_parameterid__}{$row->[0]} = $row->[1];
    }
    $h->finish;

    # Get the mapping from user parameter names to ids into a local hash

    $h = $self->db_()->prepare( "select name, id from user_template;" );
    $h->execute;
    while ( my $row = $h->fetchrow_arrayref ) {
        $self->{db_user_parameterid__}{$row->[0]} = $row->[1];
    }
    $h->finish;

    return 1;
}

#----------------------------------------------------------------------------
#
# db_cleanup__
#
# Cleanup handles into the database
#
#----------------------------------------------------------------------------
sub db_cleanup__
{
    my ( $self ) = @_;

    $self->{db_get_buckets__}->finish;
    $self->{db_get_wordid__}->finish;
    $self->{db_get_userid__}->finish;
    $self->{db_get_word_count__}->finish;
    $self->{db_put_word_count__}->finish;
    $self->{db_get_bucket_unique_counts__}->finish;
    $self->{db_get_bucket_word_counts__}->finish;
    $self->{db_get_unique_word_count__}->finish;
    $self->{db_get_full_total__}->finish;
    $self->{db_get_bucket_parameter__}->finish;
    $self->{db_set_bucket_parameter__}->finish;
    $self->{db_get_bucket_parameter_default__}->finish;
    $self->{db_get_user_parameter__}->finish;
    $self->{db_set_user_parameter__}->finish;
    $self->{db_get_user_parameter_default__}->finish;
    $self->{db_get_buckets_with_magnets__}->finish;
    $self->{db_delete_zero_words__}->finish;
    $self->{db_get_user_list__}->finish;
    $self->{db_get_user_from_account__}->finish;
}

#----------------------------------------------------------------------------
#
# db_update_cache__
#
# Updates our local cache of user and bucket ids.
#
# $session           Must be a valid session
#
#----------------------------------------------------------------------------
sub db_update_cache__
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    delete $self->{db_bucketid__}{$userid};

    $self->{db_get_buckets__}->execute( $userid );
    while ( my $row = $self->{db_get_buckets__}->fetchrow_arrayref ) {
        $self->{db_bucketid__}{$userid}{$row->[0]}{id} = $row->[1];
        $self->{db_bucketid__}{$userid}{$row->[0]}{pseudo} = $row->[2];
        $self->{db_bucketcount__}{$userid}{$row->[0]} = 0;
    }

    $self->{db_get_bucket_word_counts__}->execute( $userid );

    for my $b (sort keys %{$self->{db_bucketid__}{$userid}}) {
        $self->{db_bucketcount__}{$userid}{$b} = 0;
        $self->{db_bucketunique__}{$userid}{$b} = 0;
    }

    while ( my $row = $self->{db_get_bucket_word_counts__}->fetchrow_arrayref ) {
        $self->{db_bucketcount__}{$userid}{$row->[1]} = $row->[0];
    }

    $self->{db_get_bucket_unique_counts__}->execute( $userid );

    while ( my $row = $self->{db_get_bucket_unique_counts__}->fetchrow_arrayref ) {
        $self->{db_bucketunique__}{$userid}{$row->[1]} = $row->[0];
    }

    $self->update_constants__( $session );
}

#----------------------------------------------------------------------------
#
# db_get_word_count__
#
# Return the 'count' value for a word in a bucket.  If the word is not
# found in that bucket then returns undef.
#
# $session          Valid session ID from get_session_key
# $bucket           bucket word is in
# $word             word to lookup
#
#----------------------------------------------------------------------------
sub db_get_word_count__
{
    my ( $self, $session, $bucket, $word ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $self->{db_get_wordid__}->execute( $word );
    my $result = $self->{db_get_wordid__}->fetchrow_arrayref;
    if ( !defined( $result ) ) {
        return undef;
    }

    my $wordid = $result->[0];

    $self->{db_get_word_count__}->execute( $self->{db_bucketid__}{$userid}{$bucket}{id}, $wordid );
    $result = $self->{db_get_word_count__}->fetchrow_arrayref;
    if ( defined( $result ) ) {
         return $result->[0];
    } else {
         return undef;
    }
}

#----------------------------------------------------------------------------
#
# db_put_word_count__
#
# Update 'count' value for a word in a bucket, if the update fails
# then returns 0 otherwise is returns 1
#
# $session          Valid session ID from get_session_key
# $bucket           bucket word is in
# $word             word to update
# $count            new count value
#
#----------------------------------------------------------------------------
sub db_put_word_count__
{
    my ( $self, $session, $bucket, $word, $count ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # We need to have two things before we can start, the id of the
    # word in the words table (if there's none then we need to add the
    # word), the bucket id in the buckets table (which must exist)

    $word = $self->db_()->quote($word);

    my $result = $self->db_()->selectrow_arrayref(
                     "select words.id from words where words.word = $word limit 1;");

    if ( !defined( $result ) ) {
        $self->db_()->do( "insert into words ( word ) values ( $word );" );
        $result = $self->db_()->selectrow_arrayref(
                     "select words.id from words where words.word = $word limit 1;");
    }

    my $wordid = $result->[0];
    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};

    $self->{db_put_word_count__}->execute( $bucketid, $wordid, $count );

    return 1;
}

#----------------------------------------------------------------------------
#
# upgrade_predatabase_data__
#
# Looks for old POPFile data (in flat files or BerkeleyDB tables) and
# upgrades it to the SQL database.  Data upgraded is removed.
#
#----------------------------------------------------------------------------
sub upgrade_predatabase_data__
{
    my ( $self ) = @_;
    my $c      = 0;

    # There's an assumption here that this is the single user version
    # of POPFile and hence what we do is cheat and get a session key
    # assuming that the user name is admin with password ''

    my $session = $self->get_administrator_session_key();

    if ( !defined( $session ) ) {
        $self->log_( 0, "Tried to get the session key for user admin and failed; cannot upgrade old data" );
        return;
    }

    my @buckets = glob $self->get_user_path_( $self->config_( 'corpus' ) . '/*' );

    foreach my $bucket (@buckets) {

        # A bucket directory must be a directory

        next unless ( -d $bucket );
        next unless ( ( -e "$bucket/table" ) || ( -e "$bucket/table.db" ) );

        return 0 if ( !$self->upgrade_bucket__( $session, $bucket ) );

        my $color = '';

        # See if there's a color file specified
        if ( open COLOR, '<' . "$bucket/color" ) {
            $color = <COLOR>;

            # Someone (who shall remain nameless) went in and manually created
            # empty color files in their corpus directories which would cause
            # $color at this point to be undefined and hence you'd get warnings
            # about undefined variables below.  So this little test is to deal
            # with that user and to make POPFile a little safer which is always
            # a good thing

            if ( !defined( $color ) ) {
                $color = '';
            } else {
                $color =~ s/[\r\n]//g;
            }
            close COLOR;
            unlink "$bucket/color";
        }

        $bucket =~ /([[:alpha:]0-9-_]+)$/;
        $bucket =  $1;

        $self->set_bucket_color( $session, $bucket, ($color eq '')?$self->{possible_colors__}[$c]:$color );

        $c = ($c+1) % ($#{$self->{possible_colors__}}+1);
    }

    $self->release_session_key( $session );

    return 1;
}

#----------------------------------------------------------------------------
#
# upgrade_bucket__
#
# Loads an individual bucket
#
# $session           Valid session key from get_session_key
# $bucket            The bucket name
#
#----------------------------------------------------------------------------
sub upgrade_bucket__
{
    my ( $self, $session, $bucket ) = @_;

    $bucket =~ /([[:alpha:]0-9-_]+)$/;
    $bucket =  $1;

    $self->create_bucket( $session, $bucket );

    if ( open PARAMS, '<' . $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/params" ) ) {
        while ( <PARAMS> )  {
            s/[\r\n]//g;
            if ( /^([[:lower:]]+) ([^\r\n\t ]+)$/ )  {
                $self->set_bucket_parameter( $session, $bucket, $1, $2 );
            }
        }
        close PARAMS;
        unlink $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/params" );
    }

    # Pre v0.21.0 POPFile had GLOBAL parameters for subject modification,
    # XTC and XPL insertion.  To make the upgrade as clean as possible
    # check these parameters so that if they were OFF we set the equivalent
    # per bucket to off

    foreach my $gl ( 'subject', 'xtc', 'xpl' ) {
        $self->log_( 1, "Checking deprecated parameter GLOBAL_$gl for $bucket\n" );
        my $val = $self->configuration_()->deprecated_parameter( "GLOBAL_$gl" );
        if ( defined( $val ) && ( $val == 0 ) ) {
            $self->log_( 1, "GLOBAL_$gl is 0 for $bucket, overriding $gl\n" );
            $self->set_bucket_parameter( $session, $bucket, $gl, 0 );
        }
    }

    # See if there are magnets defined
    if ( open MAGNETS, '<' . $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/magnets" ) ) {
        while ( <MAGNETS> )  {
            s/[\r\n]//g;

            # Because of a bug in v0.17.9 and earlier of POPFile the text of
            # some magnets was getting mangled by certain characters having
            # a \ prepended.  Code here removes the \ in these cases to make
            # an upgrade smooth.

            if ( /^([^ ]+) (.+)$/ )  {
                my $type  = $1;
                my $value = $2;

                # Some people were accidently creating magnets with
                # trailing whitespace which really confused them later
                # when their magnet did not match (see comment in
                # UI::HTML::magnet for more detail)

                $value =~ s/^[ \t]+//g;
                $value =~ s/[ \t]+$//g;

                $value =~ s/\\(\?|\*|\||\(|\)|\[|\]|\{|\}|\^|\$|\.)/$1/g;
                $self->create_magnet( $session, $bucket, $type, $value );
            } else {

                # This branch is used to catch the original magnets in an
                # old version of POPFile that were just there for from
                # addresses only

                if ( /^(.+)$/ ) {
                    my $value = $1;
                    $value =~ s/\\(\?|\*|\||\(|\)|\[|\]|\{|\}|\^|\$|\.)/$1/g;
                    $self->create_magnet( $session, $bucket, 'from', $value );
                }
            }
        }
        close MAGNETS;
        unlink $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/magnets" );
    }

    # If there is no existing table but there is a table file (the old style
    # flat file used by POPFile for corpus storage) then create the new
    # database from it thus performing an automatic upgrade.

    if ( -e $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/table" ) ) {
        $self->log_( 0, "Performing automatic upgrade of $bucket corpus from flat file to DBI" );

        $self->db_()->begin_work;

        if ( open WORDS, '<' . $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/table" ) )  {

            my $wc = 1;

            my $first = <WORDS>;
            if ( defined( $first ) && ( $first =~ s/^__CORPUS__ __VERSION__ (\d+)// ) ) {
                if ( $1 != $self->{corpus_version__} )  {
                    print STDERR "Incompatible corpus version in $bucket\n";
                    close WORDS;
                    $self->db_()->rollback;
                    return 0;
                } else {
                    $self->log_( 0, "Upgrading bucket $bucket..." );

                    while ( <WORDS> ) {
                        if ( $wc % 100 == 0 ) {
                            $self->log_( 0, "$wc" );
                        }
                        $wc += 1;
                        s/[\r\n]//g;

                        if ( /^([^\s]+) (\d+)$/ ) {
                            if ( $2 != 0 ) {
                                $self->db_put_word_count__( $session, $bucket, $1, $2 );
                            }
                        } else {
                            $self->log_( 0, "Found entry in corpus for $bucket that looks wrong: \"$_\" (ignoring)" );
                        }
                    }
                }

                if ( $wc > 1 ) {
                    $wc -= 1;
                    $self->log_( 0, "(completed $wc words)" );
                }
                close WORDS;
            } else {
                close WORDS;
                $self->db_()->rollback;
                unlink $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/table" );
                return 0;
            }

            $self->db_()->commit;
            unlink $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/table" );
        }
    }

    # Now check to see if there's a BerkeleyDB-style table

    my $bdb_file = $self->get_user_path_( $self->config_( 'corpus' ) . "/$bucket/table.db" );

    if ( -e $bdb_file ) {
        $self->log_( 0, "Performing automatic upgrade of $bucket corpus from BerkeleyDB to DBI" );

        require BerkeleyDB;

        my %h;
        tie %h, "BerkeleyDB::Hash", -Filename => $bdb_file;

        $self->log_( 0, "Upgrading bucket $bucket..." );
        $self->db_()->begin_work;

        my $wc = 1;

        for my $word (keys %h) {
            if ( $wc % 100 == 0 ) {
                $self->log_( 0, "$wc" );
            }

            next if ( $word =~ /__POPFILE__(LOG__TOTAL|TOTAL|UNIQUE)__/ );

            $wc += 1;
            if ( $h{$word} != 0 ) {
                $self->db_put_word_count__( $session, $bucket, $word, $h{$word} );
            }
        }

        $wc -= 1;
        $self->log_( 0, "(completed $wc words)" );
        $self->db_()->commit;
        untie %h;
        unlink $bdb_file;
    }

    return 1;
}

#----------------------------------------------------------------------------
#
# magnet_match_helper__
#
# Helper the determines if a specific string matches a certain magnet
# type in a bucket, used by magnet_match_
#
# $session         Valid session from get_session_key
# $match           The string to match
# $bucket          The bucket to check
# $type            The magnet type to check
#
#----------------------------------------------------------------------------
sub magnet_match_helper__
{
    my ( $self, $session, $match, $bucket, $type ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $match = lc($match);

    # In Japanese and Korean mode, disable locale.  Sorting Japanese
    # and Korean with "use locale" is memory and time consuming, and
    # may cause perl crash.

    my @magnets;

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
    my $h = $self->db_()->prepare(                                           # PROFILE BLOCK START
        "select magnets.val, magnets.id from magnets, users, buckets, magnet_types
             where buckets.id = $bucketid and
                   magnets.id != 0 and
                   users.id = buckets.userid and
                   magnets.bucketid = buckets.id and
                   magnet_types.mtype = '$type' and
                   magnets.mtid = magnet_types.id order by magnets.val;" );   # PROFILE BLOCK STOP

    $h->execute;
    while ( my $row = $h->fetchrow_arrayref ) {
        push @magnets, [$row->[0], $row->[1]];
    }
    $h->finish;

    foreach my $m (@magnets) {
        my ( $magnet, $id ) = @{$m};
        $magnet = lc($magnet);

        for my $i (0..(length($match)-length($magnet))) {
            if ( substr( $match, $i, length($magnet)) eq $magnet ) {
                $self->{magnet_used__}   = 1;
                $self->{magnet_detail__} = $id;

                return 1;
            }
        }
    }

    return 0;
}

#----------------------------------------------------------------------------
#
# magnet_match__
#
# Helper the determines if a specific string matches a certain magnet
# type in a bucket
#
# $session         Valid session from get_session_key
# $match           The string to match
# $bucket          The bucket to check
# $type            The magnet type to check
#
#----------------------------------------------------------------------------
sub magnet_match__
{
    my ( $self, $session, $match, $bucket, $type ) = @_;

    return $self->magnet_match_helper__( $session, $match, $bucket, $type );
}

#----------------------------------------------------------------------------
#
# write_line__
#
# Writes a line to a file and parses it unless the classification is
# already known
#
# $file         File handle for file to write line to
# $line         The line to write
# $class        (optional) The current classification
#
#----------------------------------------------------------------------------
sub write_line__
{
    my ( $self, $file, $line, $class ) = @_;

    print $file $line if defined( $file );

    if ( $class eq '' ) {
        $self->{parser__}->parse_line( $line );
    }
}

#----------------------------------------------------------------------------
#
# add_words_to_bucket__
#
# Takes words previously parsed by the mail parser and adds/subtracts
# them to/from a bucket, this is a helper used by
# add_messages_to_bucket, remove_message_from_bucket
#
# $session        Valid session from get_session_key
# $bucket         Bucket to add to
# $subtract       Set to -1 means subtract the words, set to 1 means add
#
#----------------------------------------------------------------------------
sub add_words_to_bucket__
{
    my ( $self, $session, $bucket, $subtract ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Map the list of words to a list of counts currently in the database
    # then update those counts and write them back to the database.

    my $words;
    $words = join( ',', map( $self->db_()->quote( $_ ), (sort keys %{$self->{parser__}{words__}}) ) );
    $self->{get_wordids__} = $self->db_()->prepare(        # PROFILE BLOCK START
             "select id, word
                  from words
                  where word in ( $words );" );             # PROFILE BLOCK STOP
    $self->{get_wordids__}->execute;

    my @id_list;
    my %wordmap;

    while ( my $row = $self->{get_wordids__}->fetchrow_arrayref ) {
        push @id_list, ($row->[0]);
        $wordmap{$row->[1]} = $row->[0];
    }

    $self->{get_wordids__}->finish;

    my $ids = join( ',', @id_list );

    $self->{db_getwords__} = $self->db_()->prepare(                                         # PROFILE BLOCK START
             "select matrix.times, matrix.wordid
                  from matrix
                  where matrix.wordid in ( $ids )
                    and matrix.bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};" );  # PROFILE BLOCK STOP

    $self->{db_getwords__}->execute;

    my %counts;

    while ( my $row = $self->{db_getwords__}->fetchrow_arrayref ) {
        $counts{$row->[1]} = $row->[0];
    }

    $self->{db_getwords__}->finish;

    $self->db_()->begin_work;
    foreach my $word (keys %{$self->{parser__}->{words__}}) {

        # If there's already a count then it means that the word is
        # already in the database and we have its id in
        # $wordmap{$word} so for speed we execute the
        # db_put_word_count__ query here rather than going through
        # set_value_ which would need to look up the wordid again

        if ( defined( $wordmap{$word} ) && defined( $counts{$wordmap{$word}} ) ) {
            $self->{db_put_word_count__}->execute( $self->{db_bucketid__}{$userid}{$bucket}{id},               # PROFILE BLOCK START
                $wordmap{$word}, $counts{$wordmap{$word}} + $subtract * $self->{parser__}->{words__}{$word} ); # PROFILE BLOCK STOP
        } else {

            # If the word is not in the database and we are trying to
            # subtract then we do nothing because negative values are
            # meaningless

            if ( $subtract == 1 ) {
                $self->db_put_word_count__( $session, $bucket, $word, $self->{parser__}->{words__}{$word} );
            }
        }
    }

    # If we were doing a subtract operation it's possible that some of
    # the words in the bucket now have a zero count and should be
    # removed

    if ( $subtract == -1 ) {
        $self->{db_delete_zero_words__}->execute( $self->{db_bucketid__}{$userid}{$bucket}{id} );
    }

    $self->db_()->commit;
}

#----------------------------------------------------------------------------
#
# echo_to_dot_
#
# $mail The stream (created with IO::) to send the message to (the
# remote mail server)
# $client (optional) The local mail client (created with IO::) that
# needs the response
# $file (optional) A file to print the response to, caller specifies
# open style
# $before (optional) String to send to client before the dot is sent
#
# echo all information from the $mail server until a single line with
# a . is seen
#
# NOTE Also echoes the line with . to $client but not to $file
#
# Returns 1 if there was a . or 0 if reached EOF before we hit the .
#
#----------------------------------------------------------------------------
sub echo_to_dot_
{
    my ( $self, $mail, $client, $file, $before ) = @_;

    my $hit_dot = 0;

    my $isopen = open FILE, "$file" if ( defined( $file ) );
    binmode FILE if ($isopen);

    while ( my $line = $self->slurp_( $mail ) ) {

        # Check for an abort

        last if ( $self->{alive_} == 0 );

        # The termination has to be a single line with exactly a dot
        # on it and nothing else other than line termination
        # characters.  This is vital so that we do not mistake a line
        # beginning with . as the end of the block

        if ( $line =~ /^\.(\r\n|\r|\n)$/ ) {
            $hit_dot = 1;

            if ( defined( $before ) && ( $before ne '' ) ) {
                print $client $before if ( defined( $client ) );
                print FILE    $before if ( defined( $isopen ) );
            }

            # Note that there is no print FILE here.  This is correct
            # because we do no want the network terminator . to appear
            # in the file version of any message

            print $client $line if ( defined( $client ) );
            last;
        }

        print $client $line if ( defined( $client ) );
        print FILE    $line if ( defined( $isopen ) );

    }

    close FILE if ( $isopen );

    return $hit_dot;
}

#----------------------------------------------------------------------------
#
# substr_euc__
#
# "substr" function which supports EUC Japanese charset
#
# $pos      Start position
# $len      Word length
#
#----------------------------------------------------------------------------
sub substr_euc__
{
    my ( $str, $pos, $len ) = @_;
    my $result_str;
    my $char;
    my $count = 0;
    if ( !$pos ) {
        $pos = 0;
    }
    if ( !$len ) {
        $len = length( $str );
    }

    for ( $pos = 0; $count < $len; $pos++ ) {
        $char = substr( $str, $pos, 1 );
        if ( $char =~ /[\x80-\xff]/ ) {
            $char = substr( $str, $pos++, 2 );
        }
        $result_str .= $char;
        $count++;
    }

    return $result_str;
}

#----------------------------------------------------------------------------
#
# generate_unique_session_key__
#
# Returns a unique string based session key that can be used as a key
# in the api_sessions__
#
#----------------------------------------------------------------------------
sub generate_unique_session_key__
{
    my ( $self ) = @_;

    # Generate a long random number, hash it and the time together to
    # get a random session key in hex

    my $random = Crypt::Random::makerandom_octet( Length => 128,
                                                  Strength => 0 );
    my $now = time;
    return sha256_hex( "$$" . "$random$now" );
}

#----------------------------------------------------------------------------
#
# release_session_key_private__
#
# $session        A session key previously returned by get_session_key
#
# Releases and invalidates the session key. Worker function that does
# the work of release_session_key.
#
#                   **** DO NOT CALL DIRECTLY ****
#
# unless you want your session key released immediately, possibly
# preventing asynchronous tasks from completing
#
#----------------------------------------------------------------------------
sub release_session_key_private__
{
    my ( $self, $session ) = @_;

    if ( defined( $self->{api_sessions__}{$session} ) ) {
        $self->log_( 1, "release_session_key releasing key $session for user $self->{api_sessions__}{$session}" );
        delete $self->{api_sessions__}{$session};
    }
}

#----------------------------------------------------------------------------
#
# valid_session_key__
#
# $session                Session key returned by call to get_session_key
#
# Returns undef is the session key is not valid, or returns the user
# ID associated with the session key which can be used in database
# accesses
#
#----------------------------------------------------------------------------
sub valid_session_key__
{
    my ( $self, $session ) = @_;

    # If the session key is invalid then wait 1 second.  This is done
    # to prevent people from calling a POPFile API such as
    # get_bucket_count with random session keys fishing for a valid
    # key.  The XML-RPC API is single threaded and hence this will
    # delay all use of that API by one second.  Of course in normal
    # use when the user knows the username/password or session key
    # then there is no delay

    if ( !defined( $self->{api_sessions__}{$session} ) ) {
        my ( $package, $filename, $line, $subroutine ) = caller;
        $self->log_( 0, "Invalid session key $session provided in $package @ $line" );
        select( undef, undef, undef, 1 );
    }

    return $self->{api_sessions__}{$session};
}

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# _____   _____   _____  _______ _____        _______   _______  _____  _____
#|_____] |     | |_____] |______   |   |      |______   |_____| |_____]   |
#|       |_____| |       |       __|__ |_____ |______   |     | |       __|__
#
# The method below are public and may be accessed by other modules.
# All of them may be accessed remotely through the XMLRPC.pm module
# using the XML-RPC protocol
#
# Note that every API function expects to be passed a $session which
# is obtained by first calling get_session_key with a valid username
# and password.  Once done call the method release_session_key.
#
# See POPFile::API for more details
#
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
#
# get_session_key
#
# $user           The name of an existing user
# $pwd            The user's password
#
# Returns a string based session key if the username and password
# match, or undef if not
#
#----------------------------------------------------------------------------
sub get_session_key
{
    my ( $self, $user, $pwd ) = @_;

    # The password is stored in the database as an MD5 hash of the
    # username and password concatenated and separated by the string
    # __popfile__, so compute the hash here

    my $hash = md5_hex( $user . '__popfile__' . $pwd );

    $self->{db_get_userid__}->execute( $user, $hash );
    my $result = $self->{db_get_userid__}->fetchrow_arrayref;
    if ( !defined( $result ) ) {

        # The delay of one second here is to prevent people from trying out
        # username/password combinations at high speed to determine the
        # credentials of a valid user

        $self->log_( 0, "Attempt to login with incorrect credentials for user $user" );
        select( undef, undef, undef, 1 );
        return undef;
    }

    my $session = $self->generate_unique_session_key__();

    $self->{api_sessions__}{$session} = $result->[0];

    $self->db_update_cache__( $session );

    $self->log_( 1, "get_session_key returning key $session for user $self->{api_sessions__}{$session}" );

    return $session;
}

#----------------------------------------------------------------------------
#
# get_user_id_from_session
#
# $session        A session key previously returned by get_session_key
#
# Returns the user ID associated with a session
#
#----------------------------------------------------------------------------
sub get_user_id_from_session
{
    my ( $self, $session ) = @_;

    return $self->valid_session_key__( $session );
}

#----------------------------------------------------------------------------
#
# release_session_key
#
# $session        A session key previously returned by get_session_key
#
# Releases and invalidates the session key
#
#----------------------------------------------------------------------------
sub release_session_key
{
    my ( $self, $session ) = @_;

    $self->mq_post_( "RELSE", $session );

    return undef;
}

#----------------------------------------------------------------------------
#
# get_administrator_session_key
#
# Returns a string based session key for the administrator. WARNING
# this is not for external use.  This function bypasses all
# authentication checks and gives admin access.  Should only be called
# in the top-level POPFile process.
#
#----------------------------------------------------------------------------
sub get_administrator_session_key
{
    my ( $self ) = @_;

    my $session = $self->generate_unique_session_key__();
    $self->{api_sessions__}{$session} = 1;
    $self->db_update_cache__( $session );
    $self->log_( 1, "get_administrator_session_key returning key $session" );
    return $session;
}

#----------------------------------------------------------------------------
#
# get_session_key_from_token
#
# Gets a session key from a account token
#
# $session          Valid administrator session
# $module           Name of the module that is passing the token
# $token            The token (usually an account name)
#
# Returns undef on failure or a session key
#
#----------------------------------------------------------------------------
sub get_session_key_from_token
{
    my ( $self, $session, $module, $token ) = @_;

    # Verify that the user has an administrator session set up

    if ( $self->get_user_parameter( $session, 'GLOBAL_can_admin' ) != 1 ) {
        return undef;
    }

    # If we are in single user mode then simply return the
    # administrator session for compatibility with old versions of
    # POPFile.

    if ( $self->global_config_( 'single_user' ) == 1 ) {
        return $session;
    }

    # If the this is not the pop3 module then return the administrator
    # session since there is currently no token matching for non-POP3
    # accounts.

    if ( $module ne 'pop3' ) {
        return $session;
    }

    # Check the token against the associations in the database and
    # figure out which user is being talked about

    my $result = $self->{db_get_user_from_account__}->execute(
                                                          "$module:$token" );
    if ( !defined( $result ) ) {
        $self->log_( 1, "Unknown account $module:$token" );
        return undef;
    }

    my $rows = $self->{db_get_user_from_account__}->fetchrow_arrayref;
    my $user = defined( $rows )?$rows->[0]:undef;

    if ( !defined( $user ) ) {
        $self->log_( 1, "Unknown account $module:$token" );
        return undef;
    }

    my $user_session = $self->generate_unique_session_key__();
    $self->{api_sessions__}{$user_session} = $user;
    $self->db_update_cache__( $user_session );
    $self->log_( 1, "get_session_key_from_token returning key $user_session for user $self->{api_sessions__}{$user_session}" );

    # Send the session to the parent so that it is recorded and can
    # be correctly shutdown

    $self->mq_post_( 'CREAT', $user_session, $user );

    return $user_session;
}

#----------------------------------------------------------------------------
#
# get_top_bucket__
#
# Helper function used by classify to get the bucket with the highest
# score from data stored in a matrix of information (see definition of
# %matrix in classify for details) and a list of potential buckets
#
# $userid         User ID for database access
# $id             ID of a word in $matrix
# $matrix         Reference to the %matrix hash in classify
# $buckets        Reference to a list of buckets
#
# Returns the bucket in $buckets with the highest score
#
#----------------------------------------------------------------------------
sub get_top_bucket__
{
    my ( $self, $userid, $id, $matrix, $buckets ) = @_;

    my $best_probability = 0;
    my $top_bucket       = 'unclassified';

    for my $bucket (@$buckets) {
        my $probability = 0;
        if ( defined($$matrix{$id}{$bucket}) && ( $$matrix{$id}{$bucket} > 0 ) ) {
            $probability = $$matrix{$id}{$bucket} / $self->{db_bucketcount__}{$userid}{$bucket};
        }

        if ( $probability > $best_probability ) {
            $best_probability = $probability;
            $top_bucket       = $bucket;
        }
    }

    return $top_bucket;
}

#----------------------------------------------------------------------------
#
# classify
#
# $session   A valid session key returned by a call to get_session_key
# $file The name of the file containing the text to classify (or undef
# to use the data already in the parser)
# $templ     Reference to the UI template used for word score display
# $matrix (optional) Reference to a hash that will be filled with the
# word matrix used in classification
# $idmap (optional) Reference to a hash that will map word ids in the
# $matrix to actual words
#
# Splits the mail message into valid words, then runs the Bayes
# algorithm to figure out which bucket it belongs in.  Returns the
# bucket name
#
#----------------------------------------------------------------------------
sub classify
{
    my ( $self, $session, $file, $templ, $matrix, $idmap ) = @_;
    $self->log_( 1, "Starting classify" );
    my $msg_total = 0;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $self->{unclassified__} = log( $self->user_config_( 1, 'unclassified_weight' ) );

    $self->{magnet_used__}   = 0;
    $self->{magnet_detail__} = 0;

    if ( defined( $file ) ) {
        $self->{parser__}->parse_file( $file,                                           # PROFILE BLOCK START
                                       $self->global_config_( 'message_cutoff'   ) );   # PROFILE BLOCK STOP
    }

    # Check to see if this email should be classified based on a magnet
    # Get the list of buckets

    my @buckets = $self->get_buckets( $session );

    for my $bucket ($self->get_buckets_with_magnets( $session ))  {
        for my $type ($self->get_magnet_types_in_bucket( $session, $bucket )) {
            if ( $self->magnet_match__( $session, $self->{parser__}->get_header($type), $bucket, $type ) ) {
                $self->log_( 1, "Matched message to magnet. Bucket is $bucket." );
                return $bucket;
            }
        }
    }

    # If the user has not defined any buckets then we escape here
    # return unclassified

    return "unclassified" if ( $#buckets == -1 );

    # The score hash will contain the likelihood that the given
    # message is in each bucket, the buckets are the keys for score

    # Set up the initial score as P(bucket)

    my %score;
    my %matchcount;

    # Build up a list of the buckets that are OK to use for
    # classification (i.e.  that have at least one word in them).

    my @ok_buckets;

    for my $bucket (@buckets) {
        if ( $self->{bucket_start__}{$userid}{$bucket} != 0 ) {
            $score{$bucket} = $self->{bucket_start__}{$userid}{$bucket};
            $matchcount{$bucket} = 0;
            push @ok_buckets, ( $bucket );
        }
    }

    @buckets = @ok_buckets;

    # For each word go through the buckets and calculate
    # P(word|bucket) and then calculate P(word|bucket) ^ word count
    # and multiply to the score

    my $word_count = 0;

    # The correction value is used to generate score displays variable
    # which are consistent with the word scores shown by the GUI's
    # word lookup feature.  It is computed to make the contribution of
    # a word which is unrepresented in a bucket zero.  This correction
    # affects only the values displayed in the display; it has no
    # effect on the classification process.

    my $correction = 0;

    # Classification against the database works in a sequence of steps
    # to get the fastest time possible.  The steps are as follows:
    #
    # 1. Convert the list of words returned by the parser into a list
    #    of unique word ids that can be used in the database.  This
    #    requires a select against the database to get the word ids
    #    (and associated words) which is then converted into two
    #    things: @id_list which is just the sorted list of word ids
    #    and %idmap which maps a word to its id.
    #
    # 2. Then run a second select that get the triplet (count, id,
    #    bucket) for each word id and each bucket.  The triplet
    #    contains the word count from the database for each bucket and
    #    each id, where there is an entry. That data gets loaded into
    #    the sparse matrix %matrix.
    #
    # 3. Do the normal classification loop as before running against
    # the @id_list for the words and for each bucket.  If there's an
    # entry in %matrix for the id/bucket combination then calculate
    # the probability, otherwise use the not_likely probability.
    #
    # NOTE.  Since there is a single not_likely probability we do not
    # worry about the fact that the select in 1 might return a shorter
    # list of words than was found in the message (because some words
    # are not in the database) since the missing words will be the
    # same for all buckets and hence constitute a fixed scaling factor
    # on all the buckets which is irrelevant in deciding which the
    # winning bucket is.

    my $words;
    $words = join( ',', map( $self->db_()->quote( $_ ), (sort keys %{$self->{parser__}{words__}}) ) );
    $self->{get_wordids__} = $self->db_()->prepare(  # PROFILE BLOCK START
             "select id, word
                  from words
                  where word in ( $words )
                  order by id;" );                    # PROFILE BLOCK STOP
    $self->{get_wordids__}->execute;

    my @id_list;
    my %temp_idmap;

    if ( !defined( $idmap ) ) {
        $idmap = \%temp_idmap;
    }

    while ( my $row = $self->{get_wordids__}->fetchrow_arrayref ) {
        push @id_list, ($row->[0]);
        $$idmap{$row->[0]} = $row->[1];
    }

    $self->{get_wordids__}->finish;

    my $ids = join( ',', @id_list );

    $self->{db_classify__} = $self->db_()->prepare(            # PROFILE BLOCK START
             "select matrix.times, matrix.wordid, buckets.name
                  from matrix, buckets
                  where matrix.wordid in ( $ids )
                    and matrix.bucketid = buckets.id
                    and buckets.userid = $userid;" );           # PROFILE BLOCK STOP

    $self->{db_classify__}->execute;

    # %matrix maps wordids and bucket names to counts
    # $matrix{$wordid}{$bucket} == $count

    my %temp_matrix;

    if ( !defined( $matrix ) ) {
        $matrix = \%temp_matrix;
    }

    while ( my $row = $self->{db_classify__}->fetchrow_arrayref ) {
        $$matrix{$row->[1]}{$row->[2]} = $row->[0];
    }

    $self->{db_classify__}->finish;

    foreach my $id (@id_list) {
        $word_count += 2;
        my $wmax = -10000;

        foreach my $bucket (@buckets) {
            my $probability = 0;

            if ( defined($$matrix{$id}{$bucket}) && ( $$matrix{$id}{$bucket} > 0 ) ) {
                $probability = log( $$matrix{$id}{$bucket} / $self->{db_bucketcount__}{$userid}{$bucket} );
            }

            $matchcount{$bucket} += $self->{parser__}{words__}{$$idmap{$id}} if ($probability != 0);
            $probability = $self->{not_likely__}{$userid} if ( $probability == 0 );
            $wmax = $probability if ( $wmax < $probability );
            $score{$bucket} += ( $probability * $self->{parser__}{words__}{$$idmap{$id}} );
        }

        if ($wmax > $self->{not_likely__}{$userid}) {
            $correction += $self->{not_likely__}{$userid} * $self->{parser__}{words__}{$$idmap{$id}};
        } else {
            $correction += $wmax * $self->{parser__}{words__}{$$idmap{$id}};
        }
    }

    # Now sort the scores to find the highest and return that bucket
    # as the classification

    my @ranking = sort {$score{$b} <=> $score{$a}} keys %score;

    my %raw_score;
    my $base_score = $score{$ranking[0]};
    my $total = 0;

    # If the first and second bucket are too close in their
    # probabilities, call the message unclassified.  Also if there are
    # fewer than 2 buckets.

    my $class = 'unclassified';

    if ( @buckets > 1 && $score{$ranking[0]} > ( $score{$ranking[1]} + $self->{unclassified__} ) ) {
        $class = $ranking[0];
    }

    # Compute the total of all the scores to generate the normalized
    # scores and probability estimate.  $total is always 1 after the
    # first loop iteration, so any additional term less than 2 ** -54
    # is insignificant, and need not be computed.

    my $ln2p_54 = -54 * log(2);

    foreach my $b (@ranking) {
        $raw_score{$b} = $score{$b};
        $score{$b} -= $base_score;

        $total += exp($score{$b}) if ($score{$b} > $ln2p_54 );
    }

    if ($self->{wordscores__} && defined($templ) ) {
        my %qm = %{$self->{parser__}->quickmagnets()};
        my $mlen = scalar(keys %{$self->{parser__}->quickmagnets()});

        if ( $mlen >= 0 ) {
            $templ->param( 'View_QuickMagnets_If' => 1 );
            $templ->param( 'View_QuickMagnets_Count' => ($mlen + 1) );
            my @buckets = $self->get_buckets( $session );
            my $i = 0;
            my %types = $self->get_magnet_types( $session );

            my @bucket_data;
            foreach my $bucket (@buckets) {
                my %row_data;
                $row_data{View_QuickMagnets_Bucket} = $bucket;
                $row_data{View_QuickMagnets_Bucket_Color} = $self->get_bucket_color( $session, $bucket );
                push ( @bucket_data, \%row_data );
            }

            my @qm_data;
            foreach my $type (sort keys %types) {
                my %row_data;

                if (defined $qm{$type}) {
                    $i++;

                    $row_data{View_QuickMagnets_Type} = $type;
                    $row_data{View_QuickMagnets_I} = $i;
                    $row_data{View_QuickMagnets_Loop_Buckets} = \@bucket_data;

                    my @magnet_data;
                    foreach my $magnet ( @{$qm{$type}} ) {
                        my %row_magnet;
                        $row_magnet{View_QuickMagnets_Magnet} = $magnet;
                        push ( @magnet_data, \%row_magnet );
                    }
                    $row_data{View_QuickMagnets_Loop_Magnets} = \@magnet_data;

                    push ( @qm_data, \%row_data );
                }
            }
            $templ->param( 'View_QuickMagnets_Loop' => \@qm_data );
        }

        $templ->param( 'View_Score_If_Score' => $self->{wmformat__} eq 'score' );
        my $log10 = log(10.0);

        my @score_data;
        foreach my $b (@ranking) {
             my %row_data;
             my $prob = exp($score{$b})/$total;
             my $probstr;
             my $rawstr;

             # If the computed probability would display as 1, display
             # it as .999999 instead.  We don't want to give the
             # impression that POPFile is ever completely sure of its
             # classification.

             if ($prob >= .999999) {
                 $probstr = sprintf("%12.6f", 0.999999);
             } else {
                 if ($prob >= 0.1 || $prob == 0.0) {
                     $probstr = sprintf("%12.6f", $prob);
                 } else {
                    $probstr = sprintf("%17.6e", $prob);
                 }
             }

             my $color = $self->get_bucket_color( $session, $b );

             $row_data{View_Score_Bucket} = $b;
             $row_data{View_Score_Bucket_Color} = $color;
             $row_data{View_Score_MatchCount} = $matchcount{$b};
             $row_data{View_Score_ProbStr} = $probstr;

             if ($self->{wmformat__} eq 'score') {
                 $row_data{View_Score_If_Score} = 1;
                 $rawstr = sprintf("%12.6f", ($raw_score{$b} - $correction)/$log10);
                 $row_data{View_Score_RawStr} = $rawstr;
             }
             push ( @score_data, \%row_data );
        }
        $templ->param( 'View_Score_Loop_Scores' => \@score_data );

        if ( $self->{wmformat__} ne '' ) {
            $templ->param( 'View_Score_If_Table' => 1 );

            my @header_data;
            foreach my $ix (0..($#buckets > 7? 7: $#buckets)) {
                my %row_data;
                my $bucket = $ranking[$ix];
                my $bucketcolor  = $self->get_bucket_color( $session, $bucket );
                $row_data{View_Score_Bucket} = $bucket;
                $row_data{View_Score_Bucket_Color} = $bucketcolor;
                push ( @header_data, \%row_data );
            }
            $templ->param( 'View_Score_Loop_Bucket_Header' => \@header_data );

            my %wordprobs;

            # If the word matrix is supposed to show probabilities,
            # compute them, saving the results in %wordprobs.

            if ( $self->{wmformat__} eq 'prob') {
                foreach my $id (@id_list) {
                    my $sumfreq = 0;
                    my %wval;
                    foreach my $bucket (@ranking) {
                        $wval{$bucket} = $$matrix{$id}{$bucket} || 0;
                        $sumfreq += $wval{$bucket};
                    }

                    # If $sumfreq is still zero then this word didn't
                    # appear in any buckets so we shouldn't create
                    # wordprobs entries for it

                    if ( $sumfreq != 0 ) {
                        foreach my $bucket (@ranking) {
                            $wordprobs{$bucket,$id} = $wval{$bucket} / $sumfreq;
                        }
                    }
                }
            }

            my @ranked_ids;
            if ($self->{wmformat__} eq 'prob') {
                @ranked_ids = sort {($wordprobs{$ranking[0],$b}||0) <=> ($wordprobs{$ranking[0],$a}||0)} @id_list;
            } else {
                @ranked_ids = sort {($$matrix{$b}{$ranking[0]}||0) <=> ($$matrix{$a}{$ranking[0]}||0)} @id_list;
            }

            my @word_data;
            my %chart;
            foreach my $id (@ranked_ids) {
                my %row_data;
                my $known = 0;

                foreach my $bucket (@ranking) {
                    if ( defined( $$matrix{$id}{$bucket} ) ) {
                        $known = 1;
                        last;
                    }
                }

                if ( $known == 1 ) {
                    my $wordcolor = $self->get_bucket_color( $session, $self->get_top_bucket__( $userid, $id, $matrix, \@ranking ) );
                    my $count = $self->{parser__}->{words__}{$$idmap{$id}};

                    $row_data{View_Score_Word} = $$idmap{$id};
                    $row_data{View_Score_Word_Color} = $wordcolor;
                    $row_data{View_Score_Word_Count} = $count;

                    my $base_probability = 0;
                    if ( defined($$matrix{$id}{$ranking[0]}) && ( $$matrix{$id}{$ranking[0]} > 0 ) ) {
                        $base_probability = log( $$matrix{$id}{$ranking[0]} / $self->{db_bucketcount__}{$userid}{$ranking[0]} );
                    }

                    my @per_bucket;
                    my @score;
                    foreach my $ix (0..($#buckets > 7? 7: $#buckets)) {
                        my %bucket_row;
                        my $bucket = $ranking[$ix];
                        my $probability = 0;
                        if ( defined($$matrix{$id}{$bucket}) && ( $$matrix{$id}{$bucket} > 0 ) ) {
                            $probability = log( $$matrix{$id}{$bucket} / $self->{db_bucketcount__}{$userid}{$bucket} );
                        }
                        my $color = 'black';

                        if ( $probability >= $base_probability || $base_probability == 0 ) {
                            $color = $self->get_bucket_color( $session, $bucket );
                        }

                        $bucket_row{View_Score_If_Probability} = ( $probability != 0 );
                        $bucket_row{View_Score_Word_Color} = $color;
                        if ( $probability != 0 ) {
                            my $wordprobstr;
                            if ($self->{wmformat__} eq 'score') {
                                $wordprobstr  = sprintf("%12.4f", ($probability - $self->{not_likely__}{$userid})/$log10 );
                                push ( @score, $wordprobstr );
                            } else {
                                if ($self->{wmformat__} eq 'prob') {
                                    $wordprobstr  = sprintf("%12.4f", $wordprobs{$bucket,$id});
                                } else {
                                    $wordprobstr  = sprintf("%13.5f", exp($probability) );
                                }
                            }
                            $bucket_row{View_Score_Probability} = $wordprobstr;
                        }
                        else {
                            # Scores eq 0 must also be remembered.
                            push @score, 0;
                        }
                        push ( @per_bucket, \%bucket_row );
                    }
                    $row_data{View_Score_Loop_Per_Bucket} = \@per_bucket;

                    # If we are doing the word scores then we build up
                    # a hash that maps the name of a word to a value
                    # which is the difference between the word scores
                    # for the top two buckets.  We later use this to
                    # draw a chart

                    if ( $self->{wmformat__} eq 'score' ) {
                        $chart{$$idmap{$id}} = ( $score[0] || 0 ) - ( $score[1] || 0 );
                    }

                    push ( @word_data, \%row_data );
                }
            }
            $templ->param( 'View_Score_Loop_Words' => \@word_data );

            if ( $self->{wmformat__} eq 'score' ) {
                # Draw a chart that shows how the decision between the top
                # two buckets was made.

                my @words = sort { $chart{$b} <=> $chart{$a} } keys %chart;

                my @chart_data;
                my $max_chart = $chart{$words[0]};
                my $min_chart = $chart{$words[$#words]};
                my $scale = ( $max_chart > $min_chart ) ? 400 / ( $max_chart - $min_chart ) : 0;

                my $color_1 = $self->get_bucket_color( $session, $ranking[0] );
                my $color_2 = $self->get_bucket_color( $session, $ranking[1] );

                $templ->param( 'Bucket_1' => $ranking[0] );
                $templ->param( 'Bucket_2' => $ranking[1] );

                $templ->param( 'Color_Bucket_1' => $color_1 );
                $templ->param( 'Color_Bucket_2' => $color_2 );

                $templ->param( 'Score_Bucket_1' => sprintf("%.3f", ($raw_score{$ranking[0]} - $correction)/$log10) );
                $templ->param( 'Score_Bucket_2' => sprintf("%.3f", ($raw_score{$ranking[1]} - $correction)/$log10) );

                for ( my $i=0; $i <= $#words; $i++ ) {
                    my $word_1 = $words[$i];
                    my $word_2 = $words[$#words - $i];

                    my $width_1 = int( $chart{$word_1} * $scale + .5 );
                    my $width_2 = int( $chart{$word_2} * $scale - .5 ) * -1;

                    last if ( $width_1 <=0 && $width_2 <= 0 );

                    my %row_data;

                    $row_data{View_Chart_Word_1} = $word_1;
                    if ( $width_1 > 0 ) {
                        $row_data{View_If_Bar_1} = 1;
                        $row_data{View_Width_1}  = $width_1;
                        $row_data{View_Color_1}  = $color_1;
                        $row_data{Score_Word_1}  = sprintf "%.3f", $chart{$word_1};
                    }
                    else {
                        $row_data{View_If_Bar_1} = 0;
                    }

                    $row_data{View_Chart_Word_2} = $word_2;
                    if ( $width_2 > 0 ) {
                        $row_data{View_If_Bar_2} = 1;
                        $row_data{View_Width_2}  = $width_2;
                        $row_data{View_Color_2}  = $color_2;
                        $row_data{Score_Word_2}  = sprintf "%.3f", $chart{$word_2};
                    }
                    else {
                        $row_data{View_If_Bar_2} = 0;
                    }

                    push ( @chart_data, \%row_data );
                }
                $templ->param( 'View_Loop_Chart' => \@chart_data );
                $templ->param( 'If_chart' => 1 );
            }
            else {
                $templ->param( 'If_chart' => 0 );
            }
        }
    }
    $self->log_( 1, "Leaving classify. Class is $class." );

    return $class;
}

#----------------------------------------------------------------------------
#
# classify_and_modify
#
# This method reads an email terminated by . on a line by itself (or
# the end of stream) from a handle and creates an entry in the
# history, outputting the same email on another handle with the
# appropriate header modifications and insertions
#
# $session  - A valid session key returned by a call to get_session_key
# $mail     - an open stream to read the email from
# $client   - an open stream to write the modified email to
# $nosave   - set to 1 indicates that this should not save to history
# $class    - if we already know the classification
# $slot     - Must be defined if $class is set
# $echo     - 1 to echo to the client, 0 to supress, defaults to 1
# $crlf     - The sequence to use at the end of a line in the output,
#   normally this is left undefined and this method uses $eol (the
#   normal network end of line), but if this method is being used with
#   real files you may wish to pass in \n instead
#
# Returns a classification if it worked and the slot ID of the history
# item related to this classification
#
# IMPORTANT NOTE: $mail and $client should be binmode
#
#----------------------------------------------------------------------------
sub classify_and_modify
{
    my ( $self, $session, $mail, $client, $nosave, $class, $slot, $echo, $crlf ) = @_;

    $self->log_( 1, "Starting classify_and_modify" );

    $echo = 1    unless (defined $echo);
    $crlf = $eol unless (defined $crlf);

    my $msg_subject;              # The message subject
    my $msg_head_before = '';     # Store the message headers that
                                  # come before Subject here
    my $msg_head_after = '';      # Store the message headers that
                                  # come after Subject here
    my $msg_head_q      = '';     # Store questionable header lines here
    my $msg_body        = '';     # Store the message body here
    my $in_subject_header = 0;    # 1 if in Subject header

    # These two variables are used to control the insertion of the
    # X-POPFile-TimeoutPrevention header when downloading long or slow
    # emails

    my $last_timeout   = time;
    my $timeout_count  = 0;

    # Indicates whether the first time through the receive loop we got
    # the full body, this will happen on small emails

    my $got_full_body  = 0;

    # The size of the message downloaded so far.

    my $message_size   = 0;

    # The classification for this message

    my $classification = '';

    # Whether we are currently reading the mail headers or not

    my $getting_headers = 1;

    my $msg_file;

    # If we don't yet know the classification then start the parser

    $class = '' if ( !defined( $class ) );
    if ( $class eq '' ) {
        $self->{parser__}->start_parse();
        ( $slot, $msg_file ) = $self->history_()->reserve_slot();
    } else {
        $msg_file = $self->history_()->get_slot_file( $slot );
    }

    # We append .TMP to the filename for the MSG file so that if we are in
    # middle of downloading a message and we refresh the history we do not
    # get class file errors

    open MSG, ">$msg_file" unless $nosave;

    $self->log_( 1, "Reading mail message." );
    while ( my $line = $self->slurp_( $mail ) ) {
        my $fileline;

        # This is done so that we remove the network style end of line
        # CR LF and allow Perl to decide on the local system EOL which
        # it will expand out of \n when this gets written to the temp
        # file

        $fileline = $line;
        $fileline =~ s/[\r\n]//g;
        $fileline .= "\n";

        # Check for an abort

        last if ( $self->{alive_} == 0 );

        # The termination of a message is a line consisting of exactly
        # .CRLF so we detect that here exactly

        if ( $line =~ /^\.(\r\n|\r|\n)$/ ) {
            $got_full_body = 1;
            last;
        }

        if ( $getting_headers )  {

            # Kill header lines containing only whitespace (Exim does this)

            next if ( $line =~ /^[ \t]+(\r\n|\r|\n)$/i );

            if ( !( $line =~ /^(\r\n|\r|\n)$/i ) )  {
                $message_size += length $line;
                $self->write_line__( $nosave?undef:\*MSG, $fileline, $class );

                # If there is no echoing occuring, it doesn't matter
                # what we do to these

                if ( $echo ) {
                    if ( $line =~ /^Subject:(.*)/i )  {
                        $msg_subject = $1;
                        $msg_subject =~ s/(\012|\015)//g;
                        $in_subject_header = 1;
                        next;
                    } elsif ( $line !~ /^[ \t]/ ) {
                        $in_subject_header = 0;
                    }

                    # Strip out the X-Text-Classification header that
                    # is in an incoming message

                    next if ( $line =~ /^X-Text-Classification:/i );
                    next if ( $line =~ /^X-POPFile-Link:/i );

                    # Store any lines that appear as though they may
                    # be non-header content Lines that are headers
                    # begin with whitespace or Alphanumerics and "-"
                    # followed by a colon.
                    #
                    # This prevents weird things like HTML before the
                    # headers terminate from causing the XPL and XTC
                    # headers to be inserted in places some clients
                    # can't detect

                    if ( ( $line =~ /^[ \t]/ ) && $in_subject_header ) {
                        $line =~ s/(\012|\015)//g;
                        $msg_subject .= $crlf . $line;
                        next;
                    }

                    if ( $line =~ /^([ \t]|([A-Z0-9\-_]+:))/i ) {
                        if ( !defined($msg_subject) )  {
                            $msg_head_before .= $msg_head_q . $line;
                        } else {
                            $msg_head_after  .= $msg_head_q . $line;
                        }
                        $msg_head_q = '';
                    } else {

                        # Gather up any header lines that are questionable

                        $self->log_( 1, "Found odd email header: $line" );
                        $msg_head_q .= $line;
                    }
                }
            } else {
                $self->write_line__( $nosave?undef:\*MSG, "\n", $class );
                $message_size += length $crlf;
                $getting_headers = 0;
            }
        } else {
            $message_size += length $line;
            $msg_body     .= $line;
            $self->write_line__( $nosave?undef:\*MSG, $fileline, $class );
        }

        # Check to see if too much time has passed and we need to keep
        # the mail client happy

        if ( time > ( $last_timeout + 2 ) ) {
            print $client "X-POPFile-TimeoutPrevention: $timeout_count$crlf" if ( $echo );
            $timeout_count += 1;
            $last_timeout = time;
        }

        last if ( ( $message_size > $self->global_config_( 'message_cutoff' ) ) && ( $getting_headers == 0 ) );
    }

    close MSG unless $nosave;

    # If we don't yet know the classification then stop the parser
    if ( $class eq '' ) {
        $self->{parser__}->stop_parse();
    }

    # Do the text classification and update the counter for that
    # bucket that we just downloaded an email of that type

    $classification = ($class ne '')?$class:$self->classify( $session, undef);

    my $subject_modification = $self->get_bucket_parameter( $session, $classification, 'subject'    );
    my $xtc_insertion        = $self->get_bucket_parameter( $session, $classification, 'xtc'        );
    my $xpl_insertion        = $self->get_bucket_parameter( $session, $classification, 'xpl'        );
    my $quarantine           = $self->get_bucket_parameter( $session, $classification, 'quarantine' );

    my $modification = $self->user_config_( 1, 'subject_mod_left' ) . $classification . $self->user_config_( 1, 'subject_mod_right' );

    # Add the Subject line modification or the original line back again
    # Don't add the classification unless it is not present

    if (  ( defined( $msg_subject ) && ( $msg_subject !~ /\Q$modification\E/ ) ) && # PROFILE BLOCK START
          ( $subject_modification == 1 ) &&
          ( $quarantine == 0 ) )  {                                                 # PROFILE BLOCK STOP
         $msg_subject = " $modification$msg_subject";
    }

    if ( !defined( $msg_subject )       &&                                         # PROFILE BLOCK START
         ( $subject_modification == 1 ) &&
         ( $quarantine == 0 ) )  {                                                 # PROFILE BLOCK STOP
         $msg_subject = " $modification";
    }

    $msg_subject = '' if ( !defined( $msg_subject ) );

    $msg_head_before .= 'Subject:' . $msg_subject;
    $msg_head_before .= $crlf;

    # Add the XTC header
    $msg_head_after .= "X-Text-Classification: $classification$crlf" if ( ( $xtc_insertion   ) && # PROFILE BLOCK START
                                                                          ( $quarantine == 0 ) ); # PROFILE BLOCK STOP

    # Add the XPL header

    my $xpl = $self->user_config_( 1, 'xpl_angle' )?'<':'';

    my $xpl_localhost = ($self->config_( 'localhostname' ) eq '')?"127.0.0.1":$self->config_( 'localhostname' );

    $xpl .= "http://";
    $xpl .= $self->module_config_( 'html', 'local' )?$xpl_localhost:$self->config_( 'hostname' );
    $xpl .= ":" . $self->module_config_( 'html', 'port' ) . "/jump_to_message?view=$slot";

    if ( $self->user_config_( 1, 'xpl_angle' ) ) {
        $xpl .= '>';
    }

    $xpl .= "$crlf";

    if ( $xpl_insertion && ( $quarantine == 0 ) ) {
        $msg_head_after .= 'X-POPFile-Link: ' . $xpl;
    }

    $msg_head_after .= $msg_head_q . "$crlf";

    # Echo the text of the message to the client

    if ( $echo ) {

        # If the bucket is quarantined then we'll treat it specially
        # by changing the message header to contain information from
        # POPFile and wrapping the original message in a MIME encoding

       if ( $quarantine == 1 ) {
           my ( $orig_from, $orig_to, $orig_subject ) = ( $self->{parser__}->get_header('from'), $self->{parser__}->get_header('to'), $self->{parser__}->get_header('subject') );
           my ( $encoded_from, $encoded_to ) = ( $orig_from, $orig_to );
           if ( $self->{parser__}->{lang__} eq 'Nihongo' ) {
               require Encode;

               Encode::from_to( $orig_from, 'euc-jp', 'iso-2022-jp');
               Encode::from_to( $orig_to, 'euc-jp', 'iso-2022-jp');
               Encode::from_to( $orig_subject, 'euc-jp', 'iso-2022-jp');

               $encoded_from = $orig_from;
               $encoded_to = $orig_to;
               $encoded_from =~ s/(\x1B\x24\x42.+\x1B\x28\x42)/"=?ISO-2022-JP?B?" . encode_base64($1,'') . "?="/eg;
               $encoded_to =~ s/(\x1B\x24\x42.+\x1B\x28\x42)/"=?ISO-2022-JP?B?" . encode_base64($1,'') . "?="/eg;
           }

           print $client "From: $encoded_from$crlf";
           print $client "To: $encoded_to$crlf";
           print $client "Date: " . $self->{parser__}->get_header( 'date' ) . "$crlf";
           # Don't add the classification unless it is not present
           if ( ( defined( $msg_subject ) && ( $msg_subject !~ /\[\Q$classification\E\]/ ) ) && # PROFILE BLOCK START
                 ( $subject_modification == 1 ) ) {                                             # PROFILE BLOCK STOP
               $msg_subject = " $modification$msg_subject";
           }
           print $client "Subject:$msg_subject$crlf";
           print $client "X-Text-Classification: $classification$crlf" if ( $xtc_insertion );
           print $client 'X-POPFile-Link: ' . $xpl if ( $xpl_insertion );
           print $client "MIME-Version: 1.0$crlf";
           print $client "Content-Type: multipart/report; boundary=\"$slot\"$crlf$crlf--$slot$crlf";
           print $client "Content-Type: text/plain";
           print $client "; charset=iso-2022-jp" if ( $self->{parser__}->{lang__} eq 'Nihongo' );
           print $client "$crlf$crlf";
           print $client "POPFile has quarantined a message.  It is attached to this email.$crlf$crlf";
           print $client "Quarantined Message Detail$crlf$crlf";

           print $client "Original From: $orig_from$crlf";
           print $client "Original To: $orig_to$crlf";
           print $client "Original Subject: $orig_subject$crlf";

           print $client "To examine the email open the attachment. ";
           print $client "To change this mail's classification go to $xpl";
           print $client "$crlf";
           print $client "The first 20 words found in the email are:$crlf$crlf";

           my $first20 = $self->{parser__}->first20();
           if ( $self->{parser__}->{lang__} eq 'Nihongo' ) {
               require Encode;

               Encode::from_to( $first20, 'euc-jp', 'iso-2022-jp');
           }

           print $client $first20;
           print $client "$crlf--$slot$crlf";
           print $client "Content-Type: message/rfc822$crlf$crlf";
        }

        print $client $msg_head_before;
        print $client $msg_head_after;
        print $client $msg_body;
    }

    my $before_dot = '';

    if ( $quarantine && $echo ) {
        $before_dot = "$crlf--$slot--$crlf";
    }

    my $need_dot = 0;

    if ( $got_full_body ) {
        $need_dot = 1;
    } else {
        $need_dot = !$self->echo_to_dot_( $mail, $echo?$client:undef, $nosave?undef:'>>' . $msg_file, $before_dot ) && !$nosave;
    }

    if ( $need_dot ) {
        print $client $before_dot if ( $before_dot ne '' );
        print $client ".$crlf"    if ( $echo );
    }

    # In some cases it's possible (and totally illegal) to get a . in
    # the middle of the message, to cope with the we call flush_extra_
    # here to remove any extra stuff the POP3 server is sending Make
    # sure to supress output if we are not echoing, and to save to
    # file if not echoing and saving

    if ( !($nosave || $echo) ) {

        # if we're saving (not nosave) and not echoing, we can safely
        # unload this into the temp file

        if (open FLUSH, ">$msg_file.flush") {
            binmode FLUSH;

            # TODO: Do this in a faster way (without flushing to one
            # file then copying to another) (perhaps a select on $mail
            # to predict if there is flushable data)

            $self->flush_extra_( $mail, \*FLUSH, 0 );
            close FLUSH;

            # append any data we got to the actual temp file

            if ( ( (-s "$msg_file.flush") > 0 ) &&
                   ( open FLUSH, "<$msg_file.flush" ) ) {
                binmode FLUSH;
                if ( open TEMP, ">>$msg_file" ) {
                    binmode TEMP;

                    # The only time we get data here is if it is after
                    # a CRLF.CRLF We have to re-create it to avoid
                    # data-loss

                    print TEMP ".$crlf";

                    print TEMP $_ while (<FLUSH>);

                    # NOTE: The last line flushed MAY be a CRLF.CRLF,
                    # which isn't actually part of the message body

                    close TEMP;
                }
                close FLUSH;
            }
            unlink("$msg_file.flush");
        }
    } else {

        # if we are echoing, the client can make sure we have no data
        # loss otherwise, the data can be discarded (not saved and not
        # echoed)

        $self->flush_extra_( $mail, $client, $echo?0:1);
    }

    if ( $class eq '' ) {
        if ( $nosave ) {
            $self->history_()->release_slot( $slot );
        } else {
            $self->history_()->commit_slot( $session, $slot, $classification, $self->{magnet_detail__} );
        }
    }
    $self->log_( 1, "classify_and_modify done. Classification is $classification" );

    return ( $classification, $slot, $self->{magnet_used__} );
}

#----------------------------------------------------------------------------
#
# reclassify
#
# Called to inform the module about a reclassification from one bucket
# to another
#
# session            Valid API session
# messages           hash mapping message slots to new buckets
#
# Returns 0 if succesful, undef if there was an error
#
#----------------------------------------------------------------------------
sub reclassify
{

    my ($self, $session, %messages ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $self->log_( 0, "Performing some reclassification. " . scalar %messages );

    my %work;
    while ( my ( $slot, $newbucket ) = each %messages ) {
        $self->log_(2, "Message $slot will be reclassified to $newbucket" );
        push @{$work{$newbucket}},
                $self->history_()->get_slot_file( $slot );
        my @fields = $self->history_()->get_slot_fields( $slot);
        my $bucket = $fields[8];
        $self->classifier_()->reclassified(
            $session, $bucket, $newbucket, 0 );
        $self->history_()->change_slot_classification(
                $slot, $newbucket, $session, 0);
    }

    # At this point the work hash maps the buckets to lists of
    # files to reclassify, so run through them doing bulk updates

    foreach my $newbucket (keys %work) {
        $self->classifier_()->add_messages_to_bucket(
            $session, $newbucket, @{$work{$newbucket}} );

        $self->log_( 1, "Reclassified " . $#{$work{$newbucket}} . " messages to $newbucket" );
    }
    return 0;
}

#----------------------------------------------------------------------------
#
# get_accounts (ADMIN ONLY)
#
# Returns a list of accounts associatd with the passed in user ID.  This
# function is ADMIN ONLY.
#
# $session   A valid session key returned by a call to get_session_key
# $id        A user id
#
#----------------------------------------------------------------------------
sub get_accounts
{
    my ( $self, $session, $id ) = @_;

    # Check that this user is an administrator

    my $can_admin = $self->get_user_parameter( $session, 'GLOBAL_can_admin' );

    if ( $can_admin != 1 ) {
        return undef;
    }

    # If user is an admin then grab the accounts for the user requested

    my $h = $self->db_()->prepare( "select account from accounts where userid = $id;" );
    $h->execute;
    my @accounts;
    while ( my $row = $h->fetchrow_arrayref ) {
        push ( @accounts, $row->[0] );
    }
    $h->finish;

    return @accounts;
}

#----------------------------------------------------------------------------
#
# add_account (ADMIN ONLY)
#
# Add an account associated with a user
#
# $session   A valid session key returned by a call to get_session_key
# $id        A user id
# $module    The module adding the account
# $account   The account to add
#
# Returns 1 if the account was added successfully, or 0 for an error,
# -1 if another user already has that account associated with it
# ----------------------------------------------------------------------------
sub add_account
{
    my ( $self, $session, $id, $module, $account ) = @_;

    # Check that this user is an administrator

    my $can_admin = $self->get_user_parameter( $session, 'GLOBAL_can_admin' );

    if ( $can_admin != 1 ) {
        return 0;
    }

    # User is admin so try to insert the new account after checking to see
    # if someone already has this account

    my $result = $self->{db_get_user_from_account__}->execute( "$module:$account" );
    if ( !defined( $result ) ) {
        return 0;
    }
    if ( defined( $self->{db_get_user_from_account__}->fetchrow_arrayref ) ) {
        return -1;
    }

    $account = $self->db_()->quote( "$module:$account" );
    my $h = $self->db_()->prepare( "insert into accounts ( userid, account ) values ( $id, $account );" );
    if ( !defined( $h->execute ) ) {
        return 0;
    }

    return 1;
}

#----------------------------------------------------------------------------
#
# remove_account (ADMIN ONLY)
#
# Remove an account associated with a user
#
# $session   A valid session key returned by a call to get_session_key
# $module    The module removing the account
# $account   The account to remove
#
# Returns 1 if the account was successfully removed, 0 if not
#
#----------------------------------------------------------------------------
sub remove_account
{
    my ( $self, $session, $module, $account ) = @_;

    # Check that this user is an administrator

    my $can_admin = $self->get_user_parameter( $session, 'GLOBAL_can_admin' );

    if ( $can_admin != 1 ) {
        return 0;
    }

    my $result = $self->db_()->do( "delete from accounts where account = '$module:$account';" );

    return defined( $result );
}

#----------------------------------------------------------------------------
#
# get_buckets
#
# Returns a list containing all the real bucket names sorted into
# alphabetic order
#
# $session   A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub get_buckets
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Note that get_buckets does not return pseudo buckets

    my @buckets;

    for my $b (sort keys %{$self->{db_bucketid__}{$userid}}) {
        if ( $self->{db_bucketid__}{$userid}{$b}{pseudo} == 0 ) {
            push @buckets, ($b);
        }
    }

    return @buckets;
}

#----------------------------------------------------------------------------
#
# get_bucket_id
#
# Returns the internal ID for a bucket for database calls
#
# $session   A valid session key returned by a call to get_session_key
# $bucket    The bucket name
#
#----------------------------------------------------------------------------
sub get_bucket_id
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    return $self->{db_bucketid__}{$userid}{$bucket}{id};
}

#----------------------------------------------------------------------------
#
# get_bucket_name
#
# Returns the name of a bucket from an internal ID
#
# $session   A valid session key returned by a call to get_session_key
# $id        The bucket id
#
#----------------------------------------------------------------------------
sub get_bucket_name
{
    my ( $self, $session, $id ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    foreach $b (keys %{$self->{db_bucketid__}{$userid}}) {
        if ( $id == $self->{db_bucketid__}{$userid}{$b}{id} ) {
            return $b;
        }
    }

    return '';
}

#----------------------------------------------------------------------------
#
# get_pseudo_buckets
#
# Returns a list containing all the pseudo bucket names sorted into
# alphabetic order
#
# $session   A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub get_pseudo_buckets
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my @buckets;

    for my $b (sort keys %{$self->{db_bucketid__}{$userid}}) {
        if ( $self->{db_bucketid__}{$userid}{$b}{pseudo} == 1 ) {
            push @buckets, ($b);
        }
    }

    return @buckets;
}

#----------------------------------------------------------------------------
#
# get_all_buckets
#
# Returns a list containing all the bucket names sorted into
# alphabetic order
#
# $session   A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub get_all_buckets
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my @buckets;

    for my $b (sort keys %{$self->{db_bucketid__}{$userid}}) {
         push @buckets, ($b);
    }

    return @buckets;
}

#----------------------------------------------------------------------------
#
# is_pseudo_bucket
#
# Returns 1 if the named bucket is pseudo
#
# $session   A valid session key returned by a call to get_session_key
# $bucket    The bucket to check
#
#----------------------------------------------------------------------------
sub is_pseudo_bucket
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    return ( defined($self->{db_bucketid__}{$userid}{$bucket})   # PROFILE BLOCK START
          && $self->{db_bucketid__}{$userid}{$bucket}{pseudo} ); # PROFILE BLOCK STOP
}

#----------------------------------------------------------------------------
#
# is_bucket
#
# Returns 1 if the named bucket is a bucket
#
# $session   A valid session key returned by a call to get_session_key
# $bucket    The bucket to check
#
#----------------------------------------------------------------------------
sub is_bucket
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    return ( ( defined( $self->{db_bucketid__}{$userid}{$bucket} ) ) &&  # PROFILE BLOCK START
             ( !$self->{db_bucketid__}{$userid}{$bucket}{pseudo} ) );    # PROFILE BLOCK STOP
}

#----------------------------------------------------------------------------
#
# get_bucket_word_count
#
# Returns the total word count (including duplicates) for the passed in bucket
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      The name of the bucket for which the word count is desired
#
#----------------------------------------------------------------------------
sub get_bucket_word_count
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my $c = $self->{db_bucketcount__}{$userid}{$bucket};

    return defined($c)?$c:0;
}

#----------------------------------------------------------------------------
#
# get_bucket_word_list
#
# Returns a list of words all with the same first character
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      The name of the bucket for which the word count is desired
# $prefix      The first character of the words
#
#----------------------------------------------------------------------------
sub get_bucket_word_list
{
    my ( $self, $session, $bucket, $prefix ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
    my $result = $self->db_()->selectcol_arrayref(  # PROFILE BLOCK START
        "select words.word from matrix, words
         where matrix.wordid  = words.id and
               matrix.bucketid = $bucketid and
               words.word like '$prefix%';");        # PROFILE BLOCK STOP

    return @{$result};
}

#----------------------------------------------------------------------------
#
# get_bucket_word_prefixes
#
# Returns a list of all the initial letters of words in a bucket
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      The name of the bucket for which the word count is desired
#
#----------------------------------------------------------------------------
sub get_bucket_word_prefixes
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my $prev = '';

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
    my $result = $self->db_()->selectcol_arrayref(   # PROFILE BLOCK START
        "select words.word from matrix, words
         where matrix.wordid  = words.id and
               matrix.bucketid = $bucketid;");        # PROFILE BLOCK STOP

    # In Japanese mode, disable locale and use substr_euc, the substr
    # function which supports EUC Japanese charset.  Sorting Japanese
    # with "use locale" is memory and time consuming, and may cause
    # perl crash.

    if ( $self->user_module_config_( 1, 'html', 'language' ) eq 'Nihongo' ) {
        return grep {$_ ne $prev && ($prev = $_, 1)} sort map {substr_euc__($_,0,1)} @{$result};
    } else {
        if  ( $self->user_module_config_( 1, 'html', 'language' ) eq 'Korean' ) {
            return grep {$_ ne $prev && ($prev = $_, 1)} sort map {$_ =~ /([\x20-\x80]|$eksc)/} @{$result};
        } else {
            return grep {$_ ne $prev && ($prev = $_, 1)} sort map {substr($_,0,1)}  @{$result};
        }
    }
}

#----------------------------------------------------------------------------
#
# get_word_count
#
# Returns the total word count (including duplicates)
#
# $session   A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub get_word_count
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $self->{db_get_full_total__}->execute( $userid );
    return $self->{db_get_full_total__}->fetchrow_arrayref->[0];
}

#----------------------------------------------------------------------------
#
# get_count_for_word
#
# Returns the number of times the word occurs in a bucket
#
# $session         A valid session key returned by a call to get_session_key
# $bucket          The bucket we are asking about
# $word            The word we are asking about
#
#----------------------------------------------------------------------------
sub get_count_for_word
{
    my ( $self, $session, $bucket, $word ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    return $self->get_base_value_( $session, $bucket, $word );
}

#----------------------------------------------------------------------------
#
# get_bucket_unique_count
#
# Returns the unique word count (excluding duplicates) for the passed
# in bucket
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      The name of the bucket for which the word count is desired
#
#----------------------------------------------------------------------------
sub get_bucket_unique_count
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my $c = $self->{db_bucketunique__}{$userid}{$bucket};

    return defined($c)?$c:0;
}

#----------------------------------------------------------------------------
#
# get_unique_word_count
#
# Returns the unique word count (excluding duplicates) for all buckets
#
# $session   A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub get_unique_word_count
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $self->{db_get_unique_word_count__}->execute( $userid );
    return $self->{db_get_unique_word_count__}->fetchrow_arrayref->[0];
}

#----------------------------------------------------------------------------
#
# get_bucket_color
#
# Returns the color associated with a bucket
#
# $session   A valid session key returned by a call to get_session_key
# $bucket      The name of the bucket for which the color is requested
#
# NOTE  This API is DEPRECATED in favor of calling get_bucket_parameter for
#       the parameter named 'color'
#----------------------------------------------------------------------------
sub get_bucket_color
{
    my ( $self, $session, $bucket ) = @_;

    return $self->get_bucket_parameter( $session, $bucket, 'color' );
}

#----------------------------------------------------------------------------
#
# set_bucket_color
#
# Returns the color associated with a bucket
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      The name of the bucket for which the color is requested
# $color       The new color
#
# NOTE  This API is DEPRECATED in favor of calling set_bucket_parameter for
#       the parameter named 'color'
#----------------------------------------------------------------------------
sub set_bucket_color
{
    my ( $self, $session, $bucket, $color ) = @_;

    return $self->set_bucket_parameter( $session, $bucket, 'color', $color );
}

#----------------------------------------------------------------------------
#
# get_bucket_parameter
#
# Returns the value of a per bucket parameter
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      The name of the bucket
# $parameter   The name of the parameter
#
#----------------------------------------------------------------------------
sub get_bucket_parameter
{
    my ( $self, $session, $bucket, $parameter ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # See if there's a cached value

    if ( defined( $self->{db_parameters__}{$userid}{$bucket}{$parameter} ) ) {
        return $self->{db_parameters__}{$userid}{$bucket}{$parameter};
    }

    # Make sure that the bucket passed in actually exists

    if ( !defined( $self->{db_bucketid__}{$userid}{$bucket} ) ) {
        return undef;
    }

    # If there is a non-default value for this parameter then return it.

    $self->{db_get_bucket_parameter__}->execute( $self->{db_bucketid__}{$userid}{$bucket}{id}, $self->{db_parameterid__}{$parameter} );
    my $result = $self->{db_get_bucket_parameter__}->fetchrow_arrayref;

    # If this parameter has not been defined for this specific bucket then
    # get the default value

    if ( !defined( $result ) ) {
        $self->{db_get_bucket_parameter_default__}->execute(  # PROFILE BLOCK START
            $self->{db_parameterid__}{$parameter} );          # PROFILE BLOCK STOP
        $result = $self->{db_get_bucket_parameter_default__}->fetchrow_arrayref;
    }

    if ( defined( $result ) ) {
        $self->{db_parameters__}{$userid}{$bucket}{$parameter} = $result->[0];
        return $result->[0];
    } else {
        return undef;
    }
}

#----------------------------------------------------------------------------
#
# create_user (ADMIN ONLY)
#
# Creates a new user with a given name and optionally copies the
# configuration of another user.
#
# $session     A valid session ID for an administrator
# $new_user    The name for the new user
# $clone       (optional) Name of user to clone
#
# Returns 0 for success, 1 for user already exists, 2 for other error,
# 3 for clone failure and undef if caller isn't an admin.  If
# successful also returns an initial password for the user.
#
# ----------------------------------------------------------------------------
sub create_user
{
    my ( $self, $session, $new_user, $clone ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Check that this user is an administrator

    my $can_admin = $self->get_user_parameter( $session, 'GLOBAL_can_admin' );

    if ( $can_admin != 1 ) {
        return ( undef, undef );
    }

    # Check to see if we already have a user with that name

    if ( defined( $self->get_user_id( $session, $new_user ) ) ) {
        return ( 1, undef );
    }

    my $password = '';
    my @chars = split( //,'abcdefghijklmnopqurstuvwxyz0123456789' );

    while ( length( $password ) < 8 ) {
        my $c = $chars[int(rand($#chars+1))];
        if ( int(rand(2)) == 1 ) {
            $c = uc($c);
        }
        $password .= $c;
    }

    my $password_hash = md5_hex( $new_user . '__popfile__' . $password );

    $self->db_()->do( "insert into users ( name, password ) values ( '$new_user', '$password_hash' );" );

    my $id = $self->get_user_id( $session, $new_user );

    if ( !defined( $id ) ) {
        return ( 2, undef );
    }

    # See if we need to clone the configuration of another user and
    # only clone non-default values

    if ( defined( $clone ) && ( $clone ne '' ) ) {
        my $clid = $self->get_user_id( $session, $clone );
        if ( !defined( $clid ) ) {
            return ( 3, undef );
        }
        my $h = $self->db_()->prepare( "select utid, val from user_params where userid = $clid;" );
        $h->execute;
        my %add;
        while ( my $row = $h->fetchrow_arrayref ) {
            $add{$row->[0]} = $row->[1];
        }
        $h->finish;
        foreach my $utid (keys %add) {
            $self->db_()->do( "insert into user_params ( userid, utid, val ) values ( $id, $utid, '$add{$utid}' );" );
        }

        # Clone buckets

        $h = $self->db_()->prepare( "select name, pseudo from buckets where userid = $clid;" );
        $h->execute;
        my %buckets;
        while ( my $row = $h->fetchrow_arrayref ) {
            $buckets{$row->[0]} = $row->[1];
        }
        $h->finish;
        foreach my $name (keys %buckets) {
            $self->db_()->do( "insert into buckets ( userid, name, pseudo ) values ( $id, '$name', $buckets{$name} );" );
        }

        # TODO clone bucket parameters
    } else {

        # If we are not cloning a user then they need at least the
        # default settings

        $self->db_()->do( "insert into buckets ( name, pseudo, userid ) values ( 'unclassified', 1, $id );" );
    }

    return ( 0, $password );
}

#----------------------------------------------------------------------------
#
# remove_user (ADMIN ONLY)
#
# Removes an existing user
#
# $session     A valid session ID for an administrator
# $user        The name of the user to remove
#
# Returns 0 for success, undef for wrong permissions and 1 for user
# does not exist, 2 means tried to delete admin
#
# ----------------------------------------------------------------------------
sub remove_user
{
    my ( $self, $session, $user ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Check that this user is an administrator

    my $can_admin = $self->get_user_parameter( $session, 'GLOBAL_can_admin' );

    if ( $can_admin != 1 ) {
        return undef;
    }

    # Check that the named user is not an administrator

    my $id = $self->get_user_id( $session, $user );

    if ( defined( $id ) ) {
        my ( $val, $def ) = $self->get_user_parameter_from_id( $id,'GLOBAL_can_admin' );
        if ( $val == 0 ) {
            $self->db_()->do( "delete from users where name = '$user';" );
            return 0;
        } else {
            return 2;
        }
    }

    return 1;
}

#----------------------------------------------------------------------------
#
# validate_password
#
# Checks the password for the current user
#
# $session     A valid session ID
# $password    A possible password to check
#
# Returns 1 if the password is valid, 0 otherwise
#
# ----------------------------------------------------------------------------
sub validate_password
{
    my ( $self, $session, $password ) = @_;

    # Lookup the user name from the session key

    my $user;
    my $h = $self->db_()->prepare( "select name from users where id = $self->{api_sessions__}{$session};" );
    $h->execute;
    if ( my $row = $h->fetchrow_arrayref ) {
        $h->finish;
        $user = $row->[0];
    } else {
        return 0;
    }

    my $hash = md5_hex( $user . '__popfile__' . $password );

    $self->{db_get_userid__}->execute( $user, $hash );
    my $result = $self->{db_get_userid__}->fetchrow_arrayref;
    if ( !defined( $result ) ) {
        return 0;
    }

    return 1;
}

#----------------------------------------------------------------------------
#
# set_password
#
# Sets the password for the current user
#
# $session     A valid session ID
# $password    The new password
#
# Returns 1 if the password was updated, 0 if not
#
# ----------------------------------------------------------------------------
sub set_password
{
    my ( $self, $session, $password ) = @_;

    # Lookup the user name from the session key

    my $user;
    my $h = $self->db_()->prepare( "select name from users where id = $self->{api_sessions__}{$session};" );
    $h->execute;
    if ( my $row = $h->fetchrow_arrayref ) {
        $h->finish;
        $user = $row->[0];
    } else {
        return 0;
    }

    my $hash = md5_hex( $user . '__popfile__' . $password );

    $self->db_()->do( "update users set password = '$hash' where id = $self->{api_sessions__}{$session};" );

    return 1;
}

#----------------------------------------------------------------------------
#
# get_user_list (ADMIN ONLY)
#
# Returns a list of all users in the system
#
# $session     A valid session ID for an administrator
#
#----------------------------------------------------------------------------
sub get_user_list
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Check that this user is an administrator

    my $can_admin = $self->get_user_parameter( $session, 'GLOBAL_can_admin' );

    if ( $can_admin != 1 ) {
        return undef;
    }

    my @users;
    $self->{db_get_user_list__}->execute();
    while ( my $row = $self->{db_get_user_list__}->fetchrow_arrayref ) {
        push @users, $row->[1];
    }

    return \@users;
}

#----------------------------------------------------------------------------
#
# get_user_parameter_list (ADMIN ONLY)
#
# Returns a list of all parameters a user can have
#
# $session     A valid session ID for an administrator
#
#----------------------------------------------------------------------------
sub get_user_parameter_list
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Check that this user is an administrator

    my $can_admin = $self->get_user_parameter( $session, 'GLOBAL_can_admin' );

    if ( $can_admin != 1 ) {
        return undef;
    }

    return keys %{$self->{db_user_parameterid__}};
}

#----------------------------------------------------------------------------
#
# get_user_parameter
#
# Returns the value of a per user parameter
#
# $session     A valid session ID
# $parameter   The name of the parameter
#
#----------------------------------------------------------------------------
sub get_user_parameter
{
    my ( $self, $session, $parameter ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my ( $val, $def )= $self->get_user_parameter_from_id( $userid,$parameter );

    return $val;
}

#----------------------------------------------------------------------------
#
# get_user_id (ADMIN ONLY)
#
# Returns the database ID of a named user
#
# $session     A valid session ID
# $user        The name of the user
#
#----------------------------------------------------------------------------
sub get_user_id
{
    my ( $self, $session, $user ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Check that this user is an administrator

    my $can_admin = $self->get_user_parameter( $session, 'GLOBAL_can_admin' );

    if ( $can_admin != 1 ) {
        return undef;
    }

    my $h = $self->db_()->prepare( "select id from users where name = '$user';" );
    $h->execute;
    if ( my $row = $h->fetchrow_arrayref ) {
        $h->finish;
        return $row->[0];
    } else {
        return undef;
    }
}

#----------------------------------------------------------------------------
#
# get_user_parameter_from_id
#
# Returns the value of a per user parameter (and a boolean that
# indicates whether this is the default value or not)
#
# $user        The ID of the user
# $parameter   The name of the parameter
#
#----------------------------------------------------------------------------
sub get_user_parameter_from_id
{
    my ( $self, $user, $parameter ) = @_;

    # See if there's a cached value

    if ( exists( $self->{cached_user_parameters__}{$user}{$parameter} ) ) {
        $self->{cache_user_parameters__}{$user}{$parameter}{lastused} = time;
        return ($self->{cached_user_parameters__}{$user}{$parameter}{value},
                $self->{cached_user_parameters__}{$user}{$parameter}{default});
    }

    # If there is a non-default value for this parameter then return it.

    $self->{db_get_user_parameter__}->execute( $user, $self->{db_user_parameterid__}{$parameter} );
    my $result = $self->{db_get_user_parameter__}->fetchrow_arrayref;

    # If this parameter has not been defined for this specific user then
    # get the default value

    my $default = 0;
    if ( !defined( $result ) ) {
        $self->{db_get_user_parameter_default__}->execute(  # PROFILE BLOCK START
            $self->{db_user_parameterid__}{$parameter} );          # PROFILE BLOCK STOP
        $result = $self->{db_get_user_parameter_default__}->fetchrow_arrayref;
        $default = 1;
    }

    if ( defined( $result ) ) {
        $self->{cached_user_parameters__}{$user}{$parameter}{value} =
            $result->[0];
        $self->{cached_user_parameters__}{$user}{$parameter}{default} =
            $default;
        $self->{cached_user_parameters__}{$user}{$parameter}{lastused} =
            time;
        return ( $result->[0], $default );
    } else {
        return ( undef, undef );
    }
}

#----------------------------------------------------------------------------
#
# set_bucket_parameter
#
# Sets the value associated with a bucket specific parameter
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      The name of the bucket
# $parameter   The name of the parameter
# $value       The new value
#
#----------------------------------------------------------------------------
sub set_bucket_parameter
{
    my ( $self, $session, $bucket, $parameter, $value ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Make sure that the bucket passed in actually exists

    if ( !defined( $self->{db_bucketid__}{$userid}{$bucket} ) ) {
        return undef;
    }

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
    my $btid     = $self->{db_parameterid__}{$parameter};

    # Exactly one row should be affected by this statement

    $self->{db_set_bucket_parameter__}->execute( $bucketid, $btid, $value );

    if ( defined( $self->{db_parameters__}{$userid}{$bucket}{$parameter} ) ) {
        $self->{db_parameters__}{$userid}{$bucket}{$parameter} = $value;
    }

    return 1;
}

#----------------------------------------------------------------------------
#
# set_user_parameter_from_id
#
# Sets the value associated with a user specific parameter
#
# $user        The ID of the user
# $parameter   The name of the parameter
# $value       The new value
#
#----------------------------------------------------------------------------
sub set_user_parameter_from_id
{
    my ( $self, $user, $parameter, $value ) = @_;

    # Prevent user 1 from stopping being an admin

    if ( ( $user == 1 ) &&
         ( $parameter eq 'GLOBAL_can_admin' ) &&
         ( $value != 1 ) ) {
        return 0;
    }

    my $utid = $self->{db_user_parameterid__}{$parameter};

    # Check to see if the parameter is being set to the default value
    # if it is then remove the entry because it is a waste of space

    my $default = 0;

    $self->{db_get_user_parameter_default__}->execute( $utid );
    my $result = $self->{db_get_user_parameter_default__}->fetchrow_arrayref;

    if ( $result->[0] eq $value ) {
        $default = 1;
        $self->db_()->do( "delete from user_params where userid = $user and utid = $utid;" );
    } else {
        $self->{db_set_user_parameter__}->execute( $user, $utid, $value );
    }

    if ( exists( $self->{cached_user_parameters__}{$user}{$parameter} ) ) {
        $self->{cached_user_parameters__}{$user}{$parameter}{lastused}= time;
        $self->{cached_user_parameters__}{$user}{$parameter}{value} = $value;
        $self->{cached_user_parameters__}{$user}{$parameter}{default}=$default;
    }

    return 1;
}

#----------------------------------------------------------------------------
#
# get_html_colored_message
#
# Parser a mail message stored in a file and returns HTML representing
# the message with coloring of the words
#
# $session        A valid session key returned by a call to get_session_key
# $file           The file to parse
#
#----------------------------------------------------------------------------
sub get_html_colored_message
{
    my ( $self, $session, $file ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $self->{parser__}->{color__} = $session;
    $self->{parser__}->{color_matrix__} = undef;
    $self->{parser__}->{color_idmap__}  = undef;
    $self->{parser__}->{color_userid__} = undef;
    $self->{parser__}->{bayes__} = bless $self;

    my $result = $self->{parser__}->parse_file( $file,   # PROFILE BLOCK START
           $self->global_config_( 'message_cutoff'   ) ); # PROFILE BLOCK STOP

    $self->{parser__}->{color__} = '';

    return $result;
}

#----------------------------------------------------------------------------
#
# fast_get_html_colored_message
#
# Parser a mail message stored in a file and returns HTML representing
# the message with coloring of the words
#
# $session        A valid session key returned by a call to get_session_key
# $file           The file to colorize
# $matrix         Reference to the matrix hash from a call to classify
# $idmap          Reference to the idmap hash from a call to classify
#
#----------------------------------------------------------------------------
sub fast_get_html_colored_message
{
    my ( $self, $session, $file, $matrix, $idmap ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $self->{parser__}->{color__}        = $session;
    $self->{parser__}->{color_matrix__} = $matrix;
    $self->{parser__}->{color_idmap__}  = $idmap;
    $self->{parser__}->{color_userid__} = $userid;
    $self->{parser__}->{bayes__}        = bless $self;

    my $result = $self->{parser__}->parse_file( $file,
                                                $self->global_config_( 'message_cutoff'   ) );

    $self->{parser__}->{color__} = '';

    return $result;
}

#----------------------------------------------------------------------------
#
# create_bucket
#
# Creates a new bucket, returns 1 if the creation succeeded
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      Name for the new bucket
#
#----------------------------------------------------------------------------
sub create_bucket
{
    my ( $self, $session, $bucket ) = @_;

    if ( $self->is_bucket( $session, $bucket ) ||           # PROFILE BLOCK START
         $self->is_pseudo_bucket( $session, $bucket ) ) {   # PROFILE BLOCK STOP
        return 0;
    }

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $bucket = $self->db_()->quote( $bucket );

    $self->db_()->do(                                                                    # PROFILE BLOCK START
        "insert into buckets ( name, pseudo, userid ) values ( $bucket, 0, $userid );" ); # PROFILE BLOCK STOP
    $self->db_update_cache__( $session );

    return 1;
}

#----------------------------------------------------------------------------
#
# delete_bucket
#
# Deletes a bucket, returns 1 if the delete succeeded
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      Name of the bucket to delete
#
#----------------------------------------------------------------------------
sub delete_bucket
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Make sure that the bucket passed in actually exists

    if ( !defined( $self->{db_bucketid__}{$userid}{$bucket} ) ) {
        return 0;
    }

    $self->db_()->do(                                                                        # PROFILE BLOCK START
        "delete from buckets where buckets.userid = $userid and buckets.name = '$bucket';" ); # PROFILE BLOCK STOP
    $self->db_update_cache__( $session );

    return 1;
}

#----------------------------------------------------------------------------
#
# rename_bucket
#
# Renames a bucket, returns 1 if the rename succeeded
#
# $session             A valid session key returned by a call to get_session_key
# $old_bucket          The old name of the bucket
# $new_bucket          The new name of the bucket
#
#----------------------------------------------------------------------------
sub rename_bucket
{
    my ( $self, $session, $old_bucket, $new_bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Make sure that the bucket passed in actually exists

    if ( !defined( $self->{db_bucketid__}{$userid}{$old_bucket} ) ) {
        $self->log_( 0, "Bad bucket name $old_bucket to rename_bucket" );
        return 0;
    }

    my $id = $self->db_()->quote( $self->{db_bucketid__}{$userid}{$old_bucket}{id} );
    $new_bucket = $self->db_()->quote( $new_bucket );

    $self->log_( 1, "Rename bucket $old_bucket to $new_bucket" );

    my $result = $self->db_()->do( "update buckets set name = $new_bucket where id = $id;" );

    if ( !defined( $result ) || ( $result == -1 ) ) {
        return 0;
    } else {
        $self->db_update_cache__( $session );
        return 1;
    }
}

#----------------------------------------------------------------------------
#
# add_messages_to_bucket
#
# Parses mail messages and updates the statistics in the specified bucket
#
# $session         A valid session key returned by a call to get_session_key
# $bucket          Name of the bucket to be updated
# @files           List of file names to parse
#
#----------------------------------------------------------------------------
sub add_messages_to_bucket
{
    my ( $self, $session, $bucket, @files ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    if ( !defined( $self->{db_bucketid__}{$userid}{$bucket}{id} ) ) {
        return 0;
    }

    # This is done to clear out the word list because in the loop
    # below we are going to not reset the word list on each parse

    $self->{parser__}->start_parse();
    $self->{parser__}->stop_parse();

    foreach my $file (@files) {
        $self->{parser__}->parse_file( $file,  # PROFILE BLOCK START
            $self->global_config_( 'message_cutoff'   ),
            0 );  # PROFILE BLOCK STOP (Do not reset word list)
    }

    $self->add_words_to_bucket__( $session, $bucket, 1 );
    $self->db_update_cache__( $session );

    return 1;
}

#----------------------------------------------------------------------------
#
# add_message_to_bucket
#
# Parses a mail message and updates the statistics in the specified bucket
#
# $session         A valid session key returned by a call to get_session_key
# $bucket          Name of the bucket to be updated
# $file            Name of file containing mail message to parse
#
#----------------------------------------------------------------------------
sub add_message_to_bucket
{
    my ( $self, $session, $bucket, $file ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    return $self->add_messages_to_bucket( $session, $bucket, $file );
}

#----------------------------------------------------------------------------
#
# remove_message_from_bucket
#
# Parses a mail message and updates the statistics in the specified bucket
#
# $session         A valid session key returned by a call to get_session_key
# $bucket          Name of the bucket to be updated
# $file            Name of file containing mail message to parse
#
#----------------------------------------------------------------------------
sub remove_message_from_bucket
{
    my ( $self, $session, $bucket, $file ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    $self->{parser__}->parse_file( $file,               # PROFILE BLOCK START
         $self->global_config_( 'message_cutoff'   ) ); # PROFILE BLOCK STOP
    $self->add_words_to_bucket__( $session, $bucket, -1 );

    $self->db_update_cache__( $session );

    return 1;
}

#----------------------------------------------------------------------------
#
# get_buckets_with_magnets
#
# Returns the names of the buckets for which magnets are defined
#
# $session     A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub get_buckets_with_magnets
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my @result;

    $self->{db_get_buckets_with_magnets__}->execute( $userid );
    while ( my $row = $self->{db_get_buckets_with_magnets__}->fetchrow_arrayref ) {
        push @result, ($row->[0]);
    }

    return @result;
}

#----------------------------------------------------------------------------
#
# get_magnet_types_in_bucket
#
# Returns the types of the magnets in a specific bucket
#
# $session     A valid session key returned by a call to get_session_key
# $bucket      The bucket to search for magnets
#
#----------------------------------------------------------------------------
sub get_magnet_types_in_bucket
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my @result;

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
    my $h = $self->db_()->prepare( "select magnet_types.mtype from magnet_types, magnets, buckets
        where magnet_types.id = magnets.mtid and
              magnets.bucketid = buckets.id and
              buckets.id = $bucketid
              group by magnet_types.mtype
              order by magnet_types.mtype;" );

    $h->execute;
    while ( my $row = $h->fetchrow_arrayref ) {
        push @result, ($row->[0]);
    }
    $h->finish;

    return @result;
}

#----------------------------------------------------------------------------
#
# clear_bucket
#
# Removes all words from a bucket
#
# $session        A valid session key returned by a call to get_session_key
# $bucket         The bucket to clear
#
#----------------------------------------------------------------------------
sub clear_bucket
{
    my ( $self, $session, $bucket ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};

    $self->db_()->do( "delete from matrix where matrix.bucketid = $bucketid;" );
    $self->db_update_cache__( $session );
}

#----------------------------------------------------------------------------
#
# clear_magnets
#
# Removes every magnet currently defined
#
# $session     A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub clear_magnets
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    for my $bucket (keys %{$self->{db_bucketid__}{$userid}}) {
        my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
        $self->db_()->do( "delete from magnets where magnets.bucketid = $bucketid" );
    }
}

#----------------------------------------------------------------------------
#
# get_magnets
#
# Returns the magnets of a certain type in a bucket
#
# $session         A valid session key returned by a call to get_session_key
# $bucket          The bucket to search for magnets
# $type            The magnet type (e.g. from, to or subject)
#
#----------------------------------------------------------------------------
sub get_magnets
{
    my ( $self, $session, $bucket, $type ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my @result;

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
    my $h = $self->db_()->prepare( "select magnets.val from magnets, magnet_types
        where magnets.bucketid = $bucketid and
              magnets.id != 0 and
              magnet_types.id = magnets.mtid and
              magnet_types.mtype = '$type' order by magnets.val;" );

    $h->execute;
    while ( my $row = $h->fetchrow_arrayref ) {
        push @result, ($row->[0]);
    }
    $h->finish;

    return @result;
}

#----------------------------------------------------------------------------
#
# create_magnet
#
# Make a new magnet
#
# $session         A valid session key returned by a call to get_session_key
# $bucket          The bucket the magnet belongs in
# $type            The magnet type (e.g. from, to or subject)
# $text            The text of the magnet
#
#----------------------------------------------------------------------------
sub create_magnet
{
    my ( $self, $session, $bucket, $type, $text ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
    my $result = $self->db_()->selectrow_arrayref("select magnet_types.id from magnet_types
                                                        where magnet_types.mtype = '$type';" );

    my $mtid = $result->[0];

    $text = $self->db_()->quote( $text );

    $self->db_()->do( "insert into magnets ( bucketid, mtid, val )
                                     values ( $bucketid, $mtid, $text );" );
}

#----------------------------------------------------------------------------
#
# get_magnet_types
#
# Get a hash mapping magnet types (e.g. from) to magnet names (e.g. From);
#
# $session     A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub get_magnet_types
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my %result;

    my $h = $self->db_()->prepare( "select magnet_types.mtype, magnet_types.header from magnet_types order by mtype;" );

    $h->execute;
    while ( my $row = $h->fetchrow_arrayref ) {
        $result{$row->[0]} = $row->[1];
    }
    $h->finish;

    return %result;
}

#----------------------------------------------------------------------------
#
# delete_magnet
#
# Remove a new magnet
#
# $session         A valid session key returned by a call to get_session_key
# $bucket          The bucket the magnet belongs in
# $type            The magnet type (e.g. from, to or subject)
# $text            The text of the magnet
#
#----------------------------------------------------------------------------
sub delete_magnet
{
    my ( $self, $session, $bucket, $type, $text ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my $bucketid = $self->{db_bucketid__}{$userid}{$bucket}{id};
    my $result = $self->db_()->selectrow_arrayref("select magnet_types.id from magnet_types
                                                        where magnet_types.mtype = '$type';" );

    my $mtid = $result->[0];
    $text = $self->db_()->quote( $text );

    $self->db_()->do( "delete from magnets
                            where magnets.bucketid = $bucketid and
                                  magnets.mtid = $mtid and
                                  magnets.val  = $text;" );
}

#----------------------------------------------------------------------------
#
# get_stopword_list
#
# Gets the complete list of stop words
#
# $session     A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub get_stopword_list
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    return $self->{parser__}->{mangle__}->stopwords();
}

#----------------------------------------------------------------------------
#
# magnet_count
#
# Gets the number of magnets that are defined
#
# $session     A valid session key returned by a call to get_session_key
#
#----------------------------------------------------------------------------
sub magnet_count
{
    my ( $self, $session ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    my $result = $self->db_()->selectrow_arrayref( "select count(*) from magnets, buckets
        where buckets.userid = $userid and
              magnets.id != 0 and
              magnets.bucketid = buckets.id;" );

    if ( defined( $result ) ) {
        return $result->[0];
    } else {
        return 0;
    }
}

#----------------------------------------------------------------------------
#
# add_stopword, remove_stopword
#
# Adds or removes a stop word
#
# $session     A valid session key returned by a call to get_session_key
# $stopword    The word to add or remove
#
# Return 0 for a bad stop word, and 1 otherwise
#
#----------------------------------------------------------------------------
sub add_stopword
{
    my ( $self, $session, $stopword ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Pass language parameter to add_stopword()

    return $self->{parser__}->{mangle__}->add_stopword( $stopword, $self->user_module_config_( 1, 'html', 'language' ) );
}

sub remove_stopword
{
    my ( $self, $session, $stopword ) = @_;

    my $userid = $self->valid_session_key__( $session );
    return undef if ( !defined( $userid ) );

    # Pass language parameter to remove_stopword()

    return $self->{parser__}->{mangle__}->remove_stopword( $stopword, $self->user_module_config_( 1, 'html', 'language' ) );
}

#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
# _____   _____   _____  _______ _____        _______   _______  _____  _____
#|_____] |     | |_____] |______   |   |      |______   |_____| |_____]   |
#|       |_____| |       |       __|__ |_____ |______   |     | |       __|__
#
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------

# GETTERS/SETTERS

sub wordscores
{
    my ( $self, $value ) = @_;

    $self->{wordscores__} = $value if (defined $value);
    return $self->{wordscores__};
}

sub wmformat
{
    my ( $self, $value ) = @_;

    $self->{wmformat__} = $value if (defined $value);
    return $self->{wmformat__};
}

1;

