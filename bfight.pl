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
my $NUM_RUNS = shift @ARGV || 1;

my ( %heroes, %monster, %foes, @versus );

sub set_or_reset {
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
        Bill => {
            name        => 'Bill',
            armor_class => 14,
            hit_points  => 30,
            damage      => '1d6',
        },
    );

    %monster = (
        name         => 'Storm Giant',
        armor_class  => 15,
        hit_dice     => 30,
        damage       => '3d6',
        no_appearing => '1',
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
            living => scalar keys %heroes,
        },
        {
            name   => "Meanies",
            actors => \%foes,
            living => scalar keys %foes,
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
    print "$actor->{name} attacks $foe->{name}! ";
    print "roll: $attack_roll vs AC $foe->{armor_class} ";
    my $damage  = 0;
    my $is_dead = 0;
    if ( $attack_roll >= $foe->{armor_class} ) {
        $damage = roll( $actor->{damage} );
        $is_dead = damage( $foe, $damage );
        print "Hit! $damage damage. $foe->{name} at $foe->{hit_points}. ";
        if ($is_dead) {
            print "$foe->{name} is dead!";
        }
    }
    else {
        print "Miss!";
    }
    print "\n";
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

sub is_dead {
    my ($actor) = @_;
    if ( $actor->{is_dead} ) {
        return 1;
    }
    return check_for_deadness($actor);
}

sub group_vs_group {
    my ( $atk, $targ ) = @_;

    my $attackers = $atk->{actors};
    my $targets   = $targ->{actors};

    my %local_attackers = %$attackers;

    my @live_attackers = grep { !is_dead($_) } values %$attackers;
    my %live_targets;
    for ( keys %$targets ) {
        if ( !is_dead( $targets->{$_} ) ) {
            $live_targets{$_} = $targets->{$_};
        }
    }

    # what if bill kills skeleton 1, how does it get removed so tony does not
    # try to hit it
    for my $actor (@live_attackers) {
        my $idx;
        my @foe_keys = keys %live_targets;
        $idx = $foe_keys[ random( scalar @foe_keys ) - 1 ];
        print "$actor->{name} vs $idx\n";
        my $killed = attack( $actor, $live_targets{$idx} );
        if ( defined $killed && $killed ) {
            $targ->{living} -= $killed;
            if ( $targ->{living} <= 0 ) {
                return $atk->{name}; #Winner!
            }
            delete $live_targets{$idx};
        }
    }
    return;
}

sub fight {
    my %wins;
    for my $run ( 1 .. $NUM_RUNS ) {
        set_or_reset();
        my $winner;
        while (1) {
            $winner = group_vs_group( $versus[0], $versus[1] );
            last if $winner;
            $winner = group_vs_group( $versus[1], $versus[0] );
            last if $winner;
        }
        $wins{$winner}++;
    }
    for ( keys %wins ) {
        print "$_: $wins{$_}\n";
    }
    return;
}

sub main {
    my @argv = @_;
    return fight();
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

