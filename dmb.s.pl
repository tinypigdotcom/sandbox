#!/usr/bin/perl
# <- my $code = <<'END_OF_CODE';

# legitimate comment
print "Source code goes here.\n";
for (1..3) {
    print "$_\n";
}
print "Done!\n";

# <- END_OF_CODE

$VAR1 = {
    VERSION => '2.2.2',
    purpose => 'To serve man',
    CODE    => $code,
};

