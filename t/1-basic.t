#!/usr/bin/perl

use Test::More tests => 4;
use LWP::UserAgent;
use lib "../lib/";
use Lyrics::Fetcher::Lyrics007;

my @tests = (
    {
        track   => "In The Ghetto",
        band    => "Elvis Presley",
        lyrics  => qr/as her young man dies/i,
        real    => "true",
    },

    {
        track   => "The Tide",
        band    => "Spill Canvas",
        lyrics  => qr/and live for the moment now/i,
        real    => "true",
    },

    {
        track   => "Lip Gloss And Black",
        band    => "Atreyu",
        lyrics  => qr/just a little less human/i,
        real    => "true",
    },
     
    {
        track   => "I Heart Jello",
        band    => "Shaking Jellies",
        lyrics  => qr/Foo Bar Wibble/i,
        real    => "false",
    },
);


# Do a quick check to make sure we can get to the site, 
# else we need to skip all the tests.
my $ua = new LWP::UserAgent;
$ua->agent("Perl/Lyrics::Fetcher::Lyrics007 $Lyrics::Fetcher::Lyrics007::VERSION - Test Stubb");
$ua->timeout(5);
my $response_check = $ua->get("http://www.lyrics007.com/");


SKIP: {
    skip("Unable to request www.lyrics007.com", 4) if (!$response_check->is_success);
    

    for my $test (@tests) {
        my($track, $band, $lyrics, $real) = @$test{ qw(track band lyrics real) };  
        my $retval = Lyrics::Fetcher::Lyrics007->fetch($band,$track);   
    
        if ($real eq "true") {
            ok (($retval =~ m/$lyrics/) && ($Lyrics::Fetcher::Error eq "OK"), 
                "Real song lyrics found.");
        
        } else {
            ok ($Lyrics::Fetcher::Error =~ m/lyrics not found/i,
                "Fake song reports Lyrics not found (as expected)");
        }
    }
}
