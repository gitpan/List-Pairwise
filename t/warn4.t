use strict;
use warnings;
use Test::More;

BEGIN {
	@::warn = ();
	$SIG{__WARN__} = sub {push @::warn, @_} unless $::NO_PLAN;
}

use List::Pairwise ();

unless ($::NO_PLAN) {
	plan tests => 1;
	List::Pairwise::pair (1..10);
	
	is("@::warn", '', 'no warnings for $a and $b when not imported and not used in module');
}