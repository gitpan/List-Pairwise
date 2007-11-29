use strict;
#use warnings;
use Test::More;

plan tests => 10 unless $::NO_PLAN;

use List::Pairwise 'lastp';

my @b = (
	snoogy1  => 4,
	snoogy2  => 2, 
	NOT      => 4,
	snoogy3  => 5,
	hehe     => 12,
);
my %a = @b;

# count
is(scalar(lastp {$a =~ /snoogy/} %a), 1, 'scalar context true 1');
is(scalar(lastp {$b < 5} %a), 1, 'scalar context true 2');
is(scalar(lastp {$a =~ /snoogy/ && $b < 5} %a), 1, 'scalar context true 3');
is(scalar(lastp {$a =~ /bla/} %a), undef, 'scalar context false');

# count vs list
is (scalar(lastp {$a =~ /snoogy/} %a), 1/2 * scalar(my @a = lastp {$a =~ /snoogy/} %a), 'scalar and list count');

# copy
is_deeply(
	{
		lastp {$a =~ /snoogy/} @b
	}, {
		snoogy3  => 5,
	},
	'extract 1',
);
is_deeply(
	{
		lastp {$b < 5} @b
	}, {
		NOT      => 4,
	},
	'extract 2',
);
is_deeply(
	{
		lastp {$a =~ /snoogy/ && $b < 5} @b
	}, {
		snoogy2  => 2, 
	},
	'extract 3',
);

is_deeply(
	{
		lastp {$a =~ /bla/} @b
	}, {
	},
	'extract 4',
);

eval {lastp {$a, $b} (1..5)};
like($@, '/^Odd number of elements in list to &List::Pairwise::lastp at /', 'odd list');