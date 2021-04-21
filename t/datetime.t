use v5.32;
use warnings;

use Test::More;
use Time::Piece;

my $class = 'Clockify::DateTime';

subtest setup => sub {
	use_ok( $class ) or BAILOUT( "$class did not compile: $@" );
	};

subtest parse => sub {
	my $datetime = '2021-03-23T13:07:19Z';
	ok( defined &parse_datetime );

	my $t = parse_datetime( $datetime );
	is( $t->year, 2021, 'year is right' );
	is( $t->mon,     3, 'month is right' );
	is( $t->mday,   23, 'day is right' );

	is( $t->hour, 13, 'hour is right' );
	is( $t->min,   7, 'min is right' );
	is( $t->sec,  19, 'sec is right' );

	is( $t->tzoffset, 0, 'time zone offset is 0' );
	};

subtest format => sub {
	subtest parse => sub {
		ok( defined &parse_datetime );
		ok( defined &format_datetime );
		local $ENV{TZ};
		my $datetime = '2021-03-23T13:07:19Z';

		my $t = parse_datetime( $datetime );
		my $round_trip = format_datetime( $t );
		is( $round_trip, $datetime, 'Round trip date is the same' );
		};

	subtest parse_local => sub {
		ok( defined &parse_datetime_local );
		ok( defined &format_datetime_local );

		my $datetime = '2021-03-23T13:07:19Z';
		local $ENV{TZ} = 'America/New_York';

		my $t = parse_datetime_local( $datetime );
		is( format_datetime_local( $t ), '2021-03-23T09:07:19 -0400' );
		};

	};

done_testing();
