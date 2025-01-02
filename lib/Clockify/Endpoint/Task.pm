use v5.32;
use strict;

package Clockify::Endpoint::Task;

use experimental qw(signatures);

use Carp qw(carp croak);

our $VERSION = '0.001_01';

use Clockify::UserAgent;

=encoding utf8

=head1 NAME

Clockify::Endpoint::Task - The basic Task object

=head1 SYNOPSIS


=head1 DESCRIPTION

=over 4

=cut

sub _extras { shift->{_extras} }

sub _json   { $_[0]->{_json}  }

=item * all

=cut

use Mojo::Util qw(dumper);

sub all ( $class, $workspace_id, $project_id ) {
	state $method   = 'get';
	state $endpoint = '/workspaces/{workspaceId}/projects/{projectId}/tasks';

	my $endpoint_args = [ $workspace_id, $project_id ];

	my @tasks;
	my $page = 1;
	my $page_size = 5000; # max defined in API

	while( 1 ) {
		my $form = { page => $page, 'page-size' => $page_size };
		my $tasks = request( $method, $endpoint, $endpoint_args, form => $form );
		push @tasks, map { $class->new( $endpoint_args, $_ ) } $tasks->_json->@*;
		last if $tasks->{_json}->@* < $page_size;
		$page++;
		}

	\@tasks;
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

=item * tags

Return a list of Tag objects for the project. If the project has no tags,
this returns the empty list.

=cut

sub tags { $_[0]->_tags->@* }

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
