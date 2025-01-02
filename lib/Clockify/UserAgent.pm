use v5.26;

package Clockify::UserAgent;
use warnings;
use experimental qw(signatures);

our $VERSION = '0.001_01';

use Exporter qw(import);
use Mojo::Util qw(dumper);

use Clockify::Error;
use Clockify::Util;

our @EXPORT = qw( request );

our %EXPORT_TAGS = (
	all => \@EXPORT,
	);

=encoding utf8

=head1 NAME

Clockify - interact with the Clockify.me API

=head1 SYNOPSIS

	use Clockify;

=head1 DESCRIPTION

=over 4

=cut

use Mojo::UserAgent;

=item * api_key

Return the API key set in the CLOCKIFY_API_KEY.

=cut

sub api_key { $ENV{CLOCKIFY_API_KEY} }

=item * base_url

Return the base url for the Clockify API

=cut

# 6001de4a1d70d54869bc8bd6
# https://clockify.me/developers-api
sub base_url { Mojo::URL->new( 'https://api.clockify.me/api/v1/' ) }

=item * reports_base_api

Return the base url for the Clockify ReportAPI

=cut

sub reports_base_api { Mojo::URL->new( 'https://reports.api.clockify.me/v1/' ) }

=item * request( METHOD, ENDPOINT, ENDPOINT_ARGS, UA_ARGS )

=cut

sub request ( $method, $endpoint, $endpoint_args = [], @args ) {
	my $path = sprintf $endpoint =~ s/\{.*?\}/%s/gr,
		map { id_from($_) } $endpoint_args->@*;

	my $url = base_url()->clone->path( $path =~ s|\A/||r );

	my $tx = ua()->$method( $url, @args );

	my $json = $tx->result->json;

	my $class = $tx->res->is_success ? (caller)[0] : 'Clockify::Error';

	return $class->new( $endpoint_args, $json );
	}

=item * ua

Return the web user agent. This has already been setup to include the
API Key in the response.

=cut

sub ua {
	state $rc = require Mojo::UserAgent;
	state $ua = do {
		my $ua = Mojo::UserAgent->new;
		$ua->on( prepare => \&_prepare );
		$ua
		};
	$ua
	}

sub _prepare {
    my( $ua, $tx ) = @_;

    die "Missing service token!" unless api_key();
    $tx->req->headers->header( 'X-Api-Key' => api_key() );
    $tx->req->headers->header( Accept => 'application/json' );
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
