#!/usr/bin/perl

my @options = (
    {
        long_switch => 'horror=s',
        short_desc  => 'horror=j_horror_movie',
        long_desc   => "the quick brown fox jumped over the lazy dog's back 0123456789 times",
    },
    {
        long_switch => 'backdate=i',
        short_desc  => 'backdate=#DAYS',
        long_desc   => 'edit # days ago instead of today',
    },
    {
        long_switch => 'yesterday',
        short_desc  => 'yesterday',
        long_desc   => "edit yesterday's data instead of today's",
    },
    {
        long_switch => 'gooby',
        short_desc  => 'goob',
        long_desc   => "be a goober",
    },
);

my $sl=0;
for (@options) {
    my $len = length $_->{short_desc};
    $sl = $len if $len > $sl;
}

for (@options) {
    my $ff = substr $_->{long_switch}, 0, 1;
    printf " %3s, --%-${sl}s $_->{long_desc}\n", "-$ff", $_->{short_desc};
}

