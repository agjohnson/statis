package Statis::Backend;

use 5.010;
use strict;
use warnings;

use Plack::Response;
use Plack::Request;
use Template;
use FindBin;
use Cwd;

use Statis::Util qw/stringify/;
use Statis::Request;

use Exporter 'import';
our @EXPORT_OK = qw/
  route
  app
  template
  render
  error
/;


our $Path = Cwd::abs_path($FindBin::Bin . "/view");
our $Routes = {};

sub app {
    my $env = shift;

    my $req = Statis::Request->new($env);
    my $path = $req->path_info;
    my $method = $req->method;

    foreach my $route (@{$Routes->{$method}}) {
        my $route_path = $route->{path};
        if (my @args = ($path =~ m#$route_path#)) {
            return $route->{callback}($req);
        }
    }

    return Plack::Response->new(
        404,
        {},
        'Not found'
    )->finalize;
}

sub route ($$&) {
    my ($method, $path, $callback) = @_;
    push(@{$Routes->{uc $method}}, {
        path => $path,
        callback => $callback
    });
}

# Return response rendered from TT2 template
sub template ($;$) {
    my ($template, $args) = @_;

    # Try to process the template, croak on errors, return response
    my $output = "";
    my $t = Template->new({
        INCLUDE_PATH => $Path,
    }) or die "Error setting up template processor";

    $t->process($template, $args, \$output)
      or die "Problem with template";

    return Plack::Response->new(
        200,
        {},
        [$output]
    )->finalize;
}

# Renders a response
sub render ($) {
    my $val = shift;
    if (ref $val eq 'Plack::Response') {
        return $val->finalize;
    }
    if (ref $val eq 'HASH') {
        return Plack::Response->new(
            200,
            {'Content-type' => 'application/json'},
            [stringify($val)]
        )->finalize;
    }
    return Plack::Response->new(
        200,
        {'Content-type' => 'text/html'},
        [$val]
    )->finalize;
}

# Returns json error
sub error ($$) {
    my $errcode = shift;
    my $errmsg = shift;
    return Plack::Response->new(
        $errcode,
        ['Content-type' => 'application/json'],
        [$errmsg]
    )->finalize;
}

1;
