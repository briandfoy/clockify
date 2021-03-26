use v5.32;

package Clockify::Duration;

use warnings;
use experimental qw(signatures);

use Carp qw(carp croak);
use POSIX qw(floor);

our $VERSION = '0.001_01';

=encoding utf8

=head1 NAME

Clockify::Duration - handle Clockify durations
=head1 SYNOPSIS

	use Clockify::Duration;

	my $duration = Clockify::Duration->parse( 'PT...' );

=head1 DESCRIPTION

=over 4

=item can( METHOD )

Returns true if the class can respond to the METHOD.

=item new( HOURS, MINUTES, SECONDS )

Create a new duration object. The HOURS, MINUTES, and SECONDS can be
fractional, but will be converted to the right values so all of them
are whole numbers.

=cut

sub new( $class, $hours, $minutes = 0, $seconds = 0 ) {
	my $elapsed_seconds = $hours * 3600 + $minutes * 60 + $seconds;

	$hours   = floor( $elapsed_seconds / 3600 );
	$elapsed_seconds -= $hours * 3600;

	$minutes = floor( $elapsed_seconds / 60 );

	$seconds = $elapsed_seconds - $minutes * 60;

	my $h = bless {}, $class;

	$h->{duration} = undef;
	$h->{hours}    = $hours   // 0;
	$h->{minutes}  = $minutes // 0;
	$h->{seconds}  = $seconds // 0;

	$h->{elapsed_seconds} = (60*60*$h->hours + 60*$h->minutes + $h->seconds);
	$h->{elapsed_hours} = sprintf "%.2f", $h->elapsed_seconds / 3600;

	$h;
	}

=item parse( STRING )

Parse the Clockify duration format, i.e C<PT3H30M0S>, and return
a duration instance.

=cut

sub parse ( $class, $string ) {
	state $pattern = qr/
		\A
		PT
		(?: (?<hours>   [0-9]+ ) H )?
		(?: (?<minutes> [0-9]+ ) M )?
		(?: (?<seconds> [0-9]+ ) S )?
		\z
		/x;

	if( $string =~ $pattern ) {
		my $h = $class->new( @+{ qw(hours minutes seconds) } );
		$h->{duration} = $string;
		return $h;
		}
	else {
		carp "The string <$string> does not look like a Clockify duration";
		return;
		}
	}


=back

=head2 Instance methods

=over 4

=item * duration

The original duration string, such as "PT3H30M0S".

=item * elapsed_hours

The total elapsed hours for the duration, to two decimal places.

=item * elapsed_seconds

The total elapsed seconds for the duration

=item * format

Return the duration in Clockify's form, such as C<PT1H2M3S>.

=cut

sub format ( $self ) {
	return $self->{duration} if defined $self->{duration};

	$self->{duration} =
		sprintf 'PT%dH%dM%dS',
		map { $self->$_() }
		qw(hours minutes seconds);
	}

=item * hours

The hours portion of the duration

=item * minutes

The minutes portion of the duration

=item * seconds

The seconds portion of the duration

=back

=cut

my %methods;
BEGIN {
%methods = map { $_, 1 } qw(
	duration
	elapsed_hours elapsed_seconds
	hours minutes seconds
	);
}

sub can ( $class, $method ) {
	return 1 if exists $methods{$method};
	$class->SUPER::can( $method );
	}

sub AUTOLOAD ( $self, @args ) {
	state %methods = map { $_, 1 } qw(
		duration
		elapsed_hours elapsed_seconds
		hours minutes seconds
		);

	our $AUTOLOAD;
	my $method = $AUTOLOAD =~ s/.*:://r;
	unless( exists $methods{$method} ) {
		croak "No such method <$method>";
		}

	$self->{$method};
	}

sub DESTROY { 1 }

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
