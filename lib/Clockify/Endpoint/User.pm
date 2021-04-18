use v5.32;

package Clockify::Endpoint::User;

use warnings;
use experimental qw(signatures);

use Carp qw(carp croak);

our $VERSION = '0.001_01';

use Clockify::UserAgent;
use Mojo::Util qw(dumper);

=encoding utf8

=head1 NAME

Clockify::Endpoint::User -

=head1 SYNOPSIS


=head1 DESCRIPTION

=cut

sub new ( $class, $json ) {
	bless { _json => $json, _extras => {} }, $class;
	}

sub current ( $class ) { _fetch() }

=head2

=over 4

=item * active_workspace

=item * active_workspace_id

=item * default_workspace

=item * default_workspace_id

=item * email

=item * id

=item * name

=cut

sub _extras { shift->{_extras} }

sub _fetch  {
	state $method   = 'get';
	state $endpoint = '/user';

	my $json = request( $method, $endpoint );
	}

sub _json   { shift->{_json}  }

sub _fetch_workspaces ( $self ) {
	state $rc = require Clockify::Endpoint::Workspace;
	my @workspaces = Clockify::Endpoint::Workspace->for_current_user;
say STDERR "Found " . @workspaces . " workspaces";

	$self->_extras->{workspaces}  = \@workspaces;

	while( my( $i, $workspace ) = each $self->_extras->{workspaces}->@* ) {
		if( $workspace->id eq $self->default_workspace_id ) {
			$self->_extras->{default_workspace} = $self->_extras->{workspaces}[$i];
			}
		if( $workspace->id eq $self->active_workspace_id ) {
			$self->_extras->{active_workspace} = $self->_extras->{workspaces}[$i];
			}
		}
	}

sub active_workspace     { shift->_extras->{active_workspace} }
sub active_workspace_id  { shift->_json->{activeWorkspace}    }

sub default_workspace    { shift->_extras->{defualt_workspace} }
sub default_workspace_id { shift->_json->{defaultWorkspace}    }

sub email                { shift->_json->{email} }
sub id                   { shift->_json->{id}    }

sub is_error             { 0 }
sub is_success           { 1 }

sub name                 { shift->_json->{name}  }

sub time_entries ( $self, $workspace = undef ) {
	state $rc = require Clockify::Endpoint::TimeEntry;
	$workspace //= $self->active_workspace_id;
	say STDERR "Workspace $workspace";
	Clockify::Endpoint::TimeEntry->get( $workspace, $self );
	}

sub time_entries_between ( $self, $workspace = undef, $start_date = undef, $end_date = undef ) {
	state $rc = require Clockify::Endpoint::TimeEntry;
	$workspace //= $self->active_workspace_id;
	say STDERR "Workspace $workspace";
	Clockify::Endpoint::TimeEntry->get( $workspace, $self );
	}

sub workspaces ( $self ) {
	$self->_fetch_workspaces unless keys $self->_extras->{workspaces}->%*;
	$self->_extras->{workspaces};
	}

=back

=head2 Do things

=over 4

=item * add_time_entry( WORKSPACE, PROJECT, HASH )

Hash has keys for:

	start
	end
	description

=cut

sub add_time_entry ( $self, $hash ) {
	state $rc = require Clockify::Endpoint::TimeEntry;

	$hash->{project}   //= $ENV{CLOCKIFY_PROJECT_ID};
	$hash->{user}      //= $self->id;
	$hash->{workspace} //= $self->active_workspace_id;

	Clockify::Endpoint::TimeEntry->add( $hash );
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

__END__
bless( {
  "activeWorkspace" => "5b634056b0798703574fe8f5",
  "defaultWorkspace" => "5b634056b0798703574fe8f5",
  "email" => "bfoy\@merit.edu",
  "id" => "6001dcc2f05da620e8222f5d",
  "memberships" => [
    {
      "costRate" => undef,
      "hourlyRate" => undef,
      "membershipStatus" => "ACTIVE",
      "membershipType" => "WORKSPACE",
      "targetId" => "5b634056b0798703574fe8f5",
      "userId" => "6001dcc2f05da620e8222f5d"
    },
    {
      "costRate" => undef,
      "hourlyRate" => undef,
      "membershipStatus" => "ACTIVE",
      "membershipType" => "USERGROUP",
      "targetId" => "5bc4e144b079874554f18b57",
      "userId" => "6001dcc2f05da620e8222f5d"
    }
  ],
  "name" => "brian d foy",
  "profilePicture" => "https://img.clockify.me/no-user-image.png",
  "settings" => {
    "collapseAllProjectLists" => bless( do{\(my $o = 0)}, 'JSON::PP::Boolean' ),
    "dashboardPinToTop" => $VAR1->{"settings"}{"collapseAllProjectLists"},
    "dashboardSelection" => "ME",
    "dashboardViewType" => "PROJECT",
    "dateFormat" => "MM/DD/YYYY",
    "groupSimilarEntriesDisabled" => $VAR1->{"settings"}{"collapseAllProjectLists"},
    "isCompactViewOn" => bless( do{\(my $o = 1)}, 'JSON::PP::Boolean' ),
    "longRunning" => $VAR1->{"settings"}{"collapseAllProjectLists"},
    "myStartOfDay" => "09:00",
    "projectListCollapse" => 50,
    "projectPickerTaskFilter" => $VAR1->{"settings"}{"isCompactViewOn"},
    "sendNewsletter" => $VAR1->{"settings"}{"collapseAllProjectLists"},
    "summaryReportSettings" => {
      "group" => "Project",
      "subgroup" => "Time Entry"
    },
    "timeFormat" => "HOUR12",
    "timeTrackingManual" => $VAR1->{"settings"}{"isCompactViewOn"},
    "timeZone" => "America/New_York",
    "weekStart" => "MONDAY",
    "weeklyUpdates" => $VAR1->{"settings"}{"collapseAllProjectLists"}
  },
  "status" => "ACTIVE"
}, 'Clockify::Endpoint::User' )
