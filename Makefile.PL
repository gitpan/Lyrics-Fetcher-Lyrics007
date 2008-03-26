use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Lyrics::Fetcher::Lyrics007',
    AUTHOR              => 'James Ronan <james@ronanweb.co.uk>',
    VERSION_FROM        => 'lib/Lyrics/Fetcher/Lyrics007.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lyrics-Fetcher-Lyrics007-*' },

	# add LICENSE parameter if installed EU::MM is new enough to support it:
	($ExtUtils::MakeMaker::VERSION >= 6.3002 ? (LICENSE  => "perl") : ()),
);
