use strict;
#use warnings;
use Test::More;

plan tests => 9;

use List::Pairwise 'mapp';

my %a = (
	snoogy1  => 4,
	snoogy2  => 2, 
	NOT      => 4,
	snoogy3  => 5,
	hehe     => 12,
);

# count
is(scalar(mapp {$a} %a), scalar(keys %a));
is(scalar(mapp {$a => $b} %a), 2*scalar(keys %a));

# copy
is_deeply(
	{
		mapp {$a => $b} %a
	}, {
		%a
	}
);
is_deeply(
	[
		mapp {$a} %a
	], [
		keys %a
	]
);
is_deeply(
	[
		mapp {$b} %a
	], [
		values %a
	]
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
	}
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
	}
);

%b = %a;
mapp {$a = lc($a)} %b; # wrong => no modification
is_deeply(
	{
		%b
	}, {
		%a
	}
);

eval {mapp {$a, $b} (1..5)};
like($@, '/^Odd number of elements in list /');