use strict;
use warnings;
use Test::More;

plan tests => 13;

require_ok 'List::Pairwise';
List::Pairwise->import(':all');

# test import
is(\&mapp, \&List::Pairwise::mapp);
is(\&map_pairwise, \&List::Pairwise::map_pairwise);
is(\&mapp, \&map_pairwise);

is(\&grepp, \&List::Pairwise::grepp);
is(\&grep_pairwise, \&List::Pairwise::grep_pairwise);
is(\&grepp, \&grep_pairwise);

is(\&firstp, \&List::Pairwise::firstp);
is(\&first_pairwise, \&List::Pairwise::first_pairwise);
is(\&firstp, \&first_pairwise);

is(\&lastp, \&List::Pairwise::lastp);
is(\&last_pairwise, \&List::Pairwise::last_pairwise);
is(\&lastp, \&last_pairwise);
