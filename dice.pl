#!/usr/bin/perl

use 5.14.0;
use autodie;

use Math::Random::Secure qw(irand);

local *STDERR;
open (STDERR, '>', '/dev/null');

sub single {
    return irand(shift)+1;
}

sub multi {
    my $input = shift;
    die unless $input =~ /d/;
    my @inputs = split /d/, $input;
    if ( $input =~ /(\d*)d(\d+)(\D?\d*)/ ) {
        my $num  = $1 || 1;
        my $die  = $2;
        my $plus = $3;
        my $total = 0;
        for my $count ( 1..$num ) {
            my $single = single($die);
            print "die $count: $single\n";
            $total += $single;
        }
        print "... $plus\n";
        eval "\$total = $total $plus";
        print "total is $total\n";
    }
}

multi(@ARGV);

