use strict;
use warnings;
use Test::More;

plan tests => 19 unless $::NO_PLAN && $::NO_PLAN;

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

# odd list
{
	my $file = quotemeta __FILE__;

	{
		no warnings;
		my $ok = 1;
		local $SIG{__WARN__} = sub{$ok=0};
		eval {grepp {$a, $b} (1..5)};
		is($@, '', 'odd list, no warning');
		ok($ok, 'no warning occured');
	}
	
	{
		use warnings;
		my $ok = 0;
		my $warn;
		local $SIG{__WARN__} = sub{$ok=1; $warn=shift};
		eval {grepp {$a, $b} (1..5)};
		my $line = __LINE__ - 1;
		is($@, '', 'odd list');
		ok($ok, 'warning occured');
		like($warn, qr/^Odd number of elements in &List::Pairwise::grepp arguments at $file line $line(?:$|\s)/, 'odd list carp');
	}

	{
		no warnings 'misc';
		my $ok = 1;
		local $SIG{__WARN__} = sub{$ok=0};
		eval {grepp {$a, $b} (1..5)};
		is($@, '', 'odd list, no warning');
		ok($ok, 'no warning occured');
	}
	
	{
		use warnings 'misc';
		my $ok = 0;
		my $warn;
		local $SIG{__WARN__} = sub{$ok=1; $warn=shift};
		eval {grepp {$a, $b} (1..5)};
		my $line = __LINE__ - 1;
		is($@, '', 'odd list');
		ok($ok, 'warning occured');
		like($warn, qr/^Odd number of elements in &List::Pairwise::grepp arguments at $file line $line(?:$|\s)/, 'odd list carp');
	}
}