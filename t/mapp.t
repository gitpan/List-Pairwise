use strict;
#use warnings;
use Test::More;

plan tests => 10 unless $::NO_PLAN;

use List::Pairwise 'mapp';

my %a = (
	snoogy1  => 4,
	snoogy2  => 2, 
	NOT      => 4,
	snoogy3  => 5,
	hehe     => 12,
);

# count
is(scalar(mapp {$a} %a), scalar(keys %a), 'scalar context count 1');
is(scalar(mapp {$a => $b} %a), 2*scalar(keys %a), 'scalar context count 2');
is(scalar(mapp {$a, $b, 4} %a), 3*scalar(keys %a), 'scalar context count 3');

# copy
is_deeply(
	{
		mapp {$a => $b} %a
	}, {
		%a
	},
	'copy',
);
is_deeply(
	[
		mapp {$a} %a
	], [
		keys %a
	],
	'keys',
);
is_deeply(
	[
		mapp {$b} %a
	], [
		values %a
	],
	'values',
);
is_deeply(
	{
		mapp {lc($a) => $b} %a
	}, {
		snoogy1  => 4,
		snoogy2  => 2, 
		not      => 4,
		snoogy3  => 5,
		hehe     => 12,
	},
	'copy with lc keys',
);

# inplace
my %b;
%b = %a;
mapp {$b++} %b; # void context
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

%b = %a;
mapp {$a = lc($a)} %b; # wrong => no modification
is_deeply(
	{
		%b
	}, {
		%a
	},
	'lc keys inplace shall not work',
);

eval {mapp {$a, $b} (1..5)};
like($@, '/^Odd number of elements in list to &List::Pairwise::mapp at /', 'odd list');