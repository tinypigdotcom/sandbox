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
    damage       => '3d6',
);

my %heroes = (
    Tony => \%warrior,
    Bill => {
    name         => 'Bill',
        armor_class  => 14,
        to_hit_bonus => 5,
        hit_points   => 30,
        damage       => '1d6',
    },
);

my %monster = (
    name         => 'Giant',
    armor_class  => 14,
    to_hit_bonus => 5,
    hit_dice     => 10,
    damage       => '1d10',
    no_appearing => '1d10',
);

my %foes = ();
my $no_appearing = roll($monster{no_appearing});
for ( 1 .. $no_appearing ) {
    my $name = "$monster{name} $_";
    my $hd = $monster{hit_dice};
    my $hp = roll("${hd}d8");
    $foes{$name} = {%monster, name => $name, hit_points => $hp };
}

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
    if ( ref $actor ne 'HASH' ) {
        $actor = {$actor->{name} => $actor};
    }
    my $tot = 0;
    my $dead = 0;
    my ($key, $value);
        die Dumper($actor);
    while (($key, $value) = each %$actor) {
        if ( $value->{hit_points} <= 0 ) {
            $dead++;
        }
        $tot++;
    }
    if ( $dead == $tot ) {
        return 1;
    }
    return;
}

sub death_check {
    if ( is_dead(\%heroes) or is_dead(\%foes) ) {
        print "Done\n";
        exit;
    }
    return;
}

sub do_attack {
    my ($actors, $foes) = @_;
    my %local_actors = %$actors;

    my ($key, $value);
    while (($key, $value) = each %local_actors) {
        if ( is_dead( $value ) ) {
            print "$value->{name} is dead and cannot attack.\n";
            next;
        }
        my $foe_dead = 1;
        my $sanity_check = 20;
        my $idx;
        while ( $foe_dead ) {
            my @foe_keys = keys %$foes;
            $idx = $foe_keys[random(scalar @foe_keys)-1];
            print "$key vs $idx\n";
            $foe_dead = is_dead( $foes->{$idx} );
            if ( $sanity_check-- < 1 ) {
                die "too many loops";
            }
        }
        attack($value,$foes->{$idx});
    }
}

my $delay = 0;
sub fight {
    print "Fight!\n";
    for(1..10) {
        do_attack(\%heroes, \%foes);
        death_check();
        do_attack(\%foes, \%heroes);
        death_check();
        sleep 5;
    }
    return;
}

sub main {
    my @argv = @_;
    return fight();
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

