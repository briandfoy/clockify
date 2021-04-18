#!perl
use v5.32;
use strict;

use lib qw(lib);
use experimental qw(signatures);

use Clockify;

use Mojo::Util qw(dumper);

my $user = Clockify->current_user;

say "User ID: ", $user->id;
say "Active Workspace ID: ", $user->active_workspace_id;

foreach my $workspace ( $user->workspaces->@* ) {
	say "Workspace ID: ", $workspace->id;
	say "Workspace Name: ", $workspace->name;
	}

my $time_entries = $user->time_entries;

my $total = $time_entries->@*;

foreach my $entry ( $time_entries->@* ) {
	state $count          = 0;
	state $previous_week  = 0;
	state $week_total     = 0;

	$count++;

	my $start    = $entry->start_date;
	my $duration = $entry->duration;

	my $output;

	if( ($count != 1) &&  ( $start->week != $previous_week || $count == $total ) ) {
		$output .= sprintf "%20s : %5.2f\n\n", 'Total', $week_total;
		$week_total = 0;
		}

	$output .= sprintf "%3s %16s : %5.2f\n",
		$start->wdayname,
		format_date( $start ),
		$duration->{elapsed_hours}
		;

	$previous_week = $start->week;
	$week_total += $duration->{elapsed_hours};

	print $output;
	}

sub format_date ( $t ) { $t->strftime( '%Y-%m-%d %H:%M' ) }
