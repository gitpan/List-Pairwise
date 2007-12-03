use strict;
use warnings;
use Test::More;

plan tests => 29 unless $::NO_PLAN && $::NO_PLAN;

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

{
	no warnings;
	is((mapp {[$a, $b]} ()), 0, 'scalar mapp empty list');
	is((mapp {[$a, $b]} (1)), 1, 'scalar mapp 1 element');
	is((mapp {[$a, $b]} (1..2)), 1, 'scalar mapp 2 element2');
	is((mapp {[$a, $b]} (1..3)), 2, 'scalar mapp 3 element2');
	is_deeply(
		[mapp {[$a, $b]} (1)],
		[[1, undef]],
		'list mapp 1 elements',
	);
	is_deeply(
		[mapp {[$a, $b]} (1..2)],
		[[1, 2]],
		'list mapp 2 elements',
	);
	is_deeply(
		[mapp {[$a, $b]} (1..3)],
		[[1, 2], [3, undef]],
		'list mapp 3 elements',
	);
}

{
	no warnings;

	is_deeply(
		[mapp {$a, $b} (1..3)],
		[1..3, undef],
		'mapp odd list',
	);

	my @list = (1..3);
	
	is_deeply(
		[mapp {++$a, ++$b} @list],
		[2..4, 1],
		'inc mapp odd list',
	);
	
	is_deeply(
		\@list,
		[2..4],
	);
}

# odd list
{
	my $file = quotemeta __FILE__;
	
	{
		no warnings;
		my $ok = 1;
		local $SIG{__WARN__} = sub{$ok=0};
		eval {mapp {$a, $b} (1..5)};
		is($@, '', 'odd list, no warning');
		ok($ok, 'no warning occured');
	}
	
	{
		use warnings;
		my $ok = 0;
		my $warn;
		local $SIG{__WARN__} = sub{$ok=1; $warn=shift};
		eval {mapp {$a, $b} (1..5)};
		my $line = __LINE__ - 1;
		is($@, '', 'odd list');
		ok($ok, 'warning occured');
		like($warn, qr/^Odd number of elements in &List::Pairwise::mapp arguments at $file line $line$/, 'odd list carp');
	}

	{
		no warnings 'misc';
		my $ok = 1;
		local $SIG{__WARN__} = sub{$ok=0};
		eval {mapp {$a, $b} (1..5)};
		is($@, '', 'odd list, no warning');
		ok($ok, 'no warning occured');
	}
	
	{
		use warnings 'misc';
		my $ok = 0;
		my $warn;
		local $SIG{__WARN__} = sub{$ok=1; $warn=shift};
		eval {mapp {$a, $b} (1..5)};
		my $line = __LINE__ - 1;
		is($@, '', 'odd list');
		ok($ok, 'warning occured');
		like($warn, qr/^Odd number of elements in &List::Pairwise::mapp arguments at $file line $line$/, 'odd list carp');
	}
	
}