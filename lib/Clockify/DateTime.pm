use v5.32;

package Clockify::DateTime;

use warnings;
use experimental qw(signatures);

our $VERSION = '0.001_01';

use warnings::register;

use Carp qw(croak);
use POSIX;
use Time::Piece qw();

=encoding utf8

=head1 NAME

Clockify::DateTime - handle dates

=head1 SYNOPSIS

	use Clockify::DateTime;

	my $dt = Clockify::DateTime->parse( $string );

	my $string = Clockify::DateTime->format( $dt );

=head1 DESCRIPTION

=over 4

=item CLASS->parse( STRING )

=item CLASS->parse_local( STRING [, TZ_VALUE ] )

Parse the datetime format used in the API responses and return a
L<Time::Piece> object. An input date looks like C<2021-03-23T13:00:00Z>.
Note that you can use local times in requests, but the responses
always return zulu time.

With C<parse>, you get a time in UTC.

With C<parse_local> and a valid time zone (such as C<America/New_York>),
returns a local time. You can pass the time zone as the second argument
or set it in the C<$ENV{TZ}> variable.

=cut

sub parse ( $class, $datetime ) {
	state $format = '%Y-%m-%dT%T %z';
	Time::Piece->strptime( $datetime =~ s/Z\z/ +0000/r, $format );
	}

sub parse_local ( $class, $datetime ) {
	state $format = '%Y-%m-%dT%T %z';

	POSIX::tzset();
	my $t = Time::Piece->new->strptime( $datetime =~ s/Z\z/ +0000/r, $format );
	$t += $t->tzoffset;
	}

=item CLASS->format( TIME_PIECE [, FORMAT] )

=item CLASS->format_local( TIME_PIECE [, FORMAT] )

Format the datetime format used in the API responses and return a
L<Time::Piece> object.

=cut

sub format ( $class, $t, $format = '%Y-%m-%dT%TZ' ) {
	$t->strftime( $format );
	}

sub format_local ( $class, $t, $format = '%Y-%m-%dT%T %z' ) {
	$t->strftime( $format );
	}

=back

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/briandfoy/clockify

=head1 AUTHOR

brian d foy, C<< <brian d foy> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2021, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;
