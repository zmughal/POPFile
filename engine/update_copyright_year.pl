#!/usr/bin/perl
# ----------------------------------------------------------------------------
#
# update_copyright_year.pl - Utility to update copyright year
#
# Copyright (c) 2001-2010 John Graham-Cumming
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

use File::Find;
use File::Copy;

# parameters

my $prev_year    = 2009;
my $current_year = 2010;


find( \&wanted, ( '.' ) );

sub wanted
{
    return if ( -d $_ );
    return if ( $File::Find::dir =~ /.svn/ );

    my $filename = $_;

    if ( $filename =~ /[.]pl$|[.]pm$|[.]sql$|[.]msg$|Makefile$|[.]tst$|[.]script$/ ) {
        print $File::Find::name, "\n";

        open my $file, "<$filename" or die $!;
        open my $temp, ">$filename.temp" or die $!;
        my $updated = 0;

        while ( <$file> ) {
            $updated |= ( $_ =~ s/[-]$prev_year/-$current_year/ );
            print $temp $_;
        }
        close $file;
        close $temp;

        if ( $updated ) {
            print "  updated $filename\n";

            move( $filename, "$filename.bak" );
            move( "$filename.temp", $filename );
        } else {
            unlink "$filename.temp";
        }
    }
}

1;
