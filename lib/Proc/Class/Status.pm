package Proc::Class::Status;
use Any::Moose;
use 5.008001;
use POSIX;

has status => (
    is => 'ro',
);

sub is_exited {
    my $self = shift;
    return WIFEXITED( $self->status );
}

sub exit_status {
    my ( $self, ) = @_;
    return WEXITSTATUS( $self->status );
}


no Any::Moose;
__PACKAGE__->meta->make_immutable;
