#!/usr/bin/perl
# WRITING A BLOG BASED ON THIS
# TODO
# idea: if dead, delete from hash
# perltidy
# perl critic
# encapsulate
# remove dead from consideration, thus:
#   remove sanity check

use strict;
my $SHOW_DETAIL = 0;
my $NUM_RUNS = shift @ARGV || 100;

my ( %heroes, %monster, %foes, @versus );

sub detail {
    print @_ if $SHOW_DETAIL;
}

sub init {
    %heroes = (
        Tony => {
            name        => 'Tony',
            armor_class => 18,
            hit_points  => 34,
            damage      => '1d8',
        },
        Jax => {
            name        => 'Jax',
            armor_class => 18,
            hit_points  => 40,
            damage      => '1d10',
        },
    );

    %monster = (
        name         => 'Skeleton',
        armor_class  => 13,
        hit_dice     => 1,
        damage       => '1d8',
        no_appearing => '1d20',
    );

    %foes = ();
    my $no_appearing = roll( $monster{no_appearing} );
    for ( 1 .. $no_appearing ) {
        my $name = "$monster{name} $_";
        my $hd   = $monster{hit_dice};
        my $hp   = roll("${hd}d8");
        $foes{$name} = { %monster, name => $name, hit_points => $hp };
    }

    @versus = (
        {
            name   => "Cool Guys",
            actors => \%heroes,
        },
        {
            name   => "Meanies",
            actors => \%foes,
        },
    );
}

sub random {
    return int( rand(shift) ) + 1;
}

sub roll {
    my ($dice) = @_;

    return $dice if $dice =~ /^\d+$/;

    my ( $multiplier, $die, $bonus );
    if ( $dice =~ /^(\d*)d(\d+)(.*)/ ) {
        ( $multiplier, $die, $bonus ) = ( $1, $2, $3 );
    }
    else {
        die "Invalid format";
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
    my ( $actor, $damage ) = @_;
    $actor->{hit_points} -= $damage;
    return check_for_deadness($actor);
}

sub attack {
    my ( $actor, $foe ) = @_;

    my $attack_roll = roll('d20');

    detail "$actor->{name} attacks $foe->{name}! ";
    detail "roll: $attack_roll vs AC $foe->{armor_class} ";

    my $is_dead = 0;
    if ( $attack_roll >= $foe->{armor_class} ) {
        my $damage  = 0;
        $damage = roll( $actor->{damage} );
        $is_dead = damage( $foe, $damage );
        detail "Hit! $damage damage. $foe->{name} at $foe->{hit_points}. ";
        if ($is_dead) {
            detail "$foe->{name} is dead!";
        }
    }
    else {
        detail "Miss!";
    }

    detail "\n";
    return $is_dead;
}

sub check_for_deadness {
    my ($actor) = @_;
    if ( $actor->{hit_points} <= 0 ) {
        $actor->{hit_points} = 0;
        $actor->{is_dead}    = 1;
        return 1;
    }
    return;
}

sub group_vs_group {
    my ( $atk, $targ ) = @_;

    my $attackers = $atk->{actors};
    my $targets   = $targ->{actors};

    for my $actor (values %$attackers) {
        my @foe_keys = keys %$targets;
        my $idx = $foe_keys[ random( scalar @foe_keys ) - 1 ];
        detail "$actor->{name} vs $idx\n";
        my $killed = attack( $actor, $targets->{$idx} );
        if ( defined $killed && $killed ) {
            delete $targets->{$idx};
            if ( scalar %{$targ->{actors}} <= 0 ) {
                return $atk->{name}; #Winner!
            }
        }
    }
    return;
}

sub main {
    my @argv = @_;
    my %wins;

    for my $run ( 1 .. $NUM_RUNS ) {
        init();
        my $winner;
      WHILE:
        while (1) {
            for my $i ( 0 .. 1 ) {
                $winner = group_vs_group( $versus[$i], $versus[ !$i ] );
                last WHILE if $winner;
            }
        }
        $wins{$winner}++;
    }

    for ( sort { $wins{$b} <=> $wins{$a} } keys %wins ) {
        printf "%12s: $wins{$_}\n", $_;
    }

    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;
