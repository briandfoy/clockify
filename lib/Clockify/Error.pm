use v5.32;

package Clockify::Error;
use warnings;
use experimental qw(signatures);

=encoding utf8

=head1 NAME

Clockify::Error - An error object

=head1 SYNOPSIS

	use Clockify::Error;

	my $tx = ... mojo transaction ...;

	my $class = $tx->res->is_success ? $some_class : 'Clockify::Error';
	my $object = $class->new( $tx->result->json );

	if( $object->is_error ) { ... }

=head1 DESCRIPTION

This class creates objects to stand in for response objects when there
was a failure.

=head2 Class methods

=over 4

=item * new( HASH )

Create a new error message with the hash that the error response
provided.

=cut

sub new ( $class, $json ) { bless $json, $class }

=back

=head2 Instance methods

=over 4

=item * code

Returns the error code.

=cut

sub code       { $_[0]->{code}    }

=item * message

Returns the error message.

=cut

sub message    { $_[0]->{message} }

=item * is_error

Returns true.

=cut

sub is_error   { 1 }

=item * is_success

Returns false.

=cut

sub is_success { 0 }

=back

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/briandfoy/clockify

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2021-2023, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut
1;
