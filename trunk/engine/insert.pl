# ---------------------------------------------------------------------------------------------
#
# insert.pl --- Inserts a mail message into a specific bucket
#
# ---------------------------------------------------------------------------------------------

use strict;

my %words;

# ---------------------------------------------------------------------------------------------
#
# load_word_table
#
# $bucket    The name of the bucket we are loading words for
#
# Fills the words hash with the word frequencies for word loaded from the appropriate bucket
#
# ---------------------------------------------------------------------------------------------

sub load_word_table
{
    my ($bucket) = @_;
    
    # Make sure that the bucket mentioned exists, if it doesn't the create an empty
    # directory and word table

    mkdir("corpus");
    mkdir("corpus/$bucket");
    
    print "Loading word table for bucket '$bucket'...\n";
    
    open WORDS, "<corpus/$bucket/table";
    
    # Each line in the word table is a word and a count
    
    while (<WORDS>)
    {
        if ( /(.+) (.+)/ )
        {
            $words{$1} = $2;
        }
    }
    
    close WORDS;
}

# ---------------------------------------------------------------------------------------------
#
# save_word_table
#
# $bucket    The name of the bucket we are loading words for
#
# Writes the words hash out to a bucket
#
# ---------------------------------------------------------------------------------------------

sub save_word_table
{
    my ($bucket) = @_;

    print "Saving word table for bucket '$bucket'...\n";
    
    open WORDS, ">corpus/$bucket/table";
    
    # Each line in the word table is a word and a count
    
    foreach my $word (keys %words)
    {
        print WORDS "$word $words{$word}\n";
    }
    
    close WORDS;
}

# ---------------------------------------------------------------------------------------------
#
# split_mail_message
#
# $message    The name of the file containing the mail message
#
# Splits the mail message into valid words and updated the words hash
#
# ---------------------------------------------------------------------------------------------

sub split_mail_message
{
    my ($message) = @_;

    print "Parsing message '$message'...\n";

    open MSG, "<$message";
    
    # Read each line and find each "word" which we define as a sequence of alpha
    # characters
    
    while (<MSG>)
    {
        my $line = $_;
        
        while ( $line =~ s/([A-Za-z]{3,})// )
        {
            $words{$1} += 1;
        }
    }
    
    close MSG;
}

# main

if ( $#ARGV == 1 ) 
{
    load_word_table($ARGV[0]);

    my @files   = glob $ARGV[1];
    foreach my $file (@files)
    {
        split_mail_message($file);
    }
    
    save_word_table($ARGV[0]);
    
    print "done.\n";
}
else
{
    print "insert.pl - insert mail messages into a specific bucket\n\n";
    print "Usage: insert.pl <bucket> <messages>\n";
    print "       <bucket>           The name of the bucket\n";
    print "       <messages>         Filename of message(s) to insert\n";
}