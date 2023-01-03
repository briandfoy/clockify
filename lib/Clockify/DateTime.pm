use v5.32;

package Clockify::DateTime;

use warnings;
use experimental qw(signatures);

our $VERSION = '0.001_01';

use warnings::register;

use Carp qw(croak);
use Exporter qw(import);
use POSIX;
use Time::Piece qw();

our @EXPORT = qw(
	format_datetime format_datetime_local
	guess_date guess_datetime guess_time
	now now_to_15
	parse_datetime parse_datetime_local
	round_up_15
	this_day today
	week_start
	);

our %EXPORT_TAGS = (
	all    => \@EXPORT,
	parse  => [ grep /parse\b/,  @EXPORT ],
	format => [ grep /format\b/, @EXPORT ],
	guess  => [ grep /guess\b/,  @EXPORT ],
	);

=encoding utf8

=head1 NAME

Clockify::DateTime - handle dates

=head1 SYNOPSIS

	use Clockify::DateTime;

	my $dt = parse_datetime( $string );

	my $string = format_datetime( $dt );

=head1 DESCRIPTION

=head2 Functions

=over 4

=item format_datetime( TIME_PIECE [, FORMAT] )

=item format_datetime_local( TIME_PIECE [, FORMAT] )

Format the datetime format used in the API responses and return a
L<Time::Piece> object.

=cut

sub format_datetime ( $t, $format = '%Y-%m-%dT%TZ' ) {
	$t->strftime( $format );
	}

sub format_datetime_local ( $t, $format = '%Y-%m-%dT%T %z' ) {
	$t->strftime( $format );
	}

=item guess_date( DATESTR )

Given a string, guess the date by adding the month or year.

	DD      YYYY-MM-DD
    MM-DD   YYYY-MM-DD

=cut

sub guess_date ( $date ) {
	return today() unless length $date;

	return this_day( $date ) if $date =~ m/\A(\d\d?)\z/;

	my( $year, $month, $day );
	if( $date =~ m/\A\d+-\d\d?\z/ ) { # month-day
		my $this_year  = (localtime)[5] + 1900;
		my $this_month = (localtime)[4] + 1;
		( $month, $day ) = split /-/, $date;

		$year = $this_year;
		$year -= 1 if $month > $this_month;
		}
	elsif( $date =~ m/\A\d+-\d+-\d+/ ) {
		( $year, $month, $day ) = split /-/, $date;
		}

	sprintf '%4d-%02d-%02d', $year, $month, $day;
	}

=item guess_datetime

=cut

sub guess_datetime ( $arg = '', $start_date = '' ) {
	$start_date =~ s/T.*//;

	$arg = now_to_15() if $arg eq '.';

	$arg =~ s/://g;
	$arg =~ s|/|-|g;

	my $rc = $arg =~ m/
		\A
		(?:
			(?<date>(?:\d\d?-)?\d\d?)
			T
		)?
		(?<time>
		\d\d(?:\d\d)?
		)
		\z
		/x;

	my $time = $+{time};

	my $date = length $+{date} ? $+{date} : $start_date;

	unless( $date ) {
		my $time_now = join '', map { Time::Piece->new->$_() } qw(hour min);
		say "Date is undefined. Time is $time";
		if( $time > $time_now + 15) {
			say "Choosing yesterday";
			$date = yesterday();
			}
		else {
			say "Choosing today";
			$date = today();
			}
		}

	my $dt = join 'T', my $date_guess = guess_date( $date ), my $guess_time = guess_time( $time );
	my $ztime = format_datetime( parse_datetime_local( $dt ) );

	( $date_guess, $guess_time, $ztime );
	}

=item guess_time( TIMESTR )

Given a string, make it into a 24-hour time string with a colon
separating the hours and minutes. This is suitable for an ISO 8601
date.

Examples:

	17      17:00
	1730    17:30
    .       current time rounded to nearest 15 minutes

=cut

sub guess_time ( $time ) {
	$time = now_to_15() if $time eq '.';
	$time .= ':00' if length $time == 2;

	croak( "Bad time <$time>" ) unless $time =~ m/\A
		( [01][0-9] | [2][0-3] )
		:?
		( [0-5][0-9] )?
		/xn;

	substr $time, 2, 0, ':' unless $time =~ m/\A\d\d:\d\d\z/;
	$time;
	}

=item month_start

Return the datetime for the local start of the month, in UTC.

=cut

sub month_start () {
	my $today = Time::Piece->new;
	format_datetime( $today->truncate( to => 'month' ) + $today->tzoffset );
	}

=item now

The current date time.

=cut

sub now () {
	datetime_format(
		split /-/, today(),
		(localtime)[2,1],
		);
	}

=item now_to_15

The current datetime, rounded to nearest 15 minutes.

=cut

sub now_to_15 () {
	round_up_15( sprintf '%02d%02d', (localtime)[2], (localtime)[1] );
	}

=item parse_datetime( STRING )

=item parse_datetime_local( STRING [, TZ_VALUE ] )

Parse the datetime format used in the API responses and return a
L<Time::Piece> object. An input date looks like C<2021-03-23T13:00:00Z>.
Note that you can use local times in requests, but the responses
always return zulu time.

With C<parse>, you get a time in UTC.

With C<parse_local> and a valid time zone (such as C<America/New_York>),
returns a local time. You can pass the time zone as the second argument
or set it in the C<$ENV{TZ}> variable.

=cut

sub parse_datetime ( $datetime ) {
	state $format = '%Y-%m-%dT%T %z';
	Time::Piece->strptime( $datetime =~ s/Z\z/ +0000/r, $format );
	}

sub parse_datetime_local ( $datetime ) {
	state $format = '%Y-%m-%dT%T %z';

	POSIX::tzset();
	my $t = Time::Piece->new->strptime( $datetime =~ s/Z\z/ +0000/r, $format );
	$t -= $t->tzoffset;
	}

=item round_up_15( TIMESTR )

=cut

sub round_up_15 ( $n ) {
	use POSIX qw(ceil);
	my( $hours, $m ) = $n =~ /\A(\d\d)(\d\d)\z/;

	my( $hours_offset, $new_n ) = do {
		   if( $m > 50 ) { 1,  0 }
		elsif( $m > 35 ) { 0, 45 }
		elsif( $m > 20 ) { 0, 30 }
		elsif( $m > 10 ) { 0, 15 }
		else             { 0,  0 }
		};

	say STDERR "n <$n> m <$m> hours_offset <$hours_offset> new_n <$new_n>";

	my $time = sprintf "%02d%02d", ($hours + $hours_offset) % 24, $new_n;
	}

=item this_day( DAY )

Given a month day, add the current year and month to it. If the date
is greater than the current date, it assumes it is from last month.

Returns the date in YYYY-MM-DD format.

=cut

sub this_day ( $day ) {
	my $month = (localtime)[4] + 1;
	my $year  = (localtime)[5] + 1900;

	$month -= 1 if $day > (localtime)[3];
	if( $month == 0 ) {
		$month = 12;
		$year -=  1;
		};

	sprintf '%4d-%02d-%02d', $year, $month, $day;
	}

=item today

Today's date, in YYYY-MM-DD

=cut

sub today () { Time::Piece->new->strftime( '%Y-%m-%d' ) }

=item week_start

Return the datetime for the local start of the week, in UTC.

=cut

sub week_start () {
	my $today = Time::Piece->new;

	unless( $today->wday == 0 ) {
		$today = $today - ( $today->wday - 1 ) * 86400;
		}

	format_datetime($today->truncate( to => 'day' ) + $today->tzoffset );
	}

=item yesterday

Yesterday's date, in YYYY-MM-DD

=cut

sub yesterday () { (Time::Piece->new - 86_400)->strftime( '%Y-%m-%d' ) }

=back

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/briandfoy/clockify

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2021-2023, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;
