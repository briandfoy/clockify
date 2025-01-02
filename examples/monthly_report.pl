#!perl
use v5.32;
use strict;

use lib qw(lib);
use experimental qw(signatures);

use Clockify;

use Mojo::Util qw(dumper);

my $pivot_day = 14;

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
	state %project_totals = ();

	$count++;

	my $start    = $entry->start_date;
	my $day      = $start->mday;
	my $duration = $entry->duration;

	my $in_same_month = in_same_month( $previous_start, $start );
	my $output;

	my sub summary {
		$output .= '-' x 28 . "\n";
		foreach my $project ( sort keys %project_totals ) {
			$output	.= sprintf "    %16s : %5.2f\n", $project, $project_totals{$project};
			}

		$output .= sprintf "%20s : %5.2f\n", 'Total', $period_total;

		$output .= "\n";

		%project_totals = ();
		$period_total = 0;
		}

	summary() if ($count != 1) && ! $in_same_month;

	$previous_start = $start;
	$period_total += $duration->{elapsed_hours};

	$project_totals{$entry->project->name} += $duration->{elapsed_hours};

	$output .= sprintf "%3s %16s : %5.2f - %5.2f\n",
		$start->wdayname,
		format_date( $start ),
		$duration->{elapsed_hours},
	$project_totals{$entry->project->name}
		;

	summary() if $count == $total;

	print $output;
	}

sub format_date ( $t ) { $t->strftime( '%Y-%m-%d %H:%M' ) }

sub in_same_month ( $previous, $now ) {
	return 0 unless( defined $previous and defined $now );
	return $now->mon == $previous->mon;
	}
