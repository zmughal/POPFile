#!/usr/bin/perl
# ---------------------------------------------------------------------------------------------
#
# bayes.pl --- Classify a mail message manually
#
# Copyright (c) 2001-2003 John Graham-Cumming
#
# ---------------------------------------------------------------------------------------------

use strict;
use Classifier::Bayes;

# main

if ( $#ARGV == 0 ) 
{
    my $b = new Classifier::Bayes;
    
    if ( $b->initialize() == 0 ) {
        die "Failed to start while initializing the classifier module";
    }
    
    $b->{debug} = 1; 
    $b->{parser}->{debug} = 0;
    $b->load_word_matrix();

    my @files   = glob $ARGV[0];
    foreach my $file (@files)
    {
        print "$file is '" . $b->classify_file($file) . "'\n";
    }
    
    foreach my $word (keys %{$b->{parser}->{words}}) {
        print "$word $b->{parser}->{words}{$word}\n";
    }
}
else
{
    print "bayes.pl - output the score that a message is in each bucket\n\n";
    print "Usage: bayes.pl <messages>\n";
    print "       <messages>         Filename of message(s) to classify\n";
}