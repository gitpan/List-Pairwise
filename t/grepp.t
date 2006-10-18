use strict;
use warnings;
use Test::More;

plan tests => 8;

use List::Pairwise 'grepp';

my %a = (
	snoogy1  => 4,
	snoogy2  => 2, 
	NOT      => 4,
	snoogy3  => 5,
	hehe     => 12,
);

# count
is(scalar(grepp {$a =~ /snoogy/} %a), 3);
is(scalar(grepp {$b < 5} %a), 3);
is(scalar(grepp {$a =~ /snoogy/ && $b < 5} %a), 2);
is(scalar(grepp {$a =~ /bla/} %a), 0);

# count vs list
is (scalar(grepp {$a =~ /snoogy/} %a), 1/2 * scalar(my @a = grepp {$a =~ /snoogy/} %a));

# copy
is_deeply(
	{
		grepp {$a =~ /snoogy/} %a
	}, {
		snoogy1  => 4,
		snoogy2  => 2, 
		snoogy3  => 5,
	}
);
is_deeply(
	{
		grepp {$b < 5} %a
	}, {
		snoogy1  => 4,
		snoogy2  => 2, 
		NOT      => 4,
	}
);
is_deeply(
	{
		grepp {$a =~ /snoogy/ && $b < 5} %a
	}, {
		snoogy1  => 4,
		snoogy2  => 2, 
	}
);
