use strict;
use warnings;
use Proc::Class;
use English;
use Test::More;

my $proc = Proc::Class->new(
    cmd => $EXECUTABLE_NAME,
    argv => ['-e', 'sleep 100'],
);
kill HUP => $proc->pid;
my $status = $proc->waitpid;
is $status->is_exited, 0;
is $status->is_signaled, 1;
is $status->termsig, 1;

done_testing;
