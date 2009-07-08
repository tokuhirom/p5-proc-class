use inc::Module::Install;
name 'Proc-Class';
all_from 'lib/Proc/Class.pm';

requires 'Any::Moose' => 0.10;
requires 'IPC::Open3' => 1.02;

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
