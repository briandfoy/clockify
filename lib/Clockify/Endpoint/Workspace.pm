use v5.32;

package Clockify::Endpoint::Workspace;

use warnings;
use experimental qw(signatures);

use Carp qw(carp croak);

use Clockify::UserAgent;
use Mojo::Util qw(dumper);

our $VERSION = '0.001_01';

=encoding utf8

=head1 NAME

Clockify::Endpoint::Workspace -

=head1 SYNOPSIS


=head1 DESCRIPTION

=cut

sub by_id ( $class, $workspace_id  ) {
	my $workspace = grep { $_->id eq $workspace_id } $class->for_current_user;

	unless( defined $workspace ) {
		carp "No workspace with ID <$workspace_id>";
		}

	return $workspace;
	}

sub new ( $class, $endpoint_args, $json ) {
	bless {
		_endpoint_args => $endpoint_args,
		_json          => $json,
		_extras        => {},
		}, $class;
	}

sub _extras { shift->{_extras} }

sub _json   { shift->{_json}  }

sub is_error             { 0 }
sub is_success           { 1 }

sub for_current_user ( $class ) {
	state $method = 'get';
	state $endpoint = '/workspaces';

	my $set = request( $method, $endpoint );
	my @workspaces = map { $class->new( [], $_ ) } $set->_json->@*;
	}

sub hourly_rate { $_[0]->_json->{hourlyRate}{amount} / 100 }
sub id          { $_[0]->_json->{id} }
sub name        { $_[0]->_json->{name} }

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/briandfoy/clockify

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2021-2025, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;

__END__
bless( [
  {
    "featureSubscriptionType" => undef,
    "hourlyRate" => {
      "amount" => 12500,
      "currency" => "USD"
    },
    "id" => "5b634056b0798703574fe8f5",
    "imageUrl" => "https://img.clockify.me/2018-10-11T18%3A16%3A31.901Zmerit-logo.png",
    "memberships" => [
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5b634053b0798703574fe8f0"
      },
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5bc4bb85b079874554f12d44"
      },
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5bd86cd2b079871a22accbf9"
      },
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5bd8687ab079871a22acbaf1"
      },
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5c0949e7b0798764304a376e"
      },
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "PENDING",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5c094a6cb0798764304a39d4"
      },
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5d7b8ac6423b73357fa0942a"
      },
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5ef23c7c77cfae64623e7404"
      },
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "5ef2429643162e08f73b44a4"
      },
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
        "membershipType" => "WORKSPACE",
        "targetId" => "5b634056b0798703574fe8f5",
        "userId" => "603e46e94d3e4f478f2ac4a4"
      }
    ],
    "name" => "Merit Network, Inc.",
    "workspaceSettings" => {
      "adminOnlyPages" => [],
      "automaticLock" => undef,
      "canSeeTimeSheet" => bless( do{\(my $o = 1)}, 'JSON::PP::Boolean' ),
      "canSeeTracker" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "defaultBillableProjects" => bless( do{\(my $o = 0)}, 'JSON::PP::Boolean' ),
      "forceDescription" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "forceProjects" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "forceTags" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "forceTasks" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "isProjectPublicByDefault" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "lockTimeEntries" => undef,
      "onlyAdminsCreateProject" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "onlyAdminsCreateTag" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "onlyAdminsCreateTask" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "onlyAdminsSeeAllTimeEntries" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "onlyAdminsSeeBillableRates" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "onlyAdminsSeeDashboard" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "onlyAdminsSeePublicProjectsEntries" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "projectFavorites" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "projectGroupingLabel" => "client",
      "projectPickerSpecialFilter" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "round" => {
        "minutes" => 15,
        "round" => "Round to nearest"
      },
      "timeRoundingInReports" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "timeTrackingMode" => "DEFAULT",
      "trackTimeDownToSecond" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"}
    }
  },
  {
    "featureSubscriptionType" => undef,
    "hourlyRate" => {
      "amount" => 0,
      "currency" => "USD"
    },
    "id" => "6001de4a1d70d54869bc8bd6",
    "imageUrl" => "",
    "memberships" => [
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "WORKSPACE",
        "targetId" => "6001de4a1d70d54869bc8bd6",
        "userId" => "6001dcc2f05da620e8222f5d"
      }
    ],
    "name" => "brian d foy's workspace",
    "workspaceSettings" => {
      "adminOnlyPages" => [],
      "automaticLock" => undef,
      "canSeeTimeSheet" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "canSeeTracker" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "defaultBillableProjects" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "forceDescription" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "forceProjects" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "forceTags" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "forceTasks" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "isProjectPublicByDefault" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "lockTimeEntries" => undef,
      "onlyAdminsCreateProject" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "onlyAdminsCreateTag" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "onlyAdminsCreateTask" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "onlyAdminsSeeAllTimeEntries" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "onlyAdminsSeeBillableRates" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "onlyAdminsSeeDashboard" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "onlyAdminsSeePublicProjectsEntries" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "projectFavorites" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"},
      "projectGroupingLabel" => "client",
      "projectPickerSpecialFilter" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "round" => {
        "minutes" => 15,
        "round" => "Round to nearest"
      },
      "timeRoundingInReports" => $VAR1->[0]{"workspaceSettings"}{"defaultBillableProjects"},
      "timeTrackingMode" => "DEFAULT",
      "trackTimeDownToSecond" => $VAR1->[0]{"workspaceSettings"}{"canSeeTimeSheet"}
    }
  }
], 'Clockify::Endpoint::Workspace' )
