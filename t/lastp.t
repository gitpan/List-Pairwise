use strict;
#use warnings;
use Test::More;

plan tests => 10;

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
is(scalar(lastp {$a =~ /snoogy/} %a), 1);
is(scalar(lastp {$b < 5} %a), 1);
is(scalar(lastp {$a =~ /snoogy/ && $b < 5} %a), 1);
is(scalar(lastp {$a =~ /bla/} %a), undef);

# count vs list
is (scalar(lastp {$a =~ /snoogy/} %a), 1/2 * scalar(my @a = lastp {$a =~ /snoogy/} %a));

# copy
is_deeply(
	{
		lastp {$a =~ /snoogy/} @b
	}, {
		snoogy3  => 5,
	}
);
is_deeply(
	{
		lastp {$b < 5} @b
	}, {
		NOT      => 4,
	}
);
is_deeply(
	{
		lastp {$a =~ /snoogy/ && $b < 5} @b
	}, {
		snoogy2  => 2, 
	}
);

is_deeply(
	{
		lastp {$a =~ /bla/} @b
	}, {
	}
);

eval {lastp {$a, $b} (1..5)};
like($@, '/^Odd number of elements in list /');