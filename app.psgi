#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;
use Digest::SHA1 qw(sha1_hex);

sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $url = $req->param("url");

    return $req->new_response(404)->finalize unless $url;

    my $file = "storage/" . sha1_hex($url) . ".png";

    unless (-f $file) {
        my $exit_status = system("phantomjs", "rasterize.js", $url, $file);

        if ($exit_status != 0 || !(-f $file)) {
            return $req->new_response(404)->finalize;
        }
    }

    my $res = $req->new_response(200);
    $res->headers([ 'X-Accel-Redirect' => "/$file" ]);
    $res->finalize;
}
