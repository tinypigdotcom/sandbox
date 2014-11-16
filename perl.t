#!/usr/bin/perl
# purpose: [< $purpose >]

use 5.16.0;
use warnings FATAL => 'all';

use Data::Dumper;

our $VERSION = '[< $VERSION >]';

my $PROG = $0;
my $ERR_EXIT = 2;

sub errout {
    my $message = join( ' ', @_ );
    warn "$PROG: $message\n";
    exit $ERR_EXIT;
}

[< $CODE >]

