#!/bin/bash
parsed_ops=$(
  perl -MGetopt::Long -le '
    use strict;
    Getopt::Long::Configure ("bundling");

    my @options = (
        "help",
        "version",
        "backdate=i",
        "bogus=s",
        "yesterday",
    );

    # Explicitly add single letter version of each option to allow bundling
    my @temp = @options;
    for my $letter (@temp) {
        $letter =~ s/(\w)\w*/$1/;
        next if $letter eq q{h};
        push @options, $letter;
    }
    push @options, q{h};

    my $q = "'\''";
    use vars qw( $opt_help $opt_version $opt_backdate $opt_bogus $opt_yesterday $opt_v $opt_b $opt_b $opt_y $opt_h );
    GetOptions(@options) or exit 1;
    my $o;
    for ( map /(\w+)/, @options ) {
        eval "\$o=\$opt_$_";
        $o =~ s/$q/$q\\$q$q/g;
        print "opt_$_=$q$o$q";
    }' -- "$@"
) || exit
echo $parsed_ops
eval "$parsed_ops"
echo $opt_bogus


