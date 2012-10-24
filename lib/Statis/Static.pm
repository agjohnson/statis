package Statis::Static;

use 5.010;
use strict;
use warnings;

use Statis::Backend qw/route template/;

route 'get', '^/$' => sub {
    my $req = shift;
    return template 'index.html';
};

1;
