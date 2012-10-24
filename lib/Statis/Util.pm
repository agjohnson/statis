package Statis::Util;

use 5.010;
use strict;
use warnings;

use JSON;

use Exporter 'import';
our @EXPORT_OK = qw/stringify/;

# Scalar to JSON
sub stringify {
    my $obj = shift;
    my $json = JSON->new->allow_nonref->allow_blessed->convert_blessed;
    # TODO catch error here
    return $json->encode($obj);
}

# JSON to hash
sub hashify {
    my $obj = shift;
    my $json = JSON->new->allow_nonref;
    # TODO catch error here
    return $json->decode($obj);
}

sub response {
    my $obj = shift;
    if (ref $obj eq 'HASH') {
        # TODO check for type
        $obj = stringify($obj);
    }
    return Plack::Response->new(
        200,
        {'Content-type' => 'application/json'},
        [$obj]
    );
}

1;
