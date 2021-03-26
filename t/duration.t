use v5.32;
use warnings;

use Test::More;
use Time::Piece;

my $class = 'Clockify::Duration';

subtest setup => sub {
	use_ok( $class ) or BAILOUT( "$class did not compile: $@" );
	};

subtest new => sub {
	can_ok( $class, 'new' );

	my $d = $class->new( 5, 37, 1 );
	isa_ok( $d, $class );

	can_ok( $class, qw(hours minutes seconds format) );
	is( $d->hours,    5, 'hours is right' );
	is( $d->minutes, 37, 'minutes is right' );
	is( $d->seconds,  1, 'seconds is right' );

	is( $d->format, 'PT5H37M1S', 'Format is right' );
	};

subtest new_fractional => sub {
	can_ok( $class, 'new' );

	my $d = $class->new( 5.5, 17.25, 1 );
	isa_ok( $d, $class );

	can_ok( $class, qw(hours minutes seconds format) );
	is( $d->hours,    5, 'hours is right' );
	is( $d->minutes, 47, 'minutes is right' );
	is( $d->seconds, 16, 'seconds is right' );

	is( $d->format, 'PT5H47M16S', 'Format is right' );
	};

subtest parse => sub {
	my $duration = 'PT7H41M19S';
	can_ok( $class, 'parse' );

	my $d = $class->parse( $duration );
	isa_ok( $d, $class );

	can_ok( $class, qw(hours minutes seconds duration) );
	is( $d->hours,    7, 'hours is right' );
	is( $d->minutes, 41, 'minutes is right' );
	is( $d->seconds, 19, 'seconds is right' );

	is( $d->duration, $duration, 'original string is right' );
	};

subtest format => sub {
	my $duration = 'PT5H23M47S';

	my $d = $class->parse( $duration );
	isa_ok( $d, $class );

	is( $d->hours,    5, 'hours is right' );
	is( $d->minutes, 23, 'minutes is right' );
	is( $d->seconds, 47, 'seconds is right' );

	is( $d->duration, $duration, 'original string is right' );

	is( $d->format, $duration, 'Round trip is right' );
	};

done_testing();
