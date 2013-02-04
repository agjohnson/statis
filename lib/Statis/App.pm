package Statis::App;

use 5.010;
use strict;
use warnings;

use Statis::Backend qw/route template/;
#use Statis::API;
use Statis::Static;
use Statis::Socket;

use Plack::Builder;
use Plack::Middleware::Static;
use SockJS;
use Cwd;
use FindBin;

our $Path = Cwd::abs_path($FindBin::Bin);

sub app {
    builder {
        # TODO disable this with config?
        enable(
            "Plack::Middleware::Static",
            path => sub { s#^/static/## },
            root => 'public/'
        );

        mount '/event' => sub {
            my $env = shift;
            my $sck = SockJS->new(
                handler => \&Statis::Socket::event
            );
            # Plackup sets SERVER_PROTOCOL = HTTP/1.1, Twiggy uses 1.0, but
            # Plack::Middleware::Chunked checks the SERVER_PROTOCOL header for
            # setting chunked return
            return $sck->call({
                %{$env},
                SERVER_PROTOCOL => 'HTTP/1.0'
            });
        };
        mount '/' => \&Statis::Backend::app;
    };
}

1;
