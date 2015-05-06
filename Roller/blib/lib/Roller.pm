package Roller;

use 5.014002;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(roll) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );

our $VERSION = '0.01';

# Preloaded methods go here.
sub roll {
    my $input = shift;
    return unless $input =~ /(\d*)d(\d+)\s*(\D?)\s*(\d*)/;
    my $num = $1 || 1;
    my ($die,$plus,$end) = ($2,$3,$4);
    my $total = 0;
    my @dice;
    push @dice, int(rand($die))+1 for ( 1..$num );
    if ( $plus eq 'b' ) {
        $end =  $num if $end > $num;
        @dice = sort { $b <=> $a } @dice;
        $#dice = $end-1;
    }
    $total += $_ for @dice;
    if    ( $plus eq '+' ) { $total += $end }
    elsif ( $plus eq '-' ) { $total -= $end }
    elsif ( $plus eq '*' ) { $total *= $end }
    elsif ( $plus eq '/' ) { $total /= $end }
    return $total;
}

1;
__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Roller - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Roller;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Roller, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

U-DOGGY\dave, E<lt>dave@x-ray.atE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by U-DOGGY\dave

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

