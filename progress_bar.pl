#! /usr/bin/perl -w

use strict;
use File::Find ();
use Data::Dumper;
use Term::ProgressBar 2.00;

my $index   = 0;

my $all_files = 25;
my $progress = Term::ProgressBar->new(
    {
        name       => 'Updating',
        count      => $all_files,
        ETA        => 'linear',
        term_width => 69,
    }
);
$progress->max_update_rate(1);
my $next_update = 0;

use vars qw(*name *dir *prune);
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

my @list;
File::Find::find({wanted => sub { wanted(\@list) } }, '/cygdrive');

$progress->update($all_files)
  if $all_files >= $next_update;

print "\n", Dumper(\@list);

exit;

sub wanted {
    my ($aref) = @_;
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) || return;
    -d _                                             || return;
    /^\.git\z/s                                      || return;

    push(@$aref, $name)                              || return;
    $index++                                         || return;
    $progress->message($name)                        || return;

    $next_update = $progress->update($index)
      if $index > $next_update;
}

