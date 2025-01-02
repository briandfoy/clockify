use v5.32;

package Clockify::Endpoint::TimeEntries;

use warnings;
use experimental qw(signatures);

use Carp qw(carp croak confess);

our $VERSION = '0.001_01';

use Clockify::DateTime;
use Clockify::UserAgent;
use Clockify::Util;

use Mojo::Util qw(dumper);

=encoding utf8

=head1 NAME

Clockify::Endpoint::TimeEntries -

=head1 SYNOPSIS


=head1 DESCRIPTION

=over 4

=item * get

=cut

sub get ( $class, $workspace_id, $user_id, $start_date = undef, $end_date = undef ) {
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

	my $endpoint_args = [ $workspace_id, $user_id ];
	my $set = request( $method, $endpoint, $endpoint_args, @args );

	my @entries =
		map { Clockify::Endpoint::TimeEntry->new( $endpoint_args, $_ ) }
		$set->_json->@*;

	\@entries;
	}

=item * new

=cut

sub new ( $class, $endpoint_args, $json ) {
	my( $workspace_id, $user_id ) = $endpoint_args->@*;

	my $self = bless {
		_endpoint_args => $endpoint_args,
		_json          => $json,
		_extras        => {},
		_workspace     => $workspace_id,
		_user          => $user_id,
		}, $class;

	$self;
	}

=back

=cut

sub _extras { shift->{_extras} }

sub _json   { shift->{_json}  }

sub is_error   { 0 }

sub is_success { 1 }


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
