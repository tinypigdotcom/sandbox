# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Roller.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More;
use Roller ':all';

BEGIN { use_ok('Roller') };

my $tt = 1;
my $num_subtests = 1000;

sub is_valid {
    my ($value,@list) = @_;
    for (@list) {
        return 1 if $value == $_;
    }
    return 0;
}

ok( !defined(roll('some_invalid_value')), 'Return on invalid value'); $tt++;

for ( 1..$num_subtests ) {
    my $roll = roll('1d6');
    ok( is_valid($roll,1..6), 'Valid 1d6 value' ); $tt++;
}

for ( 1..$num_subtests ) {
    my $roll = roll('1d6+1');
    ok( is_valid($roll,2..7), 'Valid 1d6+1 value' ); $tt++;
}

for ( 1..$num_subtests ) {
    my $roll = roll('2d6');
    ok( is_valid($roll,2..12), "Valid 2d6 value ($roll)" ); $tt++;
}

done_testing( $tt );

#    ok(int($roll) == $roll, 'Roll is an integer');
#    ok($roll >= 1, 'Roll greater than or equal to lowest');
#    ok($roll <= 6, 'Roll less than or equal to highest');

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

