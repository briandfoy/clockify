#!perl
use v5.32;
use strict;

use lib qw(lib);
use experimental qw(signatures);

use Clockify;
use Clockify::DateTime;

use Mojo::Util qw(dumper);
use Time::Piece;

my $user = Clockify->current_user;

say "User ID: ", $user->id;
say "Active Workspace ID: ", $user->active_workspace_id;

my $start_date = week_start();
say "\nWeek start: $start_date\n";

my $time_entries = $user->time_entries_this_week;

my $total = $time_entries->@*;

my $week_total = 0;
foreach my $entry ( reverse $time_entries->@* ) {
	my $duration = $entry->duration;

	$week_total += $duration->{elapsed_hours};

	printf "%16s : %5.2f\n",
		$entry->start_date_local->strftime( '%a %b %d %H:%M' ),
		$duration->{elapsed_hours}
		;
	}

printf "%16s : %5.2f\n", 'Total', $week_total;

