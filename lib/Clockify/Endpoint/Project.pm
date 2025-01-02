use v5.32;

package Clockify::Endpoint::Project;

use warnings;
use experimental qw(signatures);

use Carp qw(carp croak);

our $VERSION = '0.001_02';

use Clockify::UserAgent;

=encoding utf8

=head1 NAME

Clockify::Endpoint::Project - The basic Project object

=head1 SYNOPSIS


=head1 DESCRIPTION

=over 4

=cut

sub _extras { shift->{_extras} }

sub _json   { $_[0]->{_json}  }

=item * all

=cut

use Mojo::Util qw(dumper);

sub all ( $class, $workspace_id ) {
	state $method   = 'get';
	state $endpoint = '/workspaces/{workspaceId}/projects';

	my $endpoint_args = [ $workspace_id ];

	my @projects;
	my $page = 1;
	my $page_size = 5000; # max defined in API

	while( 1 ) {
		my $form = { page => $page, 'page-size' => $page_size };
		my $projects = request( $method, $endpoint, $endpoint_args, form => $form );
		push @projects, map { $class->new( $endpoint_args, $_ ) } $projects->{_json}->@*;
		last if $projects->{_json}->@* < $page_size;
		$page++;
		}

	\@projects;
	}

=item * get

=cut

sub get ( $class, $workspace_id, $project_id ) {
	state $method   = 'get';
	state $endpoint = '/workspaces/{workspaceId}/projects/{projectId}';
	state $memo     = ();

	my $form = {};
	my $endpoint_args = [ $workspace_id, $project_id ];
	request( $method, $endpoint, $endpoint_args, form => $form );
	}

=item * new

=cut

sub new ( $class, $endpoint_args, $json ) {
	bless { _endpoint_args => $endpoint_args, _json => $json, _extras => {} }, $class;
	}

=back

=head3

=over 4

=item * id

=item * name

=item * workspace_id

=cut

sub id           { $_[0]->_json->{id}          }

sub name         { $_[0]->_json->{name}        }

sub workspace_id { $_[0]->_json->{workspaceId} }

=item * tasks

Return a list of Tasks objects for the project. If the project has no tags,
this returns the empty list.

=cut

sub tasks ( $self ) {
	state $rc = require Clockify::Endpoint::Task;
	say "tasks: workspace_id <" . $self->workspace_id . ">";
	say "tasks: id <" . $self->id . ">";
	say "Tasks object: ", dumper( $self );

	Clockify::Endpoint::Task->all(
		$self->workspace_id,
		$self->id,
		);
	}

=back

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
  {
    "archived" => bless( do{\(my $o = 0)}, 'JSON::PP::Boolean' ),
    "billable" => $VAR1->[0]{"archived"},
    "budgetEstimate" => undef,
    "clientId" => "",
    "clientName" => "",
    "color" => "#4CAF50",
    "costRate" => undef,
    "duration" => "PT7H50M45S",
    "estimate" => {
      "estimate" => "PT0S",
      "type" => "AUTO"
    },
    "hourlyRate" => {
      "amount" => 0,
      "currency" => "USD"
    },
    "id" => "6023fc1ec804cc7e0bbc9a17",
    "memberships" => [
      {
        "costRate" => undef,
        "hourlyRate" => undef,
        "membershipStatus" => "ACTIVE",
        "membershipType" => "PROJECT",
        "targetId" => "6023fc1ec804cc7e0bbc9a17",
        "userId" => "5ef2429643162e08f73b44a4"
      }
    ],
    "name" => "3-GIS Implementation",
    "note" => "",
    "public" => bless( do{\(my $o = 1)}, 'JSON::PP::Boolean' ),
    "template" => $VAR1->[0]{"archived"},
    "timeEstimate" => {
      "active" => $VAR1->[0]{"archived"},
      "estimate" => "PT0S",
      "resetOption" => undef,
      "type" => "AUTO"
    },
    "workspaceId" => "5b634056b0798703574fe8f5"
  },
