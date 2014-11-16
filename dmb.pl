#!/usr/bin/perl
# purpose: To serve man

use 5.16.0;
use warnings FATAL => 'all';

use Data::Dumper;

our $VERSION = '2.2.2';

my $PROG = $0;
my $ERR_EXIT = 2;

sub errout {
    my $message = join( ' ', @_ );
    warn "$PROG: $message\n";
    exit $ERR_EXIT;
}


# legitimate comment
print "Source code goes here.\n";
for (1..3) {
    print "$_\n";
}
print "Done!\n";




