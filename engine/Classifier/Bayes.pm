# POPFILE LOADABLE MODULE
package Classifier::Bayes;

use POPFile::Module;
@ISA = ("POPFile::Module");

# ---------------------------------------------------------------------------------------------
#
# Bayes.pm --- Naive Bayes text classifier
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
# ---------------------------------------------------------------------------------------------

use strict;
use warnings;
use locale;
use Classifier::MailParse;
use Classifier::WordMangle;

# This is used to get the hostname of the current machine
# in a cross platform way
use Sys::Hostname;

# A handy variable containing the value of an EOL for networks
my $eol = "\015\012";

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

    # Just our hostname
    $self->{hostname__}        = '';

    # Matrix of buckets, words and the word counts
    $self->{matrix__}            = {};

    # Total number of words in each bucket
    $self->{total__}             = {};

    # Total number of unique words in each bucket
    $self->{unique__}            = {};

    # Total number of words in all buckets
    $self->{full_total__}        = 0;

    # Used to mangle the corpus when loaded
    $self->{mangler__}           = new Classifier::WordMangle;

    # Used to parse mail messages
    $self->{parser__}            = new Classifier::MailParse;

    # Colors assigned to each bucket
    $self->{colors__}            = {};

    # The possible colors for buckets
    $self->{possible_colors__} = [ 'red',  'green',      'blue',      'brown',     'orange',     'purple',      'magenta',  'gray',        'plum',     'silver',
                   'pink', 'lightgreen', 'lightblue', 'lightcyan', 'lightcoral', 'lightsalmon', 'lightgrey', 'darkorange', 'darkcyan', 'feldspar' ];

    # Precomputed per bucket probabilities
    $self->{bucket_start__}      = {};

    # A very unlikely word
    $self->{not_likely__}        = 0;

    # The expected corpus version
    $self->{corpus_version__}    = 1;

    # Per bucket parameters
    $self->{parameters__}        = {};

    # The magnets that cause attraction to certain buckets
    $self->{magnets__}           = {};

    # The unclassified cutoff probability
    $self->{unclassified__}      = 0.5;

    # Used to tell the caller whether a magnet was used in the last
    # mail classification
    $self->{magnet_used__}       = 0;
    $self->{magnet_detail__}     = '';

    # Must call bless before attempting to call any methods

    bless $self, $type;

    $self->name( 'bayes' );

    return bless $self, $type;
}

# ---------------------------------------------------------------------------------------------
#
# initialize
#
# Called to set up the Bayes module's parameters
#
# ---------------------------------------------------------------------------------------------
sub initialize
{
    my ( $self ) = @_;

    # No default unclassified probability
    $self->config_( 'unclassified_probability', 0 );

    # The corpus is kept in the 'corpus' subfolder of POPFile
    $self->config_( 'corpus', 'corpus' );

    # Get the hostname for use in the X-POPFile-Link header
    $self->{hostname__} = hostname;

    return 1;
}

# ---------------------------------------------------------------------------------------------
#
# start
#
# Called to start the Bayes module running
#
# ---------------------------------------------------------------------------------------------
sub start
{
    my ( $self ) = @_;

    if ( $self->config_( 'unclassified_probability' ) != 0 )  {
        $self->{unclassified__} = $self->config_( 'unclassified_probability' );
    }

    $self->{unclassified__} = log($self->{unclassified__});

    $self->load_word_matrix_();

    return 1;
}

# ---------------------------------------------------------------------------------------------
#
# stop
#
# Called when POPFile is terminating
#
# ---------------------------------------------------------------------------------------------
sub stop
{
    my ( $self ) = @_;

    $self->write_parameters();
}

# ---------------------------------------------------------------------------------------------
#
# write_parameters
#
# Save the parameters hash
#
# ---------------------------------------------------------------------------------------------
sub write_parameters
{
    my ($self) = @_;

    for my $bucket (keys %{$self->{total__}})  {
        open PARAMS, '>' . $self->config_( 'corpus' ) . "/$bucket/params";
        for my $param (keys %{$self->{parameters__}{$bucket}}) {
            print PARAMS "$param $self->{parameters__}{$bucket}{$param}\n";
        }
        close PARAMS;
    }
}

# ---------------------------------------------------------------------------------------------
#
# get_color
#
# Retrieves the color for a specific word, color is the most likely bucket
#
# $word     Word to get the color of
#
# ---------------------------------------------------------------------------------------------
sub get_color
{
    my ($self, $word) = @_;

    my $max   = -10000;
    my $color = 'black';

    for my $bucket (keys %{$self->{total__}}) {
        my $prob = get_value_( $self, $bucket, $word);

        if ( $prob != 0 )  {
            if ( $prob > $max )  {
                $max   = $prob;
                $color = $self->{colors__}{$bucket};
            }
        }
    }

    return $color;
}

# ---------------------------------------------------------------------------------------------
#
# Perl hashes are a memory hog.  The original implementation was a Perl hash for the word
# matrix, but instead we use a a set of nested array and some regexps magic.
#
# The word paradise in the bucket spam will be found in the array element
#   matrix{spam}[p] with an entry of the form "|paradise 1234|".
#
# TODO: replace the word matrix hash with Berkeley DB tie
#
# ---------------------------------------------------------------------------------------------
sub get_value_
{
    my ($self, $bucket, $word) = @_;
    $word =~ /^(.)/;
    my $i = ord($1);

    if ( defined($self->{matrix__}{$bucket}[$i]) ) {
        if ( ( $self->{matrix__}{$bucket}[$i] =~ /\|\Q$word\E (\d+)\|/ ) != 0 )  {
            my $newvalue = log($1/$self->{total__}{$bucket});
            return $newvalue;
        }
    }

    return 0;
}

# ---------------------------------------------------------------------------------------------
#
# get_sort_value_ behaves the same as get_value_, except that it returns not_likely__ rather
# than 0 if the word is not found.  This makes its result more suitable as a sort key for bucket
# ranking.
#
# ---------------------------------------------------------------------------------------------
sub get_sort_value_
{
    my ($self, $bucket, $word) = @_;
    my $v = get_value_($self, $bucket, $word);
    return $self->{not_likely__} if $v == 0;
    return $v;
}

sub set_value_
{
    my ($self, $bucket, $word, $value) = @_;

    if ( $word ne '' ) {
        $word =~ /^(.)/;
        my $i = ord($1);        

        $self->{matrix__}{$bucket}[$i] = '' if ( !defined($self->{matrix__}{$bucket}[$i]) );
        $self->{matrix__}{$bucket}[$i] .= "|$word $value|" if ( ( $self->{matrix__}{$bucket}[$i] =~ s/\|\Q$word\E [\-\.\d]+\|/\|$word $value\|/ ) == 0 );        
    }
}

# ---------------------------------------------------------------------------------------------
#
# update_constants_
#
# Updates not_likely and bucket_start
#
# ---------------------------------------------------------------------------------------------
sub update_constants_
{
    my ($self) = @_;

    if ( $self->{full_total__} > 0 )  {

        # ln(10) =~ 2.30258509299404568401799145468436

        $self->{not_likely__} = -log( $self->{full_total__} ) - 2.30258509299404568401799145468436;

        foreach my $bucket (keys %{$self->{total__}}) {
            if ( $self->{total__}{$bucket} != 0 ) {
                $self->{bucket_start__}{$bucket} = log( $self->{total__}{$bucket} / $self->{full_total__} );
            } else {
                $self->{bucket_start__}{$bucket} = 0;
            }
        }
    }
}

# ---------------------------------------------------------------------------------------------
#
# load_word_matrix_
#
# Fills the matrix with the word frequencies from all buckets and builds the bucket total
#
# ---------------------------------------------------------------------------------------------
sub load_word_matrix_
{
    my ($self) = @_;
    my $c      = 0;

    $self->{matrix__}     = {};
    $self->{total__}      = {};
    $self->{magnets__}    = {};
    $self->{full_total__} = 0;

    my @buckets = glob $self->config_( 'corpus' ) . '/*';

    foreach my $bucket (@buckets) {
        my $color = '';

        # See if there's a color file specified
        if ( open COLOR, '<' . "$bucket/color" ) {
            $color = <COLOR>;

            # Someone (who shall remain nameless) went in an manually created
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
        }

        $self->load_bucket_( $bucket );
        $bucket =~ /([[:alpha:]0-9-_]+)$/;
        $bucket =  $1;
        $self->{full_total__} += $self->{total__}{$bucket};

        if ( $color eq '' )  {
            if ( $c <= $#{$self->{possible_colors__}} ) {
                $self->{colors__}{$bucket} = $self->{possible_colors__}[$c];
            } else {
                $self->{colors__}{$bucket} = 'black';
            }
        } else {
            $self->{colors__}{$bucket} = $color;
        }

        $c += 1;
    }

    $self->update_constants_();

    # unclassified will always have the color black, note that unclassified is not
    # actually a bucket

    $self->{colors__}{unclassified} = 'black';

    # SLM for unclassified "bucket" will always match the global setting

    $self->{parameters__}{unclassified}{subject} = $self->global_config_('subject');

    # Quarantine for unclassified will be off:

    $self->{parameters__}{unclassified}{quarantine} = 0;

}

# ---------------------------------------------------------------------------------------------
#
# load_bucket_
#
# Loads an individual bucket
#
# ---------------------------------------------------------------------------------------------

sub load_bucket_
{
    my ($self, $bucket) = @_;

    $bucket =~ /([[:alpha:]0-9-_]+)$/;
    $bucket =  $1;

    $self->{parameters__}{$bucket}{subject}    = 1;
    $self->{parameters__}{$bucket}{count}      = 0;
    $self->{parameters__}{$bucket}{quarantine} = 0;

    $self->{total__}{$bucket}  = 0;
    $self->{unique__}{$bucket} = 0;
    $self->{matrix__}{$bucket} = ();
    $self->{magnets__}{$bucket} = {};

    # See if there's a color file specified
    if ( open PARAMS, '<' . $self->config_( 'corpus' ) . "/$bucket/params" ) {
        while ( <PARAMS> )  {
            s/[\r\n]//g;
            if ( /^([[:lower:]]+) ([^\r\n\t ]+)$/ )  {
                $self->{parameters__}{$bucket}{$1} = $2;
            }
        }
        close PARAMS;
    } else {
        $self->write_parameters();        
    }

    # See if there are magnets defined
    if ( open MAGNETS, '<' . $self->config_( 'corpus' ) . "/$bucket/magnets" ) {
        while ( <MAGNETS> )  {
            s/[\r\n]//g;

            # Because of a bug in v0.17.9 and earlier of POPFile the text of
            # some magnets was getting mangled by certain characters having
            # a \ prepended.  Code here removes the \ in these cases to make
            # an upgrade smooth.

            if ( /^([^ ]+) (.+)$/ )  {
                my $type  = $1;
                my $value = $2;

                # Some people were accidently creating magnets with trailing whitespace
                # which really confused them later when their magnet did not match (see
                # comment in UI::HTML::magnet for more detail)

                $value =~ s/^[ \t]+//g;
                $value =~ s/[ \t]+$//g;

                $value =~ s/\\(\?|\*|\||\(|\)|\[|\]|\{|\}|\^|\$|\.)/$1/g;
                $self->{magnets__}{$bucket}{$type}{$value} = 1;
            } else {

                # This branch is used to catch the original magnets in an
                # old version of POPFile that were just there for from
                # addresses only

                if ( /^(.+)$/ ) {
                    my $value = $1;
                    $value =~ s/\\(\?|\*|\||\(|\)|\[|\]|\{|\}|\^|\$|\.)/$1/g;
                    $self->{magnets__}{$bucket}{from}{$1} = 1;
                }
            }
        }
        close MAGNETS;
    }

    # Each line in the word table is a word and a count
    $self->{total__}{$bucket} = 0;

    if ( open WORDS, '<' . $self->config_( 'corpus' ) . "/$bucket/table" )  {
        while (<WORDS>) {
            if ( /__CORPUS__ __VERSION__ (\d+)/ ) {
                if ( $1 != $self->{corpus_version__} )  {
                    print "Incompatible corpus version in $bucket\n";
                    return;
                }

                next;
            }

            if ( /([^\s]+) (\d+)/ ) {
                my $word  = $1;
                my $value = $2;
                $value =~ s/[\r\n]//g;
                if ( $value > 0 )  {
                    $self->{total__}{$bucket}        += $value;
                    $self->{unique__}{$bucket}       += 1;
                    set_value_( $self, $bucket, $word, $value );
                }
            }
        }

        close WORDS;
    }
}

# ---------------------------------------------------------------------------------------------
#
# save_magnets__
#
# Save all the magnet definitions
#
# ---------------------------------------------------------------------------------------------
sub save_magnets__
{
    my ($self) = @_;

    for my $bucket (keys %{$self->{total__}}) {
        open MAGNET, '>' . $self->config_( 'corpus' ). "/$bucket/magnets";

        for my $type (keys %{$self->{magnets__}{$bucket}})  {
            for my $from (keys %{$self->{magnets__}{$bucket}{$type}})  {
                print MAGNET "$type $from\n";
            }
        }

        close MAGNET;
    }
}

# ---------------------------------------------------------------------------------------------
#
# classify_file
#
# $file      The name of the file containing the text to classify
# $ui        Reference to the UI used when doing colorization
#
# Splits the mail message into valid words, then runs the Bayes algorithm to figure out
# which bucket it belongs in.  Returns the bucket name
#
# ---------------------------------------------------------------------------------------------
sub classify_file
{
    my ($self, $file, $ui) = @_;
    my $msg_total = 0;

    $self->{magnet_used__}   = 0;
    $self->{magnet_detail__} = 0;

    $self->{parser__}->parse_stream($file);

    # Check to see if this email should be classified based on a magnet
    # Get the list of buckets

    my @buckets = keys %{$self->{total__}};

    for my $bucket (sort keys %{$self->{magnets__}})  {
        for my $type (sort keys %{$self->{magnets__}{$bucket}}) {

        # You cannot use @ or $ inside a \Q\E regular expression and hence
        # we have to change the $magnet and the text we are comparing against
        # by changing the $ and @ signs to .

            my $noattype;

            $noattype = $self->{parser__}->get_header($type);
            $noattype =~ s/[@\$]/\./g;

        for my $magnet (sort keys %{$self->{magnets__}{$bucket}{$type}}) {
                my $regex;

                $regex = $magnet;
                $regex =~ s/[@\$]/\./g;

                if ( $noattype =~ m/\Q$regex\E/i ) {
                    $self->{scores__}        = "<b>Magnet Used</b><p>Classified to <font color=\"$self->{colors__}{$bucket}\">$bucket</font> because of magnet $type: " . Classifier::MailParse::splitline($magnet,0) . "</p>";
                    $self->{magnet_used__}   = 1;
                    $self->{magnet_detail__} = "$type: $magnet";

                    return $bucket;
                }
            }
        }
    }

    # If the user has not defined any buckets then we escape here return unclassified
    return "unclassified" if ( $#buckets == -1 );

    # The score hash will contain the likelihood that the given message is in each
    # bucket, the buckets are the keys for score

    # Set up the initial score as P(bucket)

    my %score;
    my %matchcount;

    for my $bucket (@buckets) {
        $score{$bucket} = $self->{bucket_start__}{$bucket};
        $matchcount{$bucket} = 0;
    }

    # For each word go through the buckets and calculate P(word|bucket) and then calculate
    # P(word|bucket) ^ word count and multiply to the score

    my $logbuck = 1;
    $logbuck = log( $#buckets + 1 ) if ( $#buckets > 0 );

    # Ideally, the "raw score" in the score display would reflect the sum of the
    # scores for the individual words, as shown by the lookup GUI.  Actually
    # doing this requires a fair amount of computation to compute the sum of the
    # probabilities.  If we assume that only the most probable choice is significant
    # (that is, that the max probability and the sum of the probabilities are the
    # same), we do much less computation, and still end up with results that are
    # "close enough for jazz".  Note that this makes *no* difference for
    # classification - it only matters for the debug (bayes.pl) display.

    my $correction = -$logbuck;

    # Switching from using *= to += and using the log of every probability instead

    foreach my $word (keys %{$self->{parser__}->{words__}}) {
        my $wmax = -10000;

        foreach my $bucket (@buckets) {
            my $probability = get_value_( $self, $bucket, $word );

            $matchcount{$bucket} += $self->{parser__}{words__}{$word} if ($probability != 0);
            $probability = $self->{not_likely__} if ( $probability == 0 );
            $wmax = $probability if ( $wmax < $probability );

            # Here we are doing the bayes calculation: P(word|bucket) is in probability
            # and we multiply by the number of times that the word occurs

            $score{$bucket} += ( $probability * $self->{parser__}{words__}{$word} );
        }

        if ($wmax > $self->{not_likely__}) {
            $correction += ($wmax - $logbuck) * $self->{parser__}{words__}{$word};
        } else {
            $correction += $wmax * $self->{parser__}{words__}{$word};
        }
    }

    # Now sort the scores to find the highest and return that bucket as the classification

    my @ranking = sort {$score{$b} <=> $score{$a}} keys %score;

    my %raw_score;
    my $base_score = $score{$ranking[0]};
    my $total = 0;

    # Compute the total of all the scores to generate the normalized scores and probability
    # estimate.  $total is always 1 after the first loop iteration, so any additional term
    # less than 2 ** -54 is insignificant, and need not be computed.

    my $ln2 = log(2);

    foreach my $b (@ranking) {
        $raw_score{$b} = $score{$b};
        $score{$b} -= $base_score;

        $total += exp($score{$b}) if ($score{$b} > ( -54 * $ln2 ) );
    }

    if ($self->{wordscores__} && defined($ui) ) {
        my %qm = %{$self->{parser__}->quickmagnets()};
        my $mlen = scalar(keys %{$self->{parser__}->quickmagnets()});
        my %language    = $ui->language();
        my $session_key = $ui->session_key();

        if ( $mlen >= 0 ) {
            my @buckets = $self->get_buckets();
            my $i = 0;
            $self->{scores__} .= "<form action=\"/magnets\" method=\"get\">\n";
            $self->{scores__} .= "<input type=\"hidden\" name=\"session\" value=\"$session_key\" />";
            $self->{scores__} .= "<input type=\"hidden\" name=\"count\" value=\"" . ($mlen + 1) . "\" />";
            $self->{scores__} .= "<hr><b>$language{QuickMagnets}</b><p>\n<table class=\"top20Words\">\n<tr>\n<th scope=\"col\">$language{Magnet}</th>\n<th>$language{Magnet_Always}</th>\n";
            
            my %types = get_magnet_types();
           
            foreach my $type ( keys %types ) {

                if (defined $qm{$type})
                {
                    $i += 1;
    
                    
                    $self->{scores__} .= "<tr><td scope=\"col\">$type: ";
                    $self->{scores__} .= "<select name=\"text$i\" id=\"\">\n";
                    
                    foreach my $magnet ( 0 .. $#{$qm{$type}} ) {
                        $self->{scores__} .= "<option>" . Classifier::MailParse::splitline(@{$qm{$type}}[$magnet], 0) . "</option>\n";
                    }
                    $self->{scores__} .= "</select>\n";                
                    $self->{scores__} .= "</td><td>";
                    $self->{scores__} .= "<input type=\"hidden\" name=\"type$i\" id=\"magnetsAddType\" value=\"$type\"/>";                
                    $self->{scores__} .= "<select name=\"bucket$i\" id=\"magnetsAddBucket\">\n<option value=\"\"></option>\n";
    
                    foreach my $bucket (@buckets) {
                        $self->{scores__} .= "<option value=\"$bucket\">$bucket</option>\n";
                    }
    
                    $self->{scores__} .= "</select></td></tr>";
                }                
	    }

            $self->{scores__} .= "<tr><td></td><td><input type=\"submit\" class=\"submit\" name=\"create\" value=\"$language{Create}\" /></td></tr></table></form>";
	}

        $self->{scores__} .= "<hr><b>$language{Scores}</b><p>\n<table class=\"top20Words\">\n<tr>\n<th scope=\"col\">$language{Bucket}</th>\n<th>&nbsp;</th>\n";
        $self->{scores__} .= "<th scope=\"col\">$language{Count}&nbsp;&nbsp;</th><th scope=\"col\">$language{Probability}</th></tr>\n";

        foreach my $b (@ranking) {
             my $prob = exp($score{$b})/$total;
             my $probstr;

            if ($prob >= 0.1 || $prob == 0.0) {
                 $probstr = sprintf("%12.6f", $prob);
             } else {
                $probstr = sprintf("%17.6e", $prob);
             }

             $self->{scores__} .= "<tr>\n<td><font color=\"$self->{colors__}{$b}\"><b>$b</b></font></td>\n<td>&nbsp;</td>\n<td align=\"right\">$matchcount{$b}&nbsp;&nbsp;&nbsp;&nbsp;</td>\n<td>$probstr</td>\n</tr>\n";
        }

        $self->{scores__} .= "</table><hr>";
        $self->{scores__} .= "<table class=\"top20Words\">\n";
        $self->{scores__} .= "<tr>\n<th scope=\"col\">$language{Word}</th><th>&nbsp;</th><th scope=\"col\">$language{Count}</th><th>&nbsp;</th>\n";

        foreach my $ix (0..($#buckets > 7? 7: $#buckets)) {
            my $bucket = $ranking[$ix];
            my $bucketcolor  = $self->get_bucket_color( $bucket );
            $self->{scores__} .= "<th><font color=\"$bucketcolor\">$bucket</font></th><th>&nbsp;</th>";
        }

        $self->{scores__} .= "</tr>";

        my @ranked_words = sort {$self->get_sort_value_( $ranking[0], $b ) <=> $self->get_sort_value_( $ranking[0], $a )} keys %{$self->{parser__}->{words__}};

        foreach my $word (@ranked_words) {
            my $known = 0;

            foreach my $bucket (@ranking) {
                if ( $self->get_value_( $bucket, $word ) != 0 ) {
                   $known = 1;
                   last;
                }
            }

            if ( $known == 1 ) {
                my $wordcolor = $self->get_color( $word );
                my $count     = $self->{parser__}->{words__}{$word};

                $self->{scores__} .= "<tr>\n<td><font color=\"$wordcolor\">$word</font></td><td>&nbsp;</td><td>$count</td><td>&nbsp;</td>\n";

                my $base_probability = $self->get_value_( $ranking[0], $word );

                foreach my $ix (0..($#buckets > 7? 7: $#buckets)) {
                    my $bucket = $ranking[$ix];
                    my $probability  = get_value_( $self, $bucket, $word );
                    my $color        = 'black';

                    if ( $probability >= $base_probability || $base_probability == 0 ) {
                        $color = $self->get_bucket_color( $bucket );
                    }

                    if ( $probability != 0 ) {
                        my $wordprobstr  = sprintf("%12.4f", exp($probability) );

                        $self->{scores__} .= "<td><font color=\"$color\">$wordprobstr</font></td>\n<td>&nbsp;</td>\n";
                    } else {
                        $self->{scores__} .= "<td>&nbsp;</td>\n<td>&nbsp;</td>\n";
                    }
                }
            }

            $self->{scores__} .= "</tr>";
        }

        $self->{scores__} .= "</table></p>";
    }

    # If no bucket has a probability better than 0.5, call the message "unclassified".
    my $class = 'unclassified';

    if ( ( $total != 0 ) && ( $score{$ranking[0]} > $self->{unclassified__} + log($total) ) ) {
        $class = $ranking[0];
    }

    return $class;
}

# ---------------------------------------------------------------------------------------------
#
# classify_and_modify
#
# This method reads an email terminated by . on a line by itself (or the end of stream)
# from a handle and creates an entry in the history, outputting the same email on another
# handle with the appropriate header modifications and insertions
#
# $mail     - an open stream to read the email from
# $client   - an open stream to write the modified email to
# $dcount   - the unique download count for this message
# $mcount   - the message count for this message
# $nosave   - indicates that the message downloaded should not be saved in the history
# $class    - if we already know the classification
# $echo     - 1 to echo to the client, 0 to supress, defaults to 1
#
# Returns a classification if it worked, otherwise returns an empty string
#
# ---------------------------------------------------------------------------------------------
sub classify_and_modify
{
    my ( $self, $mail, $client, $dcount, $mcount, $nosave, $class, $echo ) = @_;
    
    $echo = 1 unless (defined $echo);

    my $msg_subject     = '';     # The message subject
    my $msg_head_before = '';     # Store the message headers that come before Subject here
    my $msg_head_after  = '';     # Store the message headers that come after Subject here
    my $msg_body        = '';     # Store the message body here

    # These two variables are used to control the insertion of the X-POPFile-TimeoutPrevention
    # header when downloading long or slow emails
    my $last_timeout   = time;
    my $timeout_count  = 0;

    # Indicates whether the first time through the receive loop we got the full body, this
    # will happen on small emails
    my $got_full_body  = 0;

    # The size of the message downloaded so far.
    my $message_size   = 0;

    # The classification for this message
    my $classification = '';

    # Whether we are currently reading the mail headers or not
    my $getting_headers = 1;

    my $temp_file  = $self->global_config_( 'msgdir' ) . "popfile$dcount" . "=$mcount.msg";
    my $class_file = $self->global_config_( 'msgdir' ) . "popfile$dcount" . "=$mcount.cls";

    open TEMP, ">$temp_file";

    while ( <$mail> ) {
        my $line;
        my $fileline;

        $line = $_;

        # This is done so that we remove the network style end of line CR LF
        # and allow Perl to decide on the local system EOL which it will expand
        # out of \n when this gets written to the temp file

        $fileline = $line;
        $fileline =~ s/[\r\n]//g;
        $fileline .= "\n";

        # Check for an abort

        last if ( $self->{alive_} == 0 );

        # The termination of a message is a line consisting of exactly .CRLF so we detect that
        # here exactly

        if ( $line =~ /^\.(\r\n|\r|\n)$/ ) {
            $got_full_body = 1;
            last;
        }

        if ( $getting_headers )  {

            # Kill header lines containing only whitespace (Exim does this)

            next if ( $line =~ /^[ \t]+(\r\n|\r|\n)$/i );

            if ( !( $line =~ /^(\r\n|\r|\n)$/i ) )  {
                $message_size += length $line;
                print TEMP $fileline;
                
                # If there is no echoing occuring, it doesn't matter what we do to these
                
                if ($echo) {
    
                    if ( $line =~ /^Subject:(.*)/i )  {
                        $msg_subject = $1;
                        $msg_subject =~ s/(\012|\015)//g;
                        next;
                    }
    
                    # Strip out the X-Text-Classification header that is in an incoming message
                    if ( ( $line =~ /^X-Text-Classification:/i ) == 0 ) {
                        if ( $msg_subject eq '' )  {
                            $msg_head_before .= $line;
                        } else {
                            $msg_head_after  .= $line;
                        }
                    }
                }
            } else {
                print TEMP "\n";
                $message_size += length $eol;
                $getting_headers = 0;
            }
        } else {
            $message_size += length $line;
            $msg_body     .= $line;
            print TEMP $fileline;
        }

        # Check to see if too much time has passed and we need to keep the mail client happy
        if ( time > ( $last_timeout + 2 ) ) {
            print $client "X-POPFile-TimeoutPrevention: $timeout_count$eol" if ( $echo );
            $timeout_count += 1;
            $last_timeout = time;
        }

        last if ( ( $message_size > 100000 ) && ( $getting_headers == 0 ) );
    }

    close TEMP;

    # Do the text classification and update the counter for that bucket that we just downloaded
    # an email of that type
    $classification = ($class ne '')?$class:$self->classify_file($temp_file);

    # Add the Subject line modification or the original line back again
    if ( $classification ne 'unclassified' ) {
        if ( $self->global_config_( 'subject' ) ) {
            # Don't add the classification unless it is not present
            if ( !( $msg_subject =~ /\[\Q$classification\E\]/ ) &&
                 ( $self->{parameters__}{$classification}{subject} == 1 ) &&
                 ( $self->{parameters__}{$classification}{quarantine} == 0 ) )  {
                $msg_subject = " [$classification]$msg_subject";
            }
        }
    }

    $msg_head_before .= 'Subject:' . $msg_subject;
    $msg_head_before .= $eol;

    if ( $nosave ) {
        unlink( $temp_file );
    }

    # Add the XTC header
    $msg_head_after .= "X-Text-Classification: $classification$eol" if ( ( $self->global_config_( 'xtc' ) ) &&
                                                                         ( $self->{parameters__}{$classification}{quarantine} == 0 ) );

    # Add the XPL header
    $temp_file =~ s/.*\/([^\/]+)/$1/;

    my $xpl = '';

    $xpl .= "<http://";
    $xpl .= $self->module_config_( 'html', 'local' )?"127.0.0.1":$self->{hostname__};
    $xpl .= ":" . $self->module_config_( 'html', 'port' ) . "/jump_to_message?view=$temp_file>$eol";

    if ( $self->global_config_( 'xpl' ) && ( $self->{parameters__}{$classification}{quarantine} == 0 ) ) {
        $msg_head_after .= 'X-POPFile-Link: ' . $xpl;
    }

    $msg_head_after .= "$eol";

    # Echo the text of the message to the client

    if ( $echo ) {

        # If the bucket is quarantined then we'll treat it specially by changing the message header to contain
        # information from POPFile and wrapping the original message in a MIME encoding

        if ( $classification ne 'unclassified' ) {
            if ( $self->{parameters__}{$classification}{quarantine} == 1 ) {
                print $client "From: " . $self->{parser__}->get_header( 'from' ) . "$eol";
                print $client "To: " . $self->{parser__}->get_header( 'to' ) . "$eol";
                print $client "Date: " . $self->{parser__}->get_header( 'date' ) . "$eol";
                if ( $self->global_config_( 'subject' ) ) {
                    # Don't add the classification unless it is not present
                    if ( !( $msg_subject =~ /\[\Q$classification\E\]/ ) &&
                         ( $self->{parameters__}{$classification}{subject} == 1 ) ) {
                        $msg_subject = " [$classification]$msg_subject";
                    }
                }
                print $client "Subject:$msg_subject$eol";
                print $client "X-Text-Classification: $classification$eol" if ( $self->global_config_( 'xtc' ) );
                print $client 'X-POPFile-Link: ' . $xpl if ( $self->global_config_( 'xpl' ) );
                print $client "MIME-Version: 1.0$eol";
                print $client "Content-Type: multipart/report; boundary=\"$temp_file\"$eol$eol--$temp_file$eol";
                print $client "Content-Type: text/plain$eol$eol";
                print $client "POPFile has quarantined a message.  It is attached to this email.$eol$eol";
                print $client "Quarantined Message Detail$eol$eol";
                print $client "Original From: " . $self->{parser__}->get_header('from') . "$eol";
                print $client "Original To: " . $self->{parser__}->get_header('to') . "$eol";
                print $client "Original Subject: " . $self->{parser__}->get_header('subject') . "$eol";
                print $client "To examine the email open the attachment. To change this mail's classification go to $xpl$eol";
                print $client "The first 20 words found in the email are:$eol$eol";
                print $client $self->{parser__}->first20();
                print $client "$eol--$temp_file$eol";
                print $client "Content-Type: message/rfc822$eol$eol";
            }
        }

        print $client $msg_head_before;
        print $client $msg_head_after;
        print $client $msg_body;
    }

    if ( $got_full_body == 0 )    {
        $self->echo_to_dot_( $mail, $client ) if ( $echo );
    } else {
        if ( $classification ne 'unclassified' ) {
            if ( ( $self->{parameters__}{$classification}{quarantine} == 1 ) && $echo ) {
                print $client "$eol--$temp_file$eol";
	        }
        }

        print $client ".$eol" if ( $echo );
    }

    if ( !$nosave ) {
        open CLASS, ">$class_file";
        if ( $self->{magnet_used__} == 0 )  {
            print CLASS "$classification\n";
        } else {
            print CLASS "$classification MAGNET $self->{magnet_detail__}\n";
        }
        close CLASS;
    }

    return $classification;
}

# ---------------------------------------------------------------------------------------------
#
# get_buckets
#
# Returns a list containing all the bucket names sorted into alphabetic order
#
# ---------------------------------------------------------------------------------------------

sub get_buckets
{
    my ( $self ) = @_;

    return sort keys %{$self->{total__}};
}

# ---------------------------------------------------------------------------------------------
#
# get_bucket_word_count
#
# Returns the total word count (including duplicates) for the passed in bucket
#
# $bucket      The name of the bucket for which the word count is desired
#
# ---------------------------------------------------------------------------------------------

sub get_bucket_word_count
{
    my ( $self, $bucket ) = @_;

    return $self->{total__}{$bucket};
}

# ---------------------------------------------------------------------------------------------
#
# get_bucket_word_list
#
# Returns a list of bucket entries, each entry corresponds to all the words with the
# same leading character
#
# $bucket      The name of the bucket for which the word count is desired
#
# ---------------------------------------------------------------------------------------------

sub get_bucket_word_list
{
    my ( $self, $bucket ) = @_;

    if ( $self->get_bucket_word_count( $bucket ) > 0 ) {
        return $self->{matrix__}{$bucket};
    } else {
        return ();
    }
}

# ---------------------------------------------------------------------------------------------
#
# get_word_count
#
# Returns the total word count (including duplicates)
#
# ---------------------------------------------------------------------------------------------

sub get_word_count
{
    my ( $self ) = @_;

    return $self->{full_total__};
}

# ---------------------------------------------------------------------------------------------
#
# get_bucket_unique_count
#
# Returns the unique word count (excluding duplicates) for the passed in bucket
#
# $bucket      The name of the bucket for which the word count is desired
#
# ---------------------------------------------------------------------------------------------

sub get_bucket_unique_count
{
    my ( $self, $bucket ) = @_;

    return $self->{unique__}{$bucket};
}

# ---------------------------------------------------------------------------------------------
#
# get_bucket_color
#
# Returns the color associated with a bucket
#
# $bucket      The name of the bucket for which the color is requested
#
# ---------------------------------------------------------------------------------------------

sub get_bucket_color
{
    my ( $self, $bucket ) = @_;

    return $self->{colors__}{$bucket};
}

# ---------------------------------------------------------------------------------------------
#
# set_bucket_color
#
# Returns the color associated with a bucket
#
# $bucket      The name of the bucket for which the color is requested
# $color       The new color
#
# ---------------------------------------------------------------------------------------------

sub set_bucket_color
{
    my ( $self, $bucket, $color ) = @_;

    $self->{colors__}{$bucket} = $color;
}

# ---------------------------------------------------------------------------------------------
#
# get_bucket_parameter
#
# Returns the value of a per bucket parameter
#
# $bucket      The name of the bucket
# $parameter   The name of the parameter
#
# ---------------------------------------------------------------------------------------------

sub get_bucket_parameter
{
    my ( $self, $bucket, $parameter ) = @_;

    my $param = $self->{parameters__}{$bucket}{$parameter};

    if ( !defined( $param ) ) {
        $param = 0;
    }

    return $param;
}

# ---------------------------------------------------------------------------------------------
#
# set_bucket_parameter
#
# Sets the value associated with a bucket specific parameter
#
# $bucket      The name of the bucket
# $parameter   The name of the parameter
# $value       The new value
#
# ---------------------------------------------------------------------------------------------

sub set_bucket_parameter
{
    my ( $self, $bucket, $parameter, $value ) = @_;

    $self->{parameters__}{$bucket}{$parameter} = $value;
    $self->write_parameters();
}

# ---------------------------------------------------------------------------------------------
#
# get_html_colored_message
#
# Parser a mail message stored in a file and returns HTML representing the message
# with coloring of the words
#
# $file           The file to parse
#
# ---------------------------------------------------------------------------------------------

sub get_html_colored_message
{
    my ( $self, $file ) = @_;

    $self->{parser__}->{color__} = 1;
    $self->{parser__}->{bayes__} = bless $self;
    my $result = $self->{parser__}->parse_stream($file);
    $self->{parser__}->{color__} = 0;
    $self->{parser__}->{words__} = {};

    return $result;
}

# ---------------------------------------------------------------------------------------------
#
# create_bucket
#
# Creates a new bucket
#
# $bucket          Name for the new bucket
#
# ---------------------------------------------------------------------------------------------

sub create_bucket
{
    my ( $self, $bucket ) = @_;

    mkdir( $self->config_( 'corpus' ) );
    mkdir( $self->config_( 'corpus' ) . "/$bucket" );

    if ( open NEW, '>' . $self->config_( 'corpus' ) . "/$bucket/table" ) {
        print NEW "\n";
        close NEW;
    }

    $self->load_word_matrix_();
}

# ---------------------------------------------------------------------------------------------
#
# delete_bucket
#
# Deletes a bucket
#
# $bucket          Name of the bucket to delete
#
# ---------------------------------------------------------------------------------------------

sub delete_bucket
{
    my ( $self, $bucket ) = @_;

    my $bucket_directory = $self->config_( 'corpus' ) . "/$bucket";

    unlink( "$bucket_directory/table" );
    unlink( "$bucket_directory/color" );
    unlink( "$bucket_directory/params" );
    unlink( "$bucket_directory/magnets" );
    rmdir( $bucket_directory );

    $self->load_word_matrix_();
}

# ---------------------------------------------------------------------------------------------
#
# rename_bucket
#
# Renames a bucket
#
# $old_bucket          The old name of the bucket
# $new_bucket          The new name of the bucket
#
# ---------------------------------------------------------------------------------------------

sub rename_bucket
{
    my ( $self, $old_bucket, $new_bucket ) = @_;

    rename($self->config_( 'corpus' ) . "/$old_bucket" , $self->config_( 'corpus' ) . "/$new_bucket");

    $self->load_word_matrix_();
}

# ---------------------------------------------------------------------------------------------
#
# add_message_to_bucket
#
# Parses a mail message and updates the statistics in the specified bucket
#
# $file            Name of file containing mail message to parse
# $bucket          Name of the bucket to be updated
#
# ---------------------------------------------------------------------------------------------

sub add_message_to_bucket
{
    my ( $self, $file, $bucket ) = @_;

    my %words;

    if ( open WORDS, '<' . $self->config_( 'corpus' ) . "/$bucket/table" )  {
        while (<WORDS>) {
            if ( /__CORPUS__ __VERSION__ (\d+)/ ) {
                if ( $1 != $self->{corpus_version__} )  {
                    print "Incompatible corpus version in $bucket\n";
                    return;
                }

                next;
            }

            if ( /([^\s]+) (\d+)/ ) {
                my $word = $self->{mangler__}->mangle($1,1);
                my $value = $2;
                $value =~ s/[\r\n]//g;
                if ( $value > 0 )  {
                    $words{$word} = $value;
                }
            }
        }

        close WORDS;
    }

    $self->{parser__}->parse_stream( $file );

    foreach my $word (keys %{$self->{parser__}->{words__}}) {
        $words{$word} += $self->{parser__}->{words__}{$word};
    }

    if ( open WORDS, '>' . $self->config_( 'corpus' ) . "/$bucket/table" ) {
        print WORDS "__CORPUS__ __VERSION__ 1\n";
        foreach my $word (sort keys %words) {
            print WORDS "$word $words{$word}\n";
        }
        close WORDS;
    }

    $self->load_word_matrix_();
}

# ---------------------------------------------------------------------------------------------
#
# remove_message_from_bucket
#
# Parses a mail message and updates the statistics in the specified bucket
#
# $file            Name of file containing mail message to parse
# $bucket          Name of the bucket to be updated
#
# ---------------------------------------------------------------------------------------------

sub remove_message_from_bucket
{
    my ( $self, $file, $bucket ) = @_;

    my %words;

    if ( open WORDS, '<' . $self->config_( 'corpus' ) . "/$bucket/table" )  {
        while (<WORDS>) {
            if ( /__CORPUS__ __VERSION__ (\d+)/ ) {
                if ( $1 != $self->{corpus_version__} )  {
                    print "Incompatible corpus version in $bucket\n";
                    return;
                }

                next;
            }

            if ( /([^\s]+) (\d+)/ ) {
                my $word = $self->{mangler__}->mangle($1,1);
                my $value = $2;
                $value =~ s/[\r\n]//g;
                if ( $value > 0 )  {
                    $words{$word} = $value;
                }
            }
        }

        close WORDS;
    }

    $self->{parser__}->parse_stream( $file );

    foreach my $word (keys %{$self->{parser__}->{words__}}) {
        $words{$word} -= $self->{parser__}->{words__}{$word};
    }

    if ( open WORDS, '>' . $self->config_( 'corpus' ) . "/$bucket/table" ) {
        print WORDS "__CORPUS__ __VERSION__ 1\n";
        foreach my $word (sort keys %words) {
            print WORDS "$word $words{$word}\n";
        }
        close WORDS;
    }

    $self->load_word_matrix_();
}

# ---------------------------------------------------------------------------------------------
#
# echo_to_dot_
#
# $mail     The stream (created with IO::) to send the message to (the remote mail server)
# $client   The local mail client (created with IO::) that needs the response
#
# echo all information from the $mail server until a single line with a . is seen
#
# ---------------------------------------------------------------------------------------------

sub echo_to_dot_
{
    my ( $self, $mail, $client ) = @_;

    while ( <$mail> ) {
        # Check for an abort
        last if ( $self->{alive_} == 0 );

        print $client $_;

        # The termination has to be a single line with exactly a dot on it and nothing
        # else other than line termination characters.  This is vital so that we do
        # not mistake a line beginning with . as the end of the block
        last if ( /^\.(\r\n|\r|\n)$/ );
    }
}

# ---------------------------------------------------------------------------------------------
#
# get_buckets_with_magnets
#
# Returns the names of the buckets for which magnets are defined
#
# ---------------------------------------------------------------------------------------------

sub get_buckets_with_magnets
{
    my ( $self ) = @_;

    return sort keys %{$self->{magnets__}};
}

# ---------------------------------------------------------------------------------------------
#
# get_magnet_types_in_bucket
#
# Returns the types of the magnetsd in a specific bucket
#
# $bucket          The bucket to search for magnets
#
# ---------------------------------------------------------------------------------------------

sub get_magnet_types_in_bucket
{
    my ( $self, $bucket ) = @_;

    return sort keys %{$self->{magnets__}{$bucket}};
}

# ---------------------------------------------------------------------------------------------
#
# clear_bucket
#
# Removes all words from a bucket
#
# $bucket         The bucket to clear
#
# ---------------------------------------------------------------------------------------------

sub clear_bucket
{
    my ( $self, $bucket ) = @_;

    my $bucket_directory = $self->config_( 'corpus' ) . "/$bucket";

    unlink( "$bucket_directory/table" );

    $self->load_word_matrix_();
}

# ---------------------------------------------------------------------------------------------
#
# clear_magnets
#
# Removes every magnet currently defined
#
# ---------------------------------------------------------------------------------------------

sub clear_magnets
{
    my ( $self ) = @_;

    delete $self->{magnets__};
}

# ---------------------------------------------------------------------------------------------
#
# get_magnets
#
# Returns the magnets of a certain type in a bucket
#
# $bucket          The bucket to search for magnets
# $type            The magnet type (e.g. from, to or subject)
#
# ---------------------------------------------------------------------------------------------

sub get_magnets
{
    my ( $self, $bucket, $type ) = @_;

    return sort keys %{$self->{magnets__}{$bucket}{$type}};
}

# ---------------------------------------------------------------------------------------------
#
# create_magnet
#
# Make a new magnet
#
# $bucket          The bucket the magnet belongs in
# $type            The magnet type (e.g. from, to or subject)
# $text            The text of the magnet
#
# ---------------------------------------------------------------------------------------------

sub create_magnet
{
    my ( $self, $bucket, $type, $text ) = @_;

    $self->{magnets__}{$bucket}{$type}{$text} = 1;
    $self->save_magnets__();
}

# ---------------------------------------------------------------------------------------------
#
# get_magnet_types
#
# Get a hash mapping magnet types (e.g. from) to magnet names (e.g. From);
#
# ---------------------------------------------------------------------------------------------

sub get_magnet_types
{
    return ( 'from'    => 'From',
             'to'      => 'To',
             'subject' => 'Subject',
             'cc'      => 'Cc' );
}

# ---------------------------------------------------------------------------------------------
#
# delete_magnet
#
# Remove a new magnet
#
# $bucket          The bucket the magnet belongs in
# $type            The magnet type (e.g. from, to or subject)
# $text            The text of the magnet
#
# ---------------------------------------------------------------------------------------------

sub delete_magnet
{
    my ( $self, $bucket, $type, $text ) = @_;

    delete $self->{magnets__}{$bucket}{$type}{$text};
    $self->save_magnets__();
}

# ---------------------------------------------------------------------------------------------
#
# get_stop_word_list
#
# Gets the complete list of stop words
#
# ---------------------------------------------------------------------------------------------

sub get_stop_word_list
{
    my ( $self ) = @_;

    return $self->{parser__}->{mangle__}->stopwords();
}

# ---------------------------------------------------------------------------------------------
#
# add_stopword, remove_stopword
#
# Adds or removes a stop word
#
# $stopword    The word to add or remove
#
# Return 0 for a bad stop word, and 1 otherwise
#
# ---------------------------------------------------------------------------------------------

sub add_stopword
{
    my ( $self, $stopword ) = @_;

    return $self->{parser__}->{mangle__}->add_stopword( $stopword );
}

sub remove_stopword
{
    my ( $self, $stopword ) = @_;

    return $self->{parser__}->{mangle__}->remove_stopword( $stopword );
}

# GETTERS/SETTERS

sub wordscores
{
    my ( $self, $value ) = @_;

    $self->{wordscores__} = $value if (defined $value);
    return $self->{wordscores__};
}

sub scores
{
    my ( $self, $value ) = @_;

    $self->{scores__} = $value if (defined $value);
    return $self->{scores__};
}

1;

