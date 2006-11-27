use strict;
use Devel::Cover;
use Test::More qw(no_plan);
{
	#no warnings 'redefine';
	local $^W = 0;
	*Test::More::plan = sub {};
}
for my $file (glob 't/*.t') {
	require $file;
}