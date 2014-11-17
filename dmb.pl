#!/usr/bin/perl
# purpose: To serve man

use 5.16.0;
use warnings FATAL => 'all';

use Data::Dumper;
use File::Basename;
use Getopt::Long;
use IO::File;

our $VERSION = '2.2.2';

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



sub usage {
    usage_top();
    warn <<EOF;
To serve man
Example: elog --backdate=3

  -h, --help    display this help text and exit
  -v, --version display version information and exit

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


Getopt::Long::Configure ("bundling");

my %options = (
    "help"   => \$help,
    "version" => \$version,

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


use 5.16.0;
use warnings FATAL => 'all';

use Data::Dumper;

sub foo {
    print "I am foo.";
}

# legitimate comment
print "Source code goes here.\n";
for (1..3) {
    print "$_\n";
}
print "Done!\n";
foo();




