#!/usr/bin/perl

use strict;
use Carp;
use warnings FATAL => 'all';

use Data::Dumper;
my $DEBUG=0;
my $NUM_RUNS=999;
my $MAX_RUNS_FOR_DETAIL=5;
my $DETAIL;
if ( $NUM_RUNS <= $MAX_RUNS_FOR_DETAIL ) {
    $DETAIL=1;
}
else {
    $DETAIL=0;
}

my %heroes;
my %monster;
my %foes;
my @versus;

sub set_or_reset {
    %heroes = (
        Tony => {
            name         => 'Tony',
            armor_class  => 18,
            to_hit_bonus => 5,
            hit_points   => 34,
            damage       => '1d8',
        },
        Jax => {
            name         => 'Jax',
            armor_class  => 18,
            to_hit_bonus => 6,
            hit_points   => 40,
            damage       => '1d10',
        },
        Bill => {
            name         => 'Bill',
            armor_class  => 14,
            to_hit_bonus => 5,
            hit_points   => 30,
            damage       => '1d6',
        },
    );

    %monster = (
        name         => 'Storm Giant',
        armor_class  => 15,
        to_hit_bonus => 7,
        hit_dice     => 30,
        damage       => '3d6',
        no_appearing => '1',
    );

    %foes = ();
    my $no_appearing = roll($monster{no_appearing});
    for ( 1 .. $no_appearing ) {
        my $name = "$monster{name} $_";
        my $hd = $monster{hit_dice};
        my $hp = roll("${hd}d8");
        $foes{$name} = {%monster, name => $name, hit_points => $hp };
    }

    @versus = (
        {
            name   => "Cool Guys",
            actors => \%heroes,
            living => scalar keys %heroes,
        },
        {
            name   => "The Storm Giant",
            actors => \%foes,
            living => scalar keys %foes,
        },
    );
}

sub debug {
    print @_ if $DEBUG;
}

sub detail {
    print @_ if $DETAIL;
}

sub random {
    return int(rand(shift))+1;
}

sub roll {
    my ($dice) = @_;
    if ( $dice =~ /^\d+$/ ) {
        return $dice;
    }
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
    return check_for_deadness($actor);
}

sub attack {
    my ($actor, $foe) = @_;
    my $attack_roll = roll('d20');
    my $final_attack = $attack_roll + $actor->{to_hit_bonus};
    detail("$actor->{name} attacks $foe->{name}! ");
    detail("roll: $attack_roll+$actor->{to_hit_bonus}=$final_attack vs AC $foe->{armor_class} ");
    my $damage = 0;
    my $is_dead = 0;
    if ( $final_attack >= $foe->{armor_class} ) {
        $damage = roll($actor->{damage});
        $is_dead = damage($foe, $damage);
        detail("Hit! $damage damage. $foe->{name} at $foe->{hit_points}. ");
        if ( $is_dead ) {
            detail("$foe->{name} is dead!");
        }
    }
    else {
        detail("Miss!");
    }
    detail("\n");
    return $is_dead;
}

sub set_dead {
    shift->{is_dead} = 1;
    return;
}

sub check_for_deadness {
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
    return check_for_deadness($actor);
}

sub group_vs_group {
    my ($atk, $targ) = @_;

    my $attackers = $atk->{actors};
    my $targets   = $targ->{actors};

    my %local_attackers = %$attackers;

    my ($key, $value);
    while (($key, $value) = each %local_attackers) {
        if ( is_dead( $value ) ) {
            debug("$value->{name} is dead and cannot attack.\n");
            next;
        }
        my $foe_dead = 1;
        my $sanity_check = 999;
        my $idx;
        while ( $foe_dead ) {
            my @foe_keys = keys %$targets;
            $idx = $foe_keys[random(scalar @foe_keys)-1];
            debug("$key vs $idx\n");
            $foe_dead = is_dead( $targets->{$idx} );
            if ( $sanity_check-- < 1 ) {
                die "too many loops";
            }
        }
        my $killed = attack($value,$targets->{$idx});
        if ( defined $killed && $killed ) {
            $targ->{living} -= $killed;
            if ( $targ->{living} <= 0 ) {
                return $atk->{name};
            }
        }
    }
    return;
}

my $delay = 0;
sub fight {
    my %wins;
    for my $run ( 1 .. $NUM_RUNS ) {
        set_or_reset();
        my $winner;
        while (1) {
            $winner = group_vs_group($versus[0], $versus[1]);
            last if $winner;
            $winner = group_vs_group($versus[1], $versus[0]);
            last if $winner;
        }
        $wins{$winner}++;
    }
    die Dumper(\%wins);
    return;
}

sub main {
    my @argv = @_;
    return fight();
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

