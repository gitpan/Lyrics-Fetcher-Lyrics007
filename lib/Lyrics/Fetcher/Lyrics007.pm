package Lyrics::Fetcher::Lyrics007;

use 5.008000;
use strict;
use WWW::Mechanize;
use Carp;


our $VERSION = '0.05';
our $AGENT   = "Perl/Lyrics::Fetcher::Lyrics007 $VERSION";

sub fetch {

    my $self = shift;
    my ($band, $track) = @_;

    # make sure that the artist and teack names are all Capitalised as the
    # site pages are all uppercase firsts. 
    for ($band, $track) {
        $_ = _title_case_all($_);
        $_ = URI::Escape::uri_escape($_);
    }

    # preset the error var with ok, and change it if it went wrond.
    $Lyrics::Fetcher::Error = 'OK';

    # make sure we were given summit to search for...
    unless ($band && $track) {
        carp($Lyrics::Fetcher::Error = 
                "fetch() called without required parameters. artist & title )");
        return;
    }
    
    # set up the url to call.
    my $url = "http://www.lyrics007.com/$band Lyrics/$track Lyrics.html";

    # right, its page time. so we'll sort out our useragent instance.
    my $mech = WWW::Mechanize->new(agent => $AGENT);
    $mech->get($url);
    
    # if we weren't successful in our request then report the error.
    unless ($mech->success()) {
        carp($Lyrics::Fetcher::Error = 
                "Unable to retreive url from www.lyrics007.com");
        return;
    }
    $mech->follow_link(text_regex => qr/print(?:able)?/i);

    # if we followed the link successfuly then we'll clean up
    # the lyrics and return them.
    if ($mech->status() =~ m/200/) { 
        # grab the page contents.
        my $lyrics = $mech->response()->content();
    
        # swap out the html breaks for newlines
        $lyrics =~ s/<br(?: \/)?>/\n/gi;
        
        # get shot of the lyrics007 tagline.
        $lyrics =~ s/This is lyrics from www.lyrics007.com(?:\n)?//gi;
        
        # and get shot of the title.
        $lyrics =~ s/Tit?le\s?:.+\n//gi;

        # if we have some form of lyrics at this point then
        # return them, else error0z      
        if ($lyrics ne "") {
            return $lyrics;
        } else {
            $Lyrics::Fetcher::Error = "Lyrics not found!";
            return;
        }
    
    } else {
        carp ($Lyrics::Fetcher::Error = 
              "URL Request Failed");# $response->status_line");
        return;
    }
}


# Uppercase all the words passed in a string.
sub _title_case_all {
    return join ' ', map { ucfirst $_ } split /\s/, lc $_;
}


1; 

__END__ # End of Lyrics::Fetcher::Lyrics007

=head1 NAME

Lyrics::Fetcher::Lyrics007 
    - Fetcher module for David Precious' (BIGPRESH) Lyrics::Fetcher 


=head1 SYNOPSIS

    use Lyrics::Fetcher::Lyrics007
    print Lyrics::Fetcher::Lyrics007->fetch('<band>', '<track>');


=head1 DESCRIPTION

Module to obtain song lyrics from www.lyrics007.com. 
Written to be used by Lyrics::Fetcher but can be used standalone.


=head1 INTERFACE

=over 4

=item fetch($band, $track) 

Tries to obtain lyrics for the given track by the 
given band. 

=back


=head1 VERSION

Version 0.04


=head1 AUTHOR

James Ronan, C<< <james at ronanweb.co.uk> >>


=head1 BUGS

Highly Likely as this is my first perl module.

The other point to note is this module relies on the format of www.lyrics007.com
remaining 'as is'; Therfore if the site changes this module will be rendered 
useless. If this happens let me know and I'll fix it! (If I haven't started the
rewrite already)


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lyrics::Fetcher::Lyrics007

=head1 ACKNOWLEDGEMENTS

Bigup to David Precious for helping me get my Perl code off the ground 
by writing this module (which is inspired by one of his own).


=head1 COPYRIGHT & LICENSE

Copyright 2008 James Ronan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut


