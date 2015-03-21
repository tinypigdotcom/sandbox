#!/usr/bin/perl

use strict;
use warnings;

use Try::Tiny;

sub perform_item_update {
    die "Not implemented";
}

sub complex_function {
    my ( $input, $option, $user_admin_level ) = @_;
    if(1) {
    if(1) {
    if ($input) {
        if ( $option eq 'update_item' ) {
            if ( $user_admin_level >= 1 ) {
                my $error = '';
                try {
                    perform_item_update();
                }
                catch {
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
        else {
            warn "No such option.";
        }
    }
    else {
        print "No input!\n";
    }
    }
    }
}

sub main {
    my @argv             = @_;
    my $input            = 'ca';
    my $option           = 'update_item';
    my $user_admin_level = 1;
    complex_function( $input, $option, $user_admin_level );
    return;
}

my $rc = ( main(@ARGV) || 0 );

exit $rc;

