use v5.32;

package Clockify;
use strict;

use warnings;
use experimental qw(signatures);

our $VERSION = '0.001_01';

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

sub new {

	}

=item init

=cut

sub init {

	}




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

=item * all_projects

=cut

sub all_projects ( $class, $workspace ) {
	state $rc = require Clockify::Endpoint::Project;
	Clockify::Endpoint::Project->all( $workspace );
	}

=back

=head3 Workspace

=over 4

=item * current_user_workspaces()

=cut

sub current_user_workspaces {
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
