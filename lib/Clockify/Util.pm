use v5.26;

package Clockify::Util;
use strict;

use warnings;
use experimental qw(signatures);

our $VERSION = '0.001_02';

use Exporter qw(import);

our @EXPORT = qw( id_from );

our %EXPORT_TAGS = (
	all => \@EXPORT,
	);

=encoding utf8

=head1 NAME

Clockify::Util - miscellaneous things

=head1 SYNOPSIS

	use Clockify::Util;

=head1 DESCRIPTION

=over 4

=cut

=item * id_from( OBJECT | STRING )

Given an object, return the result of its C<id> method, if it exists.
Otherwise, it returns undef.

Given a string, return the string.

This allows you to take an object or the string ID for something and
ensure that you have the ID at the end.


=cut

sub id_from ( $thingy ) {
	if( ref $thingy ) {
		eval { $thingy->can('id') } ? $thingy->id : undef
		}
	else {
		$thingy;
		}
	}

=item * local_to_zulu( $datetime )


=cut

sub local_to_zulu ( $datetime ) {

	}

=back

=head1 TO DO


=head1 SEE ALSO


=head1 SOURCE AVAILABILITY

This source is in Github:

	http://github.com/briandfoy/clockify

=head1 AUTHOR

brian d foy, C<< <briandfoy@pobox.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright © 2021-2025, brian d foy, All Rights Reserved.

You may redistribute this under the terms of the Artistic License 2.0.

=cut

1;
