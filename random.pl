#!/usr/bin/perl

use 5.14.0;
use autodie;

#use Math::Random::Secure qw(irand);

# w: 150 x 47
sub flip {
    return int(rand(2));
    return irand(2);
}

for my $h (1..47) {
    for my $w (1..150) {
        print flip() ? ' ' : 'O';
    }
    print "\n";
}

