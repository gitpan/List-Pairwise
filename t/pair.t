use strict;
#use warnings;
use Test::More;

plan tests => 7 unless $::NO_PLAN;

use List::Pairwise 'pair';

my %a = (
	snoogy1  => 4,
	snoogy2  => 2, 
	NOT      => 4,
	snoogy3  => 5,
	hehe     => 12,
);

# scalar context
is(scalar(pair %a), scalar(keys %a), 'scalar context');

# list context
is_deeply(
	[pair %a], 
	[List::Pairwise::mapp {[$a, $b]} %a],
	'list context',
);

# void context
eval {pair %a};
is($@, '', 'void context');

# odd list
eval {pair (1..5)};
like($@, '/^Odd number of elements in list to &List::Pairwise::pair at /', 'odd list');

# empty list, list context
is_deeply(
	[pair ()], 
	[],
	'empty list, list context',
);

# empty list, scalar context
is(scalar(pair ()), 0, 'empty list, scalar context');

# empty list, void context
eval {pair ()};
is($@, '', 'empty list, void context');