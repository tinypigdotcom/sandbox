package Roller;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(roll) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );

our $VERSION = '0.01';

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

=head1 NAME

Roller - Perl extension for generating dice rolls from a "dice language"
string such as "3d6+1".

=head1 SYNOPSIS

  use Roller ':all';
  print roll('d20');

=head1 DESCRIPTION

Roller's single function C<roll()> generates dice rolls from a "dice language"
string such as "3d6+1".

=head2 EXPORT

None by default.



=head1 AUTHOR

David M. Bradford, E<lt>davembradford@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by David M. Bradford

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.20.1 or,
at your option, any later version of Perl 5 you may have available.


=cut

