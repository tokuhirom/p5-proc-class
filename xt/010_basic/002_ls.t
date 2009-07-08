use strict;
use warnings;
use Test::More;
use Proc::Class;

my $bin = '/bin/ls';
plan skip_all => "this test requires $bin" unless -x $bin;

my $proc = Proc::Class->new(
    cmd => $bin,
    argv => [],
);
like $proc->slurp_stdout, qr/Changes/;
is $proc->slurp_stderr, '';

done_testing;

