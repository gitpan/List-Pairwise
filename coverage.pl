use strict;
use warnings;
use lib 'lib';
use Devel::Cover;
use Test::More qw(no_plan);
{
	no warnings 'redefine';
	*Test::More::plan = sub {};
}
for my $file (glob 't/*.t') {
	require $file;
}