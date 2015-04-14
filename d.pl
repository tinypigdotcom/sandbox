#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

use Data::Dumper;

sub function1 {
    my $target = '.';
    my $new;
    for ('a'..'z') {
        if ( ! -f "$_.pl" ) {
            $new = "$_.pl";
            last;
        }
    }
    my $editor = $ENV{EDITOR} || 'vim';
    system "$editor $new";
}

sub main {
    my @argv = @_;
    function1();
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

# example
# my @dot_files = grep { /^\./ && -f "$some_dir/$_" } get_directory($target);
sub get_directory {
    my ($dir) = @_;
    opendir(my $dh, $dir) || die "can't opendir $dir: $!";
    my @files = readdir($dh);
    closedir $dh;
    return @files;
}

sub file_slurp {
    my $fh;
    my $contents = do { local $/; <$fh> }
}


sub infile {
    use IO::File;

    my $ifh = IO::File->new($0, '<');
    die if (!defined $ifh);

    while(<$ifh>) {
        chomp;
        print "l: $_\n";
    }
    $ifh->close;
}


sub outfile {
    use IO::File;
    my $ofh = IO::File->new('a.out', '>');
    die if (!defined $ofh);

    print $ofh "bar\n";
    $ofh->close;
}


sub timestamp {
    my ($sec,$min,$hour,$mday,$mon,$year) = localtime(time);

    $mon++;
    $year += 1900;

    return sprintf("%04s%02s%02s%02s%02s%02s",$year,$mon,$mday,$hour,$min,$sec);
}


