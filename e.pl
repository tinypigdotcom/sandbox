#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

use Data::Dumper;

sub function1 {
    for ( 1..6 ) {
        my $roll = roll('1d6');
        print "roll $roll\n";
    }
    print "I am e.pl\n";
}

sub main {
    my @argv = @_;
    print Dumper(\@argv);
    function1();
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;


sub roll {
    my $input = shift;
    return unless $input =~ /(\d*)d(\d+)\s*(\D?)\s*(\d*)/;
    my $num = $1 || 1;
    my ($die,$plus,$end) = ($2,$3,$4);
    my $total = 0;
    my @dice;
    push @dice, int(rand($die))+1 for ( 1..$num );
    if ( $plus eq 'b' ) {
        $end =  $num if $end > $num;
        @dice = sort { $b <=> $a } @dice;
        $#dice = $end-1;
    }
    $total += $_ for @dice;
    if    ( $plus eq '+' ) { $total += $end }
    elsif ( $plus eq '-' ) { $total -= $end }
    elsif ( $plus eq '*' ) { $total *= $end }
    elsif ( $plus eq '/' ) { $total /= $end }
    return $total;
}
