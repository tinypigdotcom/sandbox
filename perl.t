#!/usr/bin/perl
# purpose: [< $purpose >]

use 5.16.0;
use warnings FATAL => 'all';

use Data::Dumper;
use File::Basename;
use Getopt::Long;
use IO::File;

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

[
my $sl=0;
for (@options) {
    my $len = length $_->{short_desc};
    $sl = $len if $len > $sl;
}

for (@options) {
    my $ff = substr $_->{long_switch}, 0, 1;
    printf " %3s, --%-${sl}s $_->{long_desc}\n", "-$ff", $_->{short_desc};
}
]


sub usage {
    usage_top();
    warn <<EOF;
Edit work log
Example: elog --backdate=3

  -h, --help                display this help text and exit
  -v, --version             display version information and exit
  -y, --yesterday           edit yesterday's data instead of today's
  -b, --backdate=#DAYS      edit # days ago instead of today
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

my $backdate  =  0;
my $h         =  0;
my $help      =  0;
my $version   =  0;
my $yesterday =  0;

Getopt::Long::Configure ("bundling");

my %options = (
    "backdate=i"  => \$backdate,
    "help"        => \$help,
    "version"     => \$version,
    "yesterday"   => \$yesterday,
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

