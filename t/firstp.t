use strict;
#use warnings;
use Test::More;

plan tests => 10 unless $::NO_PLAN;

use List::Pairwise 'firstp';

my @b = (
	snoogy1  => 4,
	snoogy2  => 2, 
	NOT      => 4,
	snoogy3  => 5,
	hehe     => 12,
);
my %a = @b;

# count
is(scalar(firstp {$a =~ /snoogy/} %a), 1, 'scalar context true 1');
is(scalar(firstp {$b < 5} %a), 1, 'scalar context true 2');
is(scalar(firstp {$a =~ /snoogy/ && $b < 5} %a), 1, 'scalar context true 3');
is(scalar(firstp {$a =~ /bla/} %a), undef, 'scalar context false');

# count vs list
is (scalar(firstp {$a =~ /snoogy/} %a), 1/2 * scalar(my @a = firstp {$a =~ /snoogy/} %a), 'scalar and list count');

# copy
is_deeply(
	{
		firstp {$a =~ /snoogy/} @b
	}, {
		snoogy1  => 4,
	},
	'extract 1',
);
is_deeply(
	{
		firstp {$b < 5} @b
	}, {
		snoogy1  => 4,
	},
	'extract 2',
);
is_deeply(
	{
		firstp {$a =~ /snoogy/ && $b < 5} @b
	}, {
		snoogy1  => 4,
	},
	'extract 3',
);

is_deeply(
	{
		firstp {$a =~ /bla/} @b
	}, {
	},
	'extract 4',
);

eval {firstp {$a, $b} (1..5)};
like($@, '/^Odd number of elements in list to &List::Pairwise::firstp at /', 'odd list');