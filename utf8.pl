#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

use Data::Dumper;

sub check_utf8 {
    my $string = shift;
    if(utf8::is_utf8($string)) {
        print "is utf8!\n";
    }
    else {
        print "is not utf8!\n";
    }
    return;
}

sub function1 {
    my $str =  "\xE7\x9F\x9B"; # "Spear"
    my $length = length($str);
    check_utf8($str);
    print "length $length\n";
    print "$str\n";
    if (utf8::decode($str)) {
        print "decoded!\n";
    }
    else {
        print "bad\n";
    }
    check_utf8($str);
    if ( $str =~ /\w/ ) {
        print "match\n";
    }
    else {
        print "no match\n";
    }
    $length = length($str);
    print "length $length\n";
    utf8::encode($str);
    check_utf8($str);
    print "$str\n";
}

sub main {
    my @argv = @_;
    function1();
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

#use utf8;
# no utf8;
# # Convert the internal representation of a Perl scalar to/from UTF-8.
# $num_octets = utf8::upgrade($string);
# $success    = utf8::downgrade($string[, $fail_ok]);
# # Change each character of a Perl scalar to/from a series of
# # characters that represent the UTF-8 bytes of each original character.
# utf8::encode($string);  # "\x{100}"  becomes "\xc4\x80"
# utf8::decode($string);  # "\xc4\x80" becomes "\x{100}"
# $flag = utf8::is_utf8($string); # since Perl 5.8.1
# $flag = utf8::valid($string);

