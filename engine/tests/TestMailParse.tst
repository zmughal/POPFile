# ---------------------------------------------------------------------------------------------
#
# Tests for MailParse.pm
#
# Copyright (c) 2003 John Graham-Cumming
#
# ---------------------------------------------------------------------------------------------

use Classifier::MailParse;

my $cl = new Classifier::MailParse;

# map_color()
test_assert_equal( $cl->map_color( 'red' ),     'ff0000' ); 
test_assert_equal( $cl->map_color( 'ff0000' ),  'ff0000' ); 
test_assert_equal( $cl->map_color( 'FF0000' ),  'ff0000' ); 
test_assert_equal( $cl->map_color( '#fF0000' ), 'ff0000' ); 
test_assert_equal( $cl->map_color( '#Ff0000' ), 'ff0000' ); 
test_assert_equal( $cl->map_color( 'white' ),   'ffffff' ); 
test_assert_equal( $cl->map_color( 'fFfFFf' ),  'ffffff' ); 
test_assert_equal( $cl->map_color( 'FFFFFF' ),  'ffffff' ); 
test_assert_equal( $cl->map_color( '#ffffff' ), 'ffffff' ); 
test_assert_equal( $cl->map_color( '#FFfFFF' ), 'ffffff' ); 

# Check line splitting into words
$cl->{htmlbackcolor} = $cl->map_color( 'white' );
$cl->{htmlfontcolor} = $cl->map_color( 'black' );
$cl->{words}         = {};
$cl->add_line( 'this is a test of,adding words: from a line of text!', 0, '' );
test_assert_equal( $cl->{words}{test},   1 );
test_assert_equal( $cl->{words}{adding}, 1 );
test_assert_equal( $cl->{words}{words},  1 );
test_assert_equal( $cl->{words}{line},   1 );
test_assert_equal( $cl->{words}{text},   1 );
$cl->add_line( 'adding', 0, '' );
test_assert_equal( $cl->{words}{adding}, 2 );

# Check that we correctly handle spaced out and dotted word
$cl->{words}         = {};
$cl->add_line( 'T H I S  T E X T  I S  S P A C E D alot', 0, '' );
test_assert_equal( $cl->{words}{text},   1 );
test_assert_equal( $cl->{words}{spaced}, 1 );
test_assert_equal( $cl->{words}{alot},   1 );
$cl->{words}         = {};
$cl->add_line( 'offer a full 90 day m.oney b.ack g.uarantee.  If any customer is not. C.lick b.elow f.or m.ore i.nformation, it\'s f.r.e.e.', 0, '' );
test_assert_equal( $cl->{words}{offer},     1 );
test_assert_equal( $cl->{words}{full},      1 );
test_assert_equal( $cl->{words}{money},     1 );
test_assert_equal( $cl->{words}{back},      1 );
test_assert_equal( $cl->{words}{customer},  1 );
test_assert_equal( $cl->{words}{'trick:dottedwords'}, 6 );
test_assert_equal( $cl->{words}{click},     1 );
test_assert_equal( $cl->{words}{below},     1 );
test_assert_equal( $cl->{words}{more},      1 );

# Check discovery of font color
$cl->{htmlfontcolor} = '';
test_assert_equal( $cl->parse_html( '<font color="white">' ), 0 );
test_assert_equal( $cl->{htmlfontcolor}, $cl->map_color( 'white' ) );
$cl->{htmlfontcolor} = '';
test_assert_equal( $cl->parse_html( '<font color=red>' ), 0 );
test_assert_equal( $cl->{htmlfontcolor}, $cl->map_color( 'red' ) );
$cl->{htmlfontcolor} = '';
test_assert_equal( $cl->parse_html( '<font color=#00ff00>' ), 0 );
test_assert_equal( $cl->{htmlfontcolor}, $cl->map_color( 'green' ) );
$cl->{htmlfontcolor} = '';
test_assert_equal( $cl->parse_html( '<font color=#00ff00></font>' ), 0 );
test_assert_equal( $cl->{htmlfontcolor}, $cl->map_color( 'black' ) );

# Check comment detection
$cl->{words}         = {};
test_assert_equal( $cl->parse_html( '<!-- foo -->' ), 0 );
test_assert_equal( $cl->parse_html( '<!-- -->' ), 0 );
test_assert_equal( $cl->parse_html( '<!---->' ), 0 );
test_assert_equal( $cl->{words}{'html:comment'}, 3 );
# Check that we don't think the DOCTYPE is a comment
test_assert_equal( $cl->parse_html( '<!DOCTYPE >' ), 0 );
# test_assert_equal( $cl->{words}{'html:comment'}, 3 );

# Check invisible ink detection
$cl->{htmlfontcolor} = '';
$cl->{words}         = {};
$cl->{in_html_tag}   = 0;
test_assert_equal( $cl->parse_html( '<body bgcolor="#ffffff">hello<font color=white>invisible</font>visible</body>  ' ), 0 );
test_assert_equal( $cl->{words}{hello},     1 );
test_assert_equal( $cl->{words}{visible},   1 );
test_assert_equal( defined( $cl->{words}{invisible} ), '' );
$cl->{htmlfontcolor} = '';
$cl->{words}         = {};
$cl->{in_html_tag}   = 0;
test_assert_equal( $cl->parse_html( '   <body bgcolor="#ffffff">  hello<font color=white>' ), 0 );
test_assert_equal( $cl->parse_html( '  invisible </font>'                                ), 0 );
test_assert_equal( $cl->parse_html( 'visible</body>'                                  ), 0 );
test_assert_equal( $cl->{words}{hello},     1 );
test_assert_equal( $cl->{words}{visible},   1 );
test_assert_equal( defined( $cl->{words}{invisible} ), '' );
$cl->{htmlfontcolor} = '';
$cl->{words}         = {};
$cl->{in_html_tag}   = 0;
test_assert_equal( $cl->parse_html( '<body bgcolor="#ffffff">hello  <font' ), 1 );
test_assert_equal( $cl->parse_html( 'color=white>invisible </font>'       ), 0 );
test_assert_equal( $cl->parse_html( 'visible    </body>'                     ), 0 );
test_assert_equal( $cl->{words}{hello},     1 );
test_assert_equal( $cl->{words}{visible},   1 );
test_assert_equal( defined( $cl->{words}{invisible} ), '' );

# glob the tests directory for files called TestMailParse\d+.msg which consist of messages 
# to be parsed with the resulting values for the words hash in TestMailParse\d+.wrd

my @parse_tests = sort glob 'tests/TestMailParse*.msg';

for my $parse_test (@parse_tests) {
    my $words = $parse_test;
    $words    =~ s/msg/wrd/;
    
    # Parse the document and then check the words hash against the words in the
    # wrd file

    $cl->parse_stream( $parse_test );

    open WORDS, "<$words";
    while ( <WORDS> ) {
        if ( /(.+) (\d+)/ ) {
            test_assert_equal( $cl->{words}{$1}, $2, "$words $1 $2" );
        }
    }
    close WORDS;
}

# Check that from, to and subject get set correctly when parsing a message
$cl->parse_stream( 'tests/TestMailParse013.msg' );
test_assert_equal( $cl->{from},    'RN <rrr@nnnnnnnnn.com>'                        );
test_assert_equal( $cl->{to},      '"Armlet Forum" <armlet-forum@news.palmos.com>' );
test_assert_equal( $cl->{subject}, '(Archive Copy) RE: CW v9 and armlets...'       );
$cl->parse_stream( 'tests/TestMailParse018.msg' );
$cl->{to} =~ /(\Qbugtracker\E@\Qrelativity.com\E)/;
test_assert_equal( $1, 'bugtracker@relativity.com' );
$cl->parse_stream( 'tests/TestMailParse019.msg' );
$cl->{to} =~ /(\Qbugtracker\E@\Qrelativity.com\E)/;
test_assert_equal( $1, 'bugtracker@relativity.com' );

# Check that multi-line To: and CC: headers get handled properly
$cl->parse_stream( 'tests/TestMailParse021.msg' );
test_assert_equal( $cl->{to},      "dsmith\@ctaz.com, dsmith\@dol.net, dsmith\@dirtur.com, dsmith\@dialpoint.net, dsmith\@crosscountybank.com, \15\12\t<dsmith\@cybersurf.net>, <dsmith\@dotnet.com>, <dsmith\@db.com>, <dsmith\@cs.com>\15\12\t, <dsmith\@crossville.com>, \15\12\t<dsmith\@dreamscape.com>, <dsmith\@cvnc.net>, <dsmith\@dmrtc.net>, <dsmith\@datarecall.net>, \15\12\t<dsmith\@dasia.net>" );
test_assert_equal( $cl->{cc},      "dsmith\@dmi.net, dsmith\@datamine.net, dsmith\@crusader.com, dsmith\@datasync.com, \15\12\t<dsmith\@doorpi.net>, <dsmith\@dnet.net>, <dsmith\@cybcon.com>, <dsmith\@csonline.net>, \15\12\t<dsmith\@directlink.net>, <dsmith\@cvip.net>, <dsmith\@dragonbbs.com>, <dsmith\@crosslinkinc.com>, \15\12\t<dsmith\@dccnet.com>, <dsmith\@dakotacom.net>" );

open TEST, ">tests/temp.out1";
print TEST "$cl->{to}\15\12\15\12\15\12";
print TEST "dsmith\@ctaz.com, dsmith\@dol.net, dsmith\@dirtur.com, dsmith\@dialpoint.net, dsmith\@crosscountybank.com, \15\12\t<dsmith\@cybersurf.net>, <dsmith\@dotnet.com>, <dsmith\@db.com>, <dsmith\@cs.com>\15\12\t, <dsmith\@crossville.com>, \15\12\t<dsmith\@dreamscape.com>, <dsmith\@cvnc.net>, <dsmith\@dmrtc.net>, <dsmith\@datarecall.net>, \15\12\t<dsmith\@dasia.net>";

#Test colorized output

# glob the tests directory for files called TestMailParse\d+.msg which consist of messages 
# to be sent through parse_stream


use Classifier::Bayes;

$cl->{bayes} = new Classifier::Bayes;
#$cl->{bayes}->initialize();

$cl->{color} = 1;
$cl->{debug} = 0;

my @color_tests = sort glob 'tests/TestMailParse*.msg';

for my $input_file (@color_tests) {
    if ( open OUTPUT, ">tests/temp.out" ) {        
	    my $output = $cl->parse_stream($input_file);
	    
	    
	    print OUTPUT $output;	    	    
		close OUTPUT;

		my $output_file = $input_file;
		$output_file    =~ s/msg/col/;

		open COL, "<$output_file";
		open OUTPUT, "<tests/temp.out";
		while ( <OUTPUT> ) {
		    my $output_line = $_;
			my $col_line    = <COL>;
			$output_line =~ s/[\r\n]//g;
			$col_line =~ s/[\r\n]//g;
			test_assert_equal( $col_line, $output_line, $input_file );
		}
		
		close COL;
		close OUTPUT;
#       rename( 'tests/temp.out', $output_file );
		unlink( 'tests/temp.out' );
		
    }
}