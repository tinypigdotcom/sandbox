#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

package Die;
use Moose;

has 'min' => (
    is       => 'rw',
    isa      => 'Int',
    default  => 1,
    required => 1,
);

has 'max' => (
    is       => 'rw',
    isa      => 'Int',
    default  => 6,
    required => 1,
);

sub roll {
    my $self = shift;
    my $roll = int( rand( $self->max() ) ) + $self->min();
    return $roll;
}

no Moose;
__PACKAGE__->meta->make_immutable;

package main;

use Data::Dumper;

sub function1 {
    my $die = Die->new( max => 20, );
    print "min: ", $die->min(), "\n";
    print "max: ", $die->max(), "\n";
    for ( 1 .. 20 ) {
        print "roll: ", $die->roll(), "\n";
    }
}

sub main {
    my @argv = @_;
    function1();
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

