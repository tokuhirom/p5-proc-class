use inc::Module::Install;
name 'Proc-Class';
all_from 'lib/Proc/Class.pm';

requires 'Any::Moose' => 0.10;
requires 'IPC::Open3' => 1.02;

tests 't/*.t';
recursive_author_tests 'xt';

build_requires 'Test::More';
auto_include;
WriteAll;
