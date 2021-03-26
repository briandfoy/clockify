use Test::More;

my $class = 'Clockify::DateTime';


subtest setup => sub {
	use_ok $class;
	};

subtest parse => sub {
	my $datetime = '2021-03-23T13:07:19Z';

	my $t = $class->parse( $datetime );
	is( $t->year, 2021, 'year is right' );
	is( $t->mon,     3, 'month is right' );
	is( $t->mday,   23, 'day is right' );

	is( $t->hour, 13, 'hour is right' );
	is( $t->min,   7, 'min is right' );
	is( $t->sec,  19, 'sec is right' );

	is( $t->tzoffset, 0, 'time zone offset is 0' );
	};

subtest format => sub {
	my $datetime = '2021-03-23T13:07:19Z';

	my $t = $class->parse( $datetime );
	my $round_trip = $class->format( $t );
	is( $round_trip, $datetime, 'Round trip date is the same' );
	};

done_testing();
