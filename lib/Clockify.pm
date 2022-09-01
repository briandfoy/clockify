use v5.32;

package Clockify;
use strict;

use warnings;
use experimental qw(signatures);

our $VERSION = '0.001_01';

use Clockify::Endpoint::Project;
use Clockify::Endpoint::User;
use Clockify::Endpoint::Workspace;

=encoding utf8

=head1 NAME

Clockify - interact with the Clockify.me API

=head1 SYNOPSIS

	use Clockify;

=head1 DESCRIPTION

=over 4

=item new

=cut

sub new ( $class, $workspace_id = undef ) {
	my $self = bless {}, $class;
	$self->init(
		workspace_id => $workspace_id,
		);
	$self;
	}

=item init( HASH )

Hash:

	user_id
	workspace_id

=cut

sub init ( $self, %args ) {
	$self->{user} = Clockify::Endpoint::User->current;
	$self->{workspace_id} = $args{workspace_id} // $self->{user}->active_workspace_id;
	}

=item user

Return the User object.

=cut

sub user ( $self ) { $self->{user} }

=item workspace_id

Return the Workspace ID as a string.

=cut

sub workspace_id ( $self ) { $self->{workspace_id} }

=back

=head2 Endpoints

=head3 Time Entry

=over 4

=item * current_user_time_entries( WORKSPACE | WORKSPACE_ID, USER | USER_ID, HASH )

=cut

# GET /workspaces/{workspaceId}/user/{userId}/time-entries

=item * specific_time_entry( WORKSPACE | WORKSPACE_ID, ENTRY_ID

=cut

# GET /workspaces/{workspaceId}/time-entries/{id}

=item * add_time_entry

=cut

# POST /workspaces/{workspaceId}/time-entries

=item * add_time_entry_for

Unimplemented. This is an admin feature for paid workspaces.

=cut

sub add_time_entry_for { paid_feature() }

=item * stop_timer

Unimplemented. This is an admin feature for paid workspaces.

=cut

sub stop_timer { paid_feature() }

=item * update_time_entry

=cut

# PUT /workspaces/{workspaceId}/time-entries/{id}

=item * delete_time_entry

=cut

# DELETE /workspaces/{workspaceId}/time-entries/{id}

=back

=head3 User

=over 4

=item * current_user()

Get the current user from the API.

=cut

sub current_user { Clockify::Endpoint::User->current }

# GET /user

=item * all_users_on_workspace( WORKSPACE | WORKSPACE_ID )

=cut

# GET /workspaces/{workspaceId}/users

=item * add_user_to_workspace( WORKSPACE | WORKSPACE_ID, EMAIL )

Unimplemented. This is an admin feature for paid workspaces.

=cut

sub add_user_to_workspace { paid_feature() }

=item * add_user_workspace_status( WORKSPACE | WORKSPACE_ID, USER | USER_ID )

Unimplemented. This is an admin feature.

=cut

sub add_user_workspace_status {
	# PUT /workspaces/{workspaceId}/users/{userId}
	admin_feature();
	}

=item * remove_user_from_workspace( WORKSPACE | WORKSPACE_ID, USER | USER_ID )

Unimplemented. This is an admin feature.

=cut

sub remove_user_from_workspace {
	# DELETE /workspaces/{workspaceId}/users/{userId}
	admin_feature();
	}


=back

=head3 Projects

=over 4

=item * all_projects( [ WORKSPACE_ID ] )

=cut

sub all_projects ( $self, $workspace_id = undef  ) {
	Clockify::Endpoint::Project->all( $workspace_id // $self->user->active_workspace_id );
	}

=item * get_project( WORKSPACE_ID, PROJECT_ID )

=cut

sub get_project ( $self, $workspace_id, $project_id  ) {
	Clockify::Endpoint::Project->get( $workspace_id // $self->user->active_workspace_id, $project_id );
	}

=item * get_project( WORKSPACE_ID, PROJECT_ID )

=cut

sub get_project_tasks ( $self, $workspace_id, $project_id  ) {
	Clockify::Endpoint::Task->get( $workspace_id // $self->user->active_workspace_id, $project_id );
	}

=item * get_project_id

=cut

sub get_project_id ( $self ) {
	if( not defined $ENV{CLOCKIFY_PROJECT} and defined $ENV{CLOCKIFY_PROJECT_ID} ) {
		warn "CLOCKIFY_PROJECT_ID is deprecated. Use CLOCKIFY_PROJECT instead. Converting that for you.\n";
		$ENV{CLOCKIFY_PROJECT} = delete $ENV{CLOCKIFY_PROJECT_ID};
		}

	say "CLOCKIFY_PROJECT <$ENV{CLOCKIFY_PROJECT}>";
	return unless length $ENV{CLOCKIFY_PROJECT};

	my $name = $ENV{CLOCKIFY_PROJECT};

	return do {
		if( $name =~ m/\A[a-f0-9]{24}\z/ ) { $name }
		else { $self->project_id_from_name( $name ) }
		};
	}

=item * project_id_from_name( NAME )

=cut

sub project_id_from_name ( $self, $name ) {
	$self->project_name_hash->{$name};
	}

sub project_name_from_id ( $self, $id ) {
	$self->project_id_hash->{$id};
	}

=item * project_id_hash

=item * project_name_hash

=cut

sub project_id_hash ( $self, $workspace = undef ) {
	state %h;
	return if keys %h;

	%h = map {  $_->id, $_->name }
		Clockify::Endpoint::Project
			->all( $workspace // $self->user->active_workspace_id )
			->@*;
	\%h;
	}

sub project_name_hash ( $self ) {
	state %h = reverse $self->project_id_hash->%*;
	\%h;
	}

=back

=head3 Workspace

=over 4

=item * current_user_workspaces()

=cut

sub current_user_workspaces ( $class ) {
	# GET /workspaces
	Clockify::Endpoint::Workspace->for_current_user;
	}

=back


=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/briandfoy/Clockify

=head1 AUTHOR

brian d foy, C<< <brian d foy> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2021, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;
