#!/usr/bin/perl 

#
# Example for using the Lyrics::Fetcher::Lyrics007 Perl extension
#
use lib "../lib";
use Lyrics::Fetcher::Lyrics007;

# We'll get the lyrics for the band/track we were called with.
my ($band, $track) = @ARGV;

# if we don't have any then we'll stop now.
unless (@ARGV) {
   die("Usage: $0 artist song");
}

# request the lyrics.
if (my $lyr = Lyrics::Fetcher::Lyrics007 ->fetch($band, $track)) {
    # and print them if there was no error.
    print "$lyr\n";
} else {
    # Tell the user what happened
    print "Lyric fetch failed: $Lyrics::Fetcher::Error\n";
}