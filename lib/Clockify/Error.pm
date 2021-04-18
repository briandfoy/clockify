use v5.32;

package Clockify::Error;
use warnings;
use experimental qw(signatures);

sub new ( $class, $json ) { bless $json, $class }

sub code       { $_[0]->{code}    }
sub message    { $_[0]->{message} }

sub is_error   { 1 }
sub is_success { 0 }

1;
