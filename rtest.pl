#!/usr/bin/perl

use strict;
use warnings;

sub random {
    my ($max,$min) = @_;
    $min //= 1;
    if ( $min > $max ) {
        ( $min, $max ) = ( $max, $min );
    }
    my $range = $max - $min;
    return int(rand($range+1))+$min;
}

my %distribution;
for my $h (1..9999) {
    my $num = random(1,2);
    $distribution{$num}++;
}
for ( sort { $a <=> $b } keys %distribution ) {
    print "result $_ : $distribution{$_}\n";
}

