use v5.34;
use experimental qw(signatures);

package Clockify::Config;

use Mojo::Util qw(dumper);
use TOML::XS;

sub new ( $class, $config_file = undef ) {
	my $self = bless { _file => $config_file }, $class;
	$self->_read_config;
	$self;
	}

sub _slurp ( $self ) {
	my $fh;
	unless( open $fh, '<:raw', $self->_file ) {
		warn "Could not find file <@{[$self->_file]}>\n";
		return;
		}

	local $/;
	my $data = <$fh>;
	}

sub _file ( $self ) { $self->{_file} }

sub _read_config ( $self ) {
	state $rc = require TOML::XS;
	my $toml = $self->_slurp;
	$self->{_struct} = TOML::XS::from_toml($toml)->to_struct();
	$self;
	}

sub _config ( $self ) { $self->{_struct} }

sub _projects ( $self ) { $self->_config->{projects} // {} }

sub default_project ( $self ) {
	my( undef, $label ) = split /\./, $self->_config->{projects}{default}{pointer}, 2;
	$self->_projects->{$label};
	}

sub default_project_id   ( $self ) { $self->default_project->{id}   }

sub default_project_name ( $self ) { $self->default_project->{name} }

sub project_from_label ( $self, $label ) {
	foreach my $this ( keys $self->_projects->%* ) {
		next unless $this eq $label;
		return $self->_projects->{$label};
		}

	return {};
	}

sub project_id_from_label ( $self, $label ) {
	$self->project_from_label( $label )->{id};
	}

sub project_name_from_label ( $self, $label ) {
	$self->project_from_label( $label )->{name};
	}

1;
