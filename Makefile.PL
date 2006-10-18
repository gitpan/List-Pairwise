use inc::Module::Install;

name		'List-Pairwise';
all_from	'lib/List/Pairwise.pm';

requires	'Exporter';
build_requires	'Test::More'	=> '0.42';

auto_install;
WriteAll;
