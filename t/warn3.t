use strict;
use warnings;
use Test::More;

BEGIN {
	@::warn = ();
	$SIG{__WARN__} = sub {push @::warn, @_} unless $::NO_PLAN;
}

use List::Pairwise ();

unless ($::NO_PLAN) {
	plan tests => 3;
	List::Pairwise::mapp {$a, $b} (1..10);
	ok("@::warn", 'warnings for $a and $b when not used in module but not imported');
	
	for (0, 1) {
		like($::warn[$_], qr/Name "main::([ab])" used only once: possible typo at /, "warning $_");
	}
}
