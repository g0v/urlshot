#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;
use Digest::SHA1 qw(sha1_hex);

my $output_directory = $ENV{URLSHOT_STORAGE_DIRECTORY} or die;
my $APP_HOME = $ENV{APP_HOME} or die;

sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $url = $req->param("url");

    return $req->new_response(404)->finalize unless $url;

    my $basename = sha1_hex($url) . ".png";
    my $file = $output_directory . "/" . $basename;


    unless (-f $file) {
        my $exit_status = system("phantomjs", "${APP_HOME}/rasterize.js", $url, $file);

        if ($exit_status != 0 || !(-f $file)) {
            return $req->new_response(404)->finalize;
        }
    }

    my $res = $req->new_response(200);
    $res->headers([ 'X-Accel-Redirect' => "/storage/$basename" ]);
    $res->finalize;
}
