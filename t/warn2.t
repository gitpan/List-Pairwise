use strict;
use warnings;
use Test::More;

BEGIN {
	@::warn = ();
	$SIG{__WARN__} = sub {push @::warn, @_} unless $::NO_PLAN;
}

use List::Pairwise qw(mapp);

unless ($::NO_PLAN) {
	plan tests => 1;
	mapp {$a, $b} (1..10);
	
	is("@::warn", '', 'no warnings for $a and $b when used in module');
}