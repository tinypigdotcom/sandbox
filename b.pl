#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

use Try::Tiny;

sub complex_function {
    my $input;
    my $option;
    my $user_admin_level;
    if ($input) {
        if ($option eq 'update_item') {
            if ($user_admin_level >= 1) {
                my $error = '';
                try {
                    perform_item_update();
                } catch {
                    $error = $_;
                };
                if ($error) {
                    warn "Error $error occurred";
                }
                else {
                    print "Item successfully updated.\n";
                }
            }
            else {
                warn "Insufficient privileges!";
            }
        }
    }
    else {
        print "No input!\n";
    }
}


sub main {
    my @argv = @_;
    complex_function();
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

