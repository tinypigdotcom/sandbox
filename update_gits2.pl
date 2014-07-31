#!/usr/bin/perl

use Modern::Perl '2014';
our $VERSION = 'v0.1.3';

# use warnings FATAL => 'all'; #template?

package MyTemplateScript {

    use Carp;
    use Data::Dumper;
    use Hash::Util qw(lock_keys);
    our $VAR1;

    my $persist_file = "$ENV{HOME}/.my_template_script";
    my $do_persist   = 1;





# ------------------ MAIN -----------------------------------------------------

my @keys = qw( argv template_bar template_foo );

sub run {
    my ( $self, @argv ) = @_;
    $self->{argv} = \@argv;

    $self->template_process1();
    $self->template_process2();
    $self->{template_foo} = 5;
    $self->{template_bar} = { name => 'baz' };
    $self->freeze_me();
    return 0; # return for entire script template
}

sub template_process1 {
    my ($self) = @_;
    print "template_process1\n";
}

sub template_process2 {
    my ($self) = @_;
    print "template_process2\n";
}

# ------------------ END MAIN -------------------------------------------------






    sub new {
        my ($class) = @_;

        my $self = {};
        bless $self, $class;
        thaw_me( \$self );
        lock_keys( %$self, @keys );

        return $self;
    }

    sub thaw_me {
        return unless $do_persist;

        my ($self) = @_;
        ${$self} = thaw($persist_file);

        warn "thawed! (template)\n", Dumper($self);
        if ( !defined $self ) {
            croak "failed eval of dump";
        }
    }

    sub freeze_me {
        return unless $do_persist;

        my ($self) = @_;
        $self->freeze( $persist_file, $self );
    }

    sub thaw {
        my ( $self, $filename ) = @_;
        if ( !ref($self) ) {
            $filename = $self;
        }

        my $ifh = IO::File->new( $filename, '<' );
        return if ( !defined $ifh );

        my $contents = do { local $/; <$ifh> };
        $ifh->close;

        return eval $contents;
    }

    sub freeze {
        my ( $self, $filename, $ref ) = @_;

        my $ofh = IO::File->new( $filename, '>' );
        croak "Failed to open output file: $!" if ( !defined $ofh );

        print $ofh Dumper($ref);
        $ofh->close;
    }

}

package main;

my $app = MyTemplateScript->new();    # TEMPLATE change
exit $app->run(@ARGV);

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

