#!/bin/bash
parsed_ops=$(
  perl -MGetopt::Long -le '
    @options = ( "foo=s", "bar", "neg!" );

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


my $h               = 0;
my $help            = 0;
my $version         = 0;
my $backdate        = 0;
my $yesterday       = 0;


Getopt::Long::Configure ("bundling");

my %options = (
    "help"          => \$help,
    "version"       => \$version,
    "backdate=i"    => \$backdate,
    "yesterday"     => \$yesterday,

);

# Explicitly add single letter version of each option to allow bundling
my ($key, $value);
my %temp = %options;
while (($key,$value) = each %temp) {
    my $letter = $key;
    $letter =~ s/(\w)\w*/$1/;
    $options{$letter} = $value;
}
# Fix-ups from previous routine
$options{h} = \$h;

GetOptions(%options) or errout("Error in command line arguments");

