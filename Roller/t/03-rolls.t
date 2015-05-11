
use strict;
use warnings;

use Test::More tests => 50;
use Roller ':all';

for ( 1..50 ) {
    my $roll = roll('1d4');
    ok( ($roll >= 1 and $roll <= 4), 'roll() is valid');
}

