#!/usr/bin/perl
# Built from perl.t template
# purpose: quickly store and retrieve small pieces of information

#    Copyright (C) 2015  David M. Bradford
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your u_option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see https://www.gnu.org/licenses/gpl.txt
#
#    The author, David M. Bradford, can be contacted at:
#    davembradford@gmail.com

# TODO

# MAYBE TODO
# * implement tags
# * implement delete entry
# * implement edit individual entry
# * allow input from file

# DONE
# * implement "library" like notebook in evernote (sort of)
# * -1 and -2 switch for which note file to use
# * Implement word option
# * allow for title search

use 5.16.0;
use warnings FATAL => 'all';

use File::Basename;
use Getopt::Long;

our $VERSION = '0.9.7';

my $PROG = basename($0);
my $ERR_EXIT = 2;

sub usage_top {
    warn "Usage: $PROG [OPTION]... PATTERN..\n";
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
quickly store and retrieve small pieces of information
Example: $PROG -2w lawnmower

  -h, --help            display this help text and exit
  -v, --version         display version information and exit
  -l, --library=LIBRARY Search a specific library
  -1, --1               use notefile #1
  -2, --2               use notefile #2
  -a, --add             add a note
  -e, --edit            edit the notes file
  -i, --interactive     enter search terms from a prompt
  -t, --title           search title only
  -V, --Verbose         show additional information about entries matched / not
                        matched
  -w, --word            only find if PATTERN is a word

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

my $h                = 0;
my $help             = 0;
my $version          = 0;
my $library          = '';
my $one              = 0;
my $two              = 0;
my $add              = 0;
my $edit             = 0;
my $interactive      = 0;
my $title            = 0;
my $Verbose          = 0;
my $word             = 0;


Getopt::Long::Configure ("bundling");

my %options = (
    "help"           => \$help,
    "version"        => \$version,
    "library=s"      => \$library,
    "1"              => \$one,
    "2"              => \$two,
    "add"            => \$add,
    "edit"           => \$edit,
    "interactive"    => \$interactive,
    "title"          => \$title,
    "Verbose"        => \$Verbose,
    "word"           => \$word,

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


use strict;
use warnings FATAL => 'all';

use Data::Dumper;
use File::Basename;
use Getopt::Long;
use IO::File;

my $nf = $ENV{NOTEFILES} || "$ENV{HOME}/info/notes.txt";
my @notefiles = split ':', $nf;

my $threshold = 10;

my $separator = "%%%\n";

@notefiles = $notefiles[0] if $one;
@notefiles = $notefiles[1] if $two;

sub edit_notes {
    my $editor = $ENV{EDITOR} || 'vim';
    my $paths = join(' ', @notefiles);
    system("$editor $paths");
}

my @output_lines;
sub output {
    my $output_line = join('',@_);
    push @output_lines, $output_line;
}

sub search_note {
    my (@patterns) = @_;

    if ( $word ) {
        for (@patterns) {
            $_ = "\\b$_\\b";
        }
    }

    if ( $title ) {
        for (@patterns) {
            $_ = "^[^\\x0a\\x0d]*$_";
        }
    }

    my @notes;
    for my $file (@notefiles) {
        my $ifh = IO::File->new( $file, '<' );
        die if ( !defined $ifh );

        my $contents = do { local $/; <$ifh> };

        $ifh->close;
        push @notes, split(/^$separator/m, $contents);
    }

    my %matches;
    my %excluded;
    my $total_excluded=0;
    OUTER: for (@notes) {
        for my $pattern (@patterns) {
            next OUTER unless /$pattern/i;
        }
        if ( /^[^\x0a\x0d]*library:(\S*)/ ) {
            my $note_lib = $1;
            if ( $library ne $note_lib ) {
                $excluded{$note_lib}++;
                $total_excluded++;
                next OUTER;
            }
        }
        else {
            if ( $library ) {
                $excluded{no_library}++;
                $total_excluded++;
                next OUTER;
            }
        }
        s/^/  /mg;
        $matches{$_}++;
    }
    my $output_separator = "\n" . '+' . '=' x 78 . "\n|";
    my $title_separator  = "\n" . '+' . '-' x 68 . "\n";
    my $gpg_file = "$ENV{HOME}/.note.gpg";
    if (%matches) {
        my $total_matches = scalar keys %matches;
        if ( $total_matches > $threshold ) {
            print "Found $total_matches matches. Continue (Y/n) ? ";
            my $junk = <STDIN>;
            chomp $junk;
            if ( $junk =~ /n/i ) {
                exit;
            }
        }
        my $content;
        for my $match (keys %matches) {
            my @lines = split "\n", $match;
            my $title = shift @lines;
            $title =~ s/^\s*//;
            my $body = join "\n", @lines;
            $body =~ s/\s*$//s;
            output $output_separator,
                   " $title",
                   $title_separator;
            $content='';
            if ($body =~ s/[[]<(.*)>[]]/$1/sg) {
                $content = $1;
                print "content {$content}\n";
            }
            if ($body =~ /BEGIN PGP MESSAGE.*END PGP MESSAGE/s) {
                my $ofh = IO::File->new($gpg_file, '>');
                die if (!defined $ofh);
                $body =~ s/^ *//mg;
                print $ofh $body;
                $ofh->close;
                if ( -r $gpg_file ) {
                    system("gpg --decrypt $gpg_file && rm $gpg_file");
                }
            }
            else {
                output $body, "\n";
                my $cfh = IO::File->new('/dev/clipboard', '>');
                if (defined $cfh) {
                    my $to_copy = $content || $body;
                    print $cfh $to_copy;
                    $cfh->close;
                }
            }
        }
        output "\n";
    }
    else {
        output "No match.\n";
    }
    if ( $Verbose && $total_excluded ) {
        my $entries = $total_excluded == 1 ? 'entry' : 'entries';
        my $were    = $total_excluded == 1 ? 'was'   : 'were';
        output "($total_excluded $entries $were excluded in other libraries- ";
        for ( keys %excluded ) {
            output "$_:$excluded{$_} ";
        }
        output ")\n";
    }
    open O, '| less -FX' or die;
    print O @output_lines;
    close O;

    return;
}

sub add_note {
    my $note;
    while (my $input_line = <STDIN>) {
        $note .= $input_line;
    }

    my $ofh = IO::File->new( $notefiles[0], '>>' );
    die if ( !defined $ofh );

    print $ofh "${separator}${note}\n";
    $ofh->close;
    warn "*** 1 note added to $notefiles[0]\n";

    return;
}

sub router {
    my (@patterns) = @_;

    if    ($add)      { return add_note()               }
    elsif ($edit)     { return edit_notes()             }
    elsif (@patterns) { return search_note( @patterns ) }
    else              { return do_short_usage()         }
}

sub interactive {
    my (@patterns) = @_;

    while(1) {
        print "notes> ";
        my $input = <STDIN>;
        chomp $input;
        @patterns = split /\s+/, $input;
        router(@patterns);
        @output_lines = ();
    }
}

sub main {
    my (@patterns) = @_;

    if ( $interactive ) {
        return interactive(@patterns);
    }
    return router(@patterns);

    die "Boom."; # This code should never be reached
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

