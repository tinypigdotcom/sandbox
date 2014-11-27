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

my %_heroes = (
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
my %_foes = ();
my $no_appearing = roll($monster{no_appearing});
for ( 1 .. $no_appearing ) {
    my $name = "$monster{name} $_";
    my $hd = $monster{hit_dice};
    my $hp = roll("${hd}d8");
    $_foes{$name} = {%monster, name => $name, hit_points => $hp };
}

my %versus = (
    heroes => \%_heroes,
    foes   => \%_foes,
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
    return check_for_deathification($actor);
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
        my $is_dead = damage($foe, $damage);
        print "Hit! $damage damage. $foe->{name} at $foe->{hit_points}. ";
        if ( $is_dead ) {
            print "$foe->{name} is dead!";
        }
    }
    else {
        print "Miss!";
    }
    print "\n";
}

sub set_dead {
    shift->{is_dead} = 1;
    return;
}

sub check_for_deathification {
    my ($actor) = @_;
    if ( $actor->{hit_points} <= 0 ) {
        $actor->{hit_points} = 0;
        set_dead($actor);
        return 1;
    }
    return;
}

sub is_dead {
    my ($actor) = @_;
    if ( $actor->{is_dead} ) {
        return 1;
    }
    return check_for_deathification($actor);
}

#sub death_check {
#    if ( is_dead(\%heroes) or is_dead(\%foes) ) {
#        print "Done\n";
#        exit;
#    }
#    return;
#}
sub check_all {
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
        my @vs = values %versus;
        do_attack($vs[0], $vs[1]);
        do_attack($vs[1], $vs[0]);
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

