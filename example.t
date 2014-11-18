#!/usr/bin/perl
# purpose: [< $purpose >]

use 5.16.0;
use warnings FATAL => 'all';

use File::Basename;
use Getopt::Long;

our $VERSION = '[< $VERSION >]';

my $PROG = basename($0);
my $ERR_EXIT = 2;

sub usage_top {
    warn "Usage: $PROG [OPTION]...\n";
}

sub short_usage {
    usage_top();
    warn "Try '$PROG --help' for more information.\n";
}

sub errout {
    my $message = join( ' ', @_ );
    warn "$PROG: $message\n";
    short_usage();
    exit $ERR_EXIT;
}

[< $sl=0;
unshift @options,
{
    long_switch => 'help',
    short_desc  => 'help',
    long_desc   => 'display this help text and exit',
},
{
    long_switch => 'version',
    short_desc  => 'version',
    long_desc   => 'display version information and exit',
};
for (@options) {
    my $len = length $_->{short_desc};
    $sl = $len if $len > $sl;
} >]

sub usage {
    usage_top();
    warn <<EOF;
[< $purpose >]
Example: $PROG [< $example >]

[< for (@options) {
    my $ff = substr $_->{long_switch}, 0, 1;
    $_->{one_key} = $ff;
    $_->{varname} = $_->{long_switch};
    $_->{varname} =~ s/\W.*//; # turn backdate=i into backdate
    $OUT .= sprintf(" %3s, --%-${sl}s $_->{long_desc}\n", "-$ff", $_->{short_desc});
} >]
EOF
    return;
}

sub do_short_usage {
    short_usage();
    exit $ERR_EXIT;
}

sub version {
    warn "$PROG $VERSION\n";
    return;
}

my $h       = 0;
my $help    = 0;
my $version = 0;
[< $INIT >]

Getopt::Long::Configure ("bundling");

my %options = (
[< for (@options) {
    $OUT .= sprintf("    \"%-${sl}s => \\\$$_->{varname},\n", "$_->{long_switch}\"");
} >]
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

if    ($help)     { usage(); exit    }
elsif ($h)        { do_short_usage() }
elsif ($version)  { version(); exit  }

[< $CODE >]

