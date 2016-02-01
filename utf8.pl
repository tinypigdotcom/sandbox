#!/usr/bin/perl

use strict;
use warnings;

use utf8;

sub check_utf8 {
    my $string = shift;
    my $is_or_isnt = utf8::is_utf8($string) ? 'is' : 'is NOT';
    print "it $is_or_isnt UTF-8 in Perl's internal representation!\n";
}

sub main {
    my @argv = @_;
    my $str =  "\xE7\x9F\x9B";
    print "manually created Chinese word for 'spear' with bytes\n";
    my $length = length($str);
    check_utf8($str);
    print "length of $str: $length (note: no 'Wide character in print' warning\n";
    print utf8::decode($str) ? "decoded it!\n" : "failed to decode it\n";
    check_utf8($str);
    if ( $str =~ /^\w$/ ) {
        print "string matches /^\\w\$/\n";
    }
    else {
        print "string does not match /^\\w\$/\n";
    }
    $length = length($str);
    print "About to trigger 'Wide character in print' warning...\n";
    print "length of '$str': $length\n";
    print "encoding it...\n";
    utf8::encode($str);
    check_utf8($str);
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

# # Convert the internal representation of a Perl scalar to/from UTF-8.
# $num_octets = utf8::upgrade($string);
# $success    = utf8::downgrade($string[, $fail_ok]);
# # Change each character of a Perl scalar to/from a series of
# # characters that represent the UTF-8 bytes of each original character.
# utf8::encode($string);  # "\x{100}"  becomes "\xc4\x80"
# utf8::decode($string);  # "\xc4\x80" becomes "\x{100}"
# $flag = utf8::is_utf8($string); # since Perl 5.8.1
# $flag = utf8::valid($string);

