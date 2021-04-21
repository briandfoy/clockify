use v5.32;

package Clockify::Endpoint::TimeEntry;

use warnings;
use experimental qw(signatures);

use Carp qw(carp croak);

our $VERSION = '0.001_01';

use Clockify::DateTime;
use Clockify::UserAgent;
use Clockify::Util;

use Mojo::Util qw(dumper);

=encoding utf8

=head1 NAME

Clockify::Endpoint::TimeEntry -

=head1 SYNOPSIS


=head1 DESCRIPTION

=over 4

=item * add

=item * add_time_entry

=pod

{
  "start": "2018-06-12T13:48:14.000Z",
  "billable": "true",
  "description": "Writing documentation",
  "projectId": "5b1667790cb8797321f3d664",
  "taskId": "5b1e6b160cb8793dd93ec120",
  "end": "2018-06-12T13:50:14.000Z",
  "tagIds": [
    "5a7c5d2db079870147fra234"
  ],
  "customFields": [
    {
      "customFieldId" : "5b1e6b160cb8793dd93ec120",
      "value": "San Francisco"
    }
  ]
}

=cut

sub add ( $class, $hash  ) {
	state $method   = 'post';
	state $endpoint = '/workspaces/{workspaceId}/user/{userId}/time-entries';

	my %query = ();

	$query{projectId} = id_from( $hash->{project} ) if exists $hash->{project};
	$query{description} = $hash->{description};

	@query{qw(start end)} = $hash->@{qw(start end)};

	my @values = ( $hash->{workspace}, delete $hash->{user} );

	my $result = request( $method, $endpoint, \@values, json => \%query );

	$result;
	}

=item * get

=cut

sub get ( $class, $workspace, $user, $start_date = undef, $end_date = undef ) {
	state $method   = 'get';
	state $endpoint = '/workspaces/{workspaceId}/user/{userId}/time-entries';

	my( %query, @args );

	$query{'page-size'} = 200;

	if( defined $start_date ) {
		$query{start} = $start_date;
		}
	if( defined $end_date ) {
		$query{end} = $start_date;
		}

	@args = keys %query ? ( form => \%query ) : ();

	my $set = request( $method, $endpoint, [ $workspace, $user ], @args );
	my @entries = map { $class->new( $_ ) } $set->_json->@*;
	\@entries;
	}

=item * new

=cut

sub new ( $class, $json ) {
	bless { _json => $json, _extras => {} }, $class;
	}

=back

=head2 Instance methods

=over 4

=cut

sub _extras { shift->{_extras} }

sub _json   { shift->{_json}  }

sub id { shift->_json->{id} }

sub is_error   { 0 }

sub is_success { 1 }

sub duration ( $self ) {
	state $rc = require Clockify::Duration;
	$self->_extras->{duration} =
		Clockify::Duration->parse( $_[0]->_json->{timeInterval}{duration} );
	}

sub start_date {
	parse_datetime( $_[0]->_json->{timeInterval}{start} );
	}

sub start_date_local {
	parse_datetime_local( $_[0]->_json->{timeInterval}{start} );
	}

sub end_date {
	parse_datetime( $_[0]->_json->{timeInterval}{end} );
	}

sub end_date_local {
	parse_datetime_local( $_[0]->_json->{timeInterval}{end} );
	}


sub time_entry ( $self ) {

	}



sub stop_timer ( $self, $workspace, $user ) {
	state $method   = 'patch';
	state $endpoint = '/workspaces/{workspaceId}/user/{userId}/time-entries';
	my @values = ( $workspace, $user );
	request( $method, $endpoint, \@values );
	}

sub update( $self, $workspace, $time_entry ) {
	state $method   = 'put';
	state $endpoint = '/workspaces/{workspaceId}/time-entries/{id}';
	my @values = ( $workspace, $self );
	request( $method, $endpoint, \@values );
	}

sub mark_entries_as_invoiced ( $self, $workspace ) {
	# PATCH /workspaces/{workspaceId}/time-entries/invoiced
	state $method   = 'put';
	state $endpoint = '/workspaces/{workspaceId}/time-entries/{id}';
	my @values = ( $workspace, $self );
	request( $method, $endpoint, \@values );
	}

sub delete ( $self, $workspace ) {
	# DELETE /workspaces/{workspaceId}/time-entries/{id}
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
    "_extras" => {},
    "_json" => {
      "billable" => $VAR1->[0]{"_json"}{"billable"},
      "customFieldValues" => undef,
      "description" => "Code reading",
      "id" => "6019883d8abdf533aca60d2d",
      "isLocked" => $VAR1->[0]{"_json"}{"billable"},
      "projectId" => "6001e274f05da620e8227021",
      "tagIds" => undef,
      "taskId" => undef,
      "timeInterval" => {
        "duration" => "PT4H",
        "end" => "2021-02-02T00:00:00Z",
        "start" => "2021-02-01T20:00:00Z"
      },
      "userId" => "6001dcc2f05da620e8222f5d",
      "workspaceId" => "5b634056b0798703574fe8f5"
    }
  }, 'Clockify::Endpoint::TimeEntry' ),
