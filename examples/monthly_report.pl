#!perl
use v5.32;
use strict;

use lib qw(lib);
use experimental qw(signatures);

use Clockify;

use Mojo::Util qw(dumper);

my $pivot_day = 15;

my $user = Clockify->current_user;

say "User ID: ", $user->id;
say "Active Workspace ID: ", $user->active_workspace_id;

foreach my $workspace ( $user->workspaces->@* ) {
	say "Workspace ID: ", $workspace->id;
	say "Workspace Name: ", $workspace->name;
	}

my $time_entries = $user->time_entries;

my $total = $time_entries->@*;

foreach my $entry ( reverse $time_entries->@* ) {
	state $count          = 0;
	state $previous_start = undef;
	state $period_total   = 0;

	$count++;

	my $start    = $entry->start_date;
	my $day      = $start->mday;
	my $duration = $entry->duration;

	my $in_same_month = in_same_month( $previous_start, $start );
	my $output;

	my sub summary {
		$output .= sprintf "%20s : %5.2f\n\n", 'Total', $period_total;
		$period_total = 0;
		}

	summary() if ($count != 1) && ! $in_same_month;

	$output .= sprintf "%3s %16s : %5.2f\n",
		$start->wdayname,
		format_date( $start ),
		$duration->{elapsed_hours}
		;

	summary() if $count == $total;

	$previous_start = $start;
	$period_total += $duration->{elapsed_hours};

	print $output;
	}

sub format_date ( $t ) { $t->strftime( '%Y-%m-%d %H:%M' ) }

sub in_same_month ( $previous, $now ) {
	return 0 unless( defined $previous and defined $now );
	my $cross_month = $now->mon == $previous->mon + 1;
	my $same_month  = $now->mon == $previous->mon;

	return
		( $cross_month and $previous->mday > $pivot_day and $now->mday <= $pivot_day )
			||
		( $same_month and
			( $now->mday > $pivot_day and $previous->mday > $pivot_day )
				or
			( $now->mday <= $pivot_day and $previous->mday <= $pivot_day )
		);
	}
