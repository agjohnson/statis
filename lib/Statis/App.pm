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

        mount '/event' => SockJS->new(
            handler => \&Statis::Socket::event
        );
        mount '/' => \&Statis::Backend::app;
    };
}

1;
