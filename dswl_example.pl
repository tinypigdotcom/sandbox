#!/usr/bin/perl

use strict;
use warnings;

use Devel::StackTrace::WithLexicals;

sub foo {
    my $abc = 1234;
    bar();
    print "$abc\n";    # prints 1235
}

sub bar {
    my $trace = Devel::StackTrace::WithLexicals->new(
        unsafe_ref_capture => 1 # warning: can cause memory leak
    );
    while ( my $frame = $trace->next_frame() ) {
        my $yy = $frame->lexical('$abc');
        ${$yy}++ if ref $yy eq 'SCALAR';
    }
}

foo();

