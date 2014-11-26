#!/usr/bin/perl
# purpose: functional (vs class) template

use strict;
use Carp;
use warnings FATAL => 'all';

use Data::Dumper;

my %warrior = (
    name         => 'Tony',
    armor_class  => 18,
    to_hit_bonus => 5,
    hit_points   => 34,
    damage       => '1d10',
);

my %skeleton = (
    name         => 'Skeleton',
    armor_class  => 12,
    to_hit_bonus => 5,
    hit_points   => 8,
    damage       => '1d10',
);

my @heroes = ({%warrior});
my @foes = (
    {%skeleton},
    {%skeleton},
    {%skeleton},
);

sub random {
    return int(rand(shift))+1;
}

sub roll {
    my ($dice) = @_;
    my ($multiplier, $die, $bonus);
    if ( $dice =~ /^(\d*)d(\d+)(.*)/ ) {
        ($multiplier, $die, $bonus) = ($1,$2,$3);
    }
    else {
        croak "Invalid format";
    }
    $multiplier ||= 1;
    my $total = 0;
    for ( 1 .. $multiplier ) {
        $total += random($die);
    }
    eval "\$total = $total $bonus";
    return $total;
}

sub damage {
    my ($actor, $damage) = @_;
    $actor->{hit_points} -= $damage;
    if ( $actor->{hit_points} < 0 ) {
        $actor->{hit_points} = 0;
    }
    return $actor->{hit_points};
}

sub attack {
    my ($actor, $foe) = @_;
    my $attack_roll = roll('d20');
    my $final_attack = $attack_roll + $actor->{to_hit_bonus};
    print "$actor->{name} attacks $foe->{name}! ";
    print "roll: $attack_roll+$actor->{to_hit_bonus}=$final_attack vs AC $foe->{armor_class} ";
    my $damage = 0;
    if ( $final_attack >= $foe->{armor_class} ) {
        $damage = roll($actor->{damage});
        my $remaining = damage($foe, $damage);
        print "Hit! $damage damage. $foe->{name} at $remaining";
    }
    else {
        print "Miss!";
    }
    print "\n";
}

sub is_dead {
    my ($actor) = @_;
    if ( $actor->{hit_points} <= 0 ) {
        print "$actor->{name} is dead!\n";
        return 1;
    }
    return;
}

sub death_check {
    if ( is_dead(\%warrior) or is_dead(\%skeleton) ) {
        print "Done\n";
        exit;
    }
    return;
}

sub do_attack {
    my ($actors, $foes) = @_;
    print "do_attack:\n";
    for ( @$actors ) {
        my $idx = random(scalar @$foes) - 1;
        print "    actor: $_->{name}\n";
        print "      foe: $foes->[$idx]->{name} ($idx)\n";
    }
}

my $delay = 0;
sub fight {
    print "Fight!\n";
    do_attack(\@heroes, \@foes);
    do_attack(\@foes, \@heroes);
    exit;
    while (1) {
        attack(\%warrior, \%skeleton);
        death_check();
        sleep $delay;
        attack(\%skeleton, \%warrior);
        death_check();
        sleep $delay;
    }
}

sub main {
    my @argv = @_;
    fight();
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

