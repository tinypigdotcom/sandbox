
use strict;
use Encode qw(decode encode);

my $string = 'e78cab';
my $bin = pack('H*',$string);
my $mooo = decode('UTF-8', $bin, Encode::FB_CROAK);
my $done = encode('UTF-8', $mooo, Encode::FB_CROAK);
print "done {$done}\n";

#my $str = '2001:0db8:3c4d:0015:0000:0000:abcd:ef12';
#print  join "\n", map { unpack ('B*', pack ('H*',$_)) } split ':', $str;

die;
die;
die;
die;
die;
die;
my $characters = '';
my $a = 'A';
my $octets;
my $switch;

if (1) {
    $switch = $characters;
}
else {
    $switch = $a;
}
$octets = encode('UTF-8', $switch, Encode::FB_CROAK);

#my ( $hex ) = unpack( 'a*', $octets );
(my $hex = unpack("H*", $octets)) =~ s/(..)/$1 /g;

my $moo = decode('UTF-8', $octets, Encode::FB_CROAK);

print "characters {$moo} {$hex}\n";

