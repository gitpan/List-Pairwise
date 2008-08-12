package List::Pairwise;
use 5.006;
use strict;
use warnings;
use Exporter;

our $VERSION= '0.29';

our %EXPORT_TAGS = ( 
	all => [ qw(
		mapp grepp firstp lastp
		map_pairwise grep_pairwise first_pairwise last_pairwise
		pair
	) ],
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{all} } );

sub import {
	no strict qw(refs);
	no warnings qw(once void);
	# avoid "Name "main::a" used only once" warnings for $a and $b
	*{caller().'::a'};
	*{caller().'::b'};
	goto &Exporter::import
}

sub _carp_odd {
	warnings::warnif(misc => 'Odd number of elements in &'. [caller(1)]->[3]. ' arguments')
}

sub mapp (&@) {
	unless (@_&1) {
		_carp_odd;
		push @_, undef;
		goto \&mapp;
	}
	my $code = shift;

	# Localise $a and $b
	# (borrowed from List-MoreUtils)
	my ($caller_a, $caller_b) = do {
		my $pkg = caller();
		no strict 'refs';
		\*{$pkg.'::a'}, \*{$pkg.'::b'};
	};
	local(*$caller_a, *$caller_b);

	no warnings;
	
	if (wantarray) {
		# list context
		map {(*$caller_a, *$caller_b) = \splice(@_, 0, 2); $code->()} (1..@_/2)
	}
	elsif (defined wantarray) {
		# scalar context
		# count number of returned elements
		my $i=0;
		# force list context with =()= for the count
		$i +=()= $code->() while (*$caller_a, *$caller_b) = \splice(@_, 0, 2);
		$i
	}
	else {
		# void context
		() = $code->() while (*$caller_a, *$caller_b) = \splice(@_, 0, 2);
	}
}

sub grepp (&@) {
	unless (@_&1) {
		_carp_odd;
		push @_, undef;
		goto \&grepp;
	}
	my $code = shift;

	# Localise $a and $b
	# (borrowed from List-MoreUtils)
	my ($caller_a, $caller_b) = do {
		my $pkg = caller();
		no strict 'refs';
		\*{$pkg.'::a'}, \*{$pkg.'::b'};
	};
	local(*$caller_a, *$caller_b);

	no warnings;

	if (wantarray) {
		# list context
		map {(*$caller_a, *$caller_b) = \splice(@_, 0, 2); $code->() ? ($$$caller_a, $$$caller_b) : ()} (1..@_/2)
	}
	elsif (defined wantarray) {
		# scalar context
		# count number of valid *pairs* (not elements)
		my $i=0;
		$code->() && ++$i while (*$caller_a, *$caller_b) = \splice(@_, 0, 2);
		$i
		# Returning the number of valid pairs is more intuitive than
		# the number of elements.
		# We have this equality:
		# (grepp BLOCK LIST) == 1/2 * scalar(my @a = (grepp BLOCK LIST))
	}
	else {
		# void context
		# same as mapp, but evaluates $code in scalar context
		scalar $code->() while (*$caller_a, *$caller_b) = \splice(@_, 0, 2);
	}
}

sub firstp (&@) {
	unless (@_&1) {
		_carp_odd;
		push @_, undef;
		goto \&firstp;
	}
	my $code = shift;

	# Localise $a and $b
	# (borrowed from List-MoreUtils)
	my ($caller_a, $caller_b) = do {
		my $pkg = caller();
		no strict 'refs';
		\*{$pkg.'::a'}, \*{$pkg.'::b'};
	};
	local(*$caller_a, *$caller_b);

	no warnings;
	
	if (wantarray) {
		# list context
		$code->() && return($$$caller_a, $$$caller_b) while (*$caller_a, *$caller_b) = \splice(@_, 0, 2);
		()
	} else {
		# scalar or void context
		# return true/false
		$code->() && return 1 while (*$caller_a, *$caller_b) = \splice(@_, 0, 2);
		undef
	}
}

sub lastp (&@) {
	unless (@_&1) {
		_carp_odd;
		push @_, undef;
		goto \&lastp;
	}
	my $code = shift;

	# Localise $a and $b
	# (borrowed from List-MoreUtils)
	my ($caller_a, $caller_b) = do {
		my $pkg = caller();
		no strict 'refs';
		\*{$pkg.'::a'}, \*{$pkg.'::b'};
	};
	local(*$caller_a, *$caller_b);

	no warnings;
	
	if (wantarray) {
		# list context
		$code->() && return($$$caller_a, $$$caller_b) while (*$caller_a, *$caller_b) = @_ ? \splice(@_, -2) : ();
		()
	} else {
		# scalar or void context
		# return true/false
		$code->() && return 1 while (*$caller_a, *$caller_b) = @_ ? \splice(@_, -2) : ();
		undef
	}
}

sub pair {
	_carp_odd if @_&1;
	return @_
		? map [ @_[$_*2, $_*2 + 1] ] => 0 .. ($#_>>1)
		: wantarray ? () : 0
	;
}

#sub truep   (&@) { scalar &grepp(@_)      }
#sub falsep  (&@) { (@_-1)/2 - &grepp(@_)  }
#sub allp    (&@) { (@_-1)/2 == &grepp(@_) }
#sub notallp (&@) { (@_-1)/2 > &grepp(@_)  }
#sub nonep   (&@) { !&firstp(@_)           }
#sub anyp    (&@) { scalar &firstp(@_)     }

# install aliases
sub map_pairwise (&@);
sub grep_pairwise (&@);
sub first_pairwise (&@);
sub last_pairwise (&@);
#sub true_pairwise (&@);
#sub false_pairwise (&@);
#sub all_pairwise (&@);
#sub notall_pairwise (&@);
#sub none_pairwise (&@);
#sub any_pairwise (&@);

*map_pairwise = \&mapp;
*grep_pairwise = \&grepp;
*first_pairwise = \&firstp;
*last_pairwise = \&lastp;
#*true_pairwise = \&truep;
#*false_pairwise = \&falsep;
#*all_pairwise = \&allp;
#*notall_pairwise = \&notallp;
#*none_pairwise = \&nonep;
#*any_pairwise = \&anyp;

1