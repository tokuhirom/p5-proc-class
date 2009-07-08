package Proc::Class;
use Any::Moose;
our $VERSION = '0.01';
use 5.008001;
our @EXPORT = qw/test_script/;
use IO::Pipe; # IO::Pipe was first released with perl 5.00307
use Proc::Class::Status;

has stdin => (
    is => 'rw',
);

has stdout => (
    is => 'rw',
);

has stderr => (
    is => 'rw',
);

has pid => (
    is => 'rw',
    isa => 'Int',
);

has cmd => (
    is => 'ro',
    isa => 'Str',
);

has env => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { \%ENV },
);

has argv => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub { +[] },
);
use IPC::Open3 qw/open3/;

sub BUILD {
    my $self = shift;
    $SIG{PIPE} = "IGNORE"; # XXX

    my %env_backup = %ENV;
    %ENV = %{ $self->env };

    my ($in, $out, $err);
    my $pid = IPC::Open3::open3($in, $out, $err, $self->cmd, @{ $self->argv });
    $self->pid($pid);
    $self->stdin($in);
    $self->stdout($out);
    $self->stderr($err);

    %ENV = %env_backup; # restore
}

sub print_stdin {
    my ($self, $txt) = @_;
    my $fh = $self->{stdin};
    print $fh $txt;
}

sub close_stdin {
    my $self = shift;
    close $self->{stdin};
}

sub slurp_stdout {
    my ($self, $expected) = @_;
    my $fh = $self->stdout;
    my $got = join '', <$fh>;
    return $got;
}

sub slurp_stderr {
    my ($self, $expected) = @_;
    my $fh = $self->stderr;
    if ($fh) {
        my $got = join '', <$fh>;
        return $got;
    } else {
        return '';
    }
}

sub waitpid {
    my $self = shift;
    waitpid($self->{pid}, 0);
    return Proc::Class::Status->new(status => $?);
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

Proc::Class -

=head1 SYNOPSIS

    use Test::More tests => 4;
    use Proc::Class;

    my $script = Proc::Class->spawn(
        cmd  => '/path/to/script/qmail/foo.pl',
        env  => {DEFAULT => "TOKEN"},
        argv => [qw/--dump/],
    );
    $script->print_stdin($mail->body);
    $script->close_stdin();
    is $script->slurp_stdout(), '';
    is $script->slurp_stderr(), '';

    my $status = $script->wait;
    ok $status->is_exited();
    is $status->exit_status(), 0;

=head1 DESCRIPTION

Proc::Class is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
