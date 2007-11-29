use strict;
#use warnings;
use Test::More;

plan tests => 10 unless $::NO_PLAN;

use List::Pairwise 'grepp';

my %a = (
	snoogy1  => 4,
	snoogy2  => 2, 
	NOT      => 4,
	snoogy3  => 5,
	hehe     => 12,
);

# count
is(scalar(grepp {$a =~ /snoogy/} %a), 3, 'scalar context count 1');
is(scalar(grepp {$b < 5} %a), 3, 'scalar context count 2');
is(scalar(grepp {$a =~ /snoogy/ && $b < 5} %a), 2, 'scalar context count 3');
is(scalar(grepp {$a =~ /bla/} %a), 0, 'scalar context count 4');

# count vs list
is (scalar(grepp {$a =~ /snoogy/} %a), 1/2 * scalar(my @a = grepp {$a =~ /snoogy/} %a), 'scalar and list count');

# copy
is_deeply(
	{
		grepp {$a =~ /snoogy/} %a
	}, {
		snoogy1  => 4,
		snoogy2  => 2, 
		snoogy3  => 5,
	},
	'extract 1',
);
is_deeply(
	{
		grepp {$b < 5} %a
	}, {
		snoogy1  => 4,
		snoogy2  => 2, 
		NOT      => 4,
	},
	'extract 2',
);
is_deeply(
	{
		grepp {$a =~ /snoogy/ && $b < 5} %a
	}, {
		snoogy1  => 4,
		snoogy2  => 2, 
	},
	'extract 3',
);

# inplace
my %b;
%b = %a;
grepp {$b++} %b; # void context (same a mapp)
is_deeply(
	{
		%b
	}, {
		snoogy1  => 5,
		snoogy2  => 3, 
		NOT      => 5,
		snoogy3  => 6,
		hehe     => 13,
	},
	'inc values inplace',
);

eval {grepp {$a, $b} (1..5)};
like($@, '/^Odd number of elements in list to &List::Pairwise::grepp at /', 'odd list');