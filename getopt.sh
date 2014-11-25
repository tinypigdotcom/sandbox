#!/bin/bash
parsed_ops=$(
  perl -MGetopt::Long -le '
    Getopt::Long::Configure ("bundling");

    my @options = (
        "help",
        "version",
        "backdate=i",
        "yesterday",
    );

    # Explicitly add single letter version of each option to allow bundling
    my ($key, $value);
    my @temp = @options;
    for my $letter (@temp) {
        $letter =~ s/(\w)\w*/$1/;
        next if $letter eq 'h';
        push @options, $letter;
    }
    # Fix-ups from previous routine
    push @options, 'h';

    Getopt::Long::Configure "bundling";
    $q = "'\''";
    GetOptions(@options) or exit 1;
    for ( map /(\w+)/, @options ) {
        eval "\$o=\$opt_$_";
        $o =~ s/$q/$q\\$q$q/g;
        print "opt_$_=$q$o$q";
    }' -- "$@"
) || exit
echo $parsed_ops
eval "$parsed_ops"


