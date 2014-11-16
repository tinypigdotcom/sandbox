#!/usr/bin/perl
# <- my $code = <<'END_OF_CODE';

use 5.16.0;
use warnings FATAL => 'all';

use Data::Dumper;

sub foo {
    print "I am foo.";
}

# legitimate comment
print "Source code goes here.\n";
for (1..3) {
    print "$_\n";
}
print "Done!\n";
foo();

# <- END_OF_CODE

# <- $VAR1 = {
# <-     VERSION => '2.2.2',
# <-     purpose => 'To serve man',
# <-     CODE    => $code,
# <- };


