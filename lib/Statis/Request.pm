package Statis::Request;

use 5.010;
use strict;
use warnings;

use base 'Plack::Request';
use Hash::MultiValue;

use Statis::Util;

sub body_parameters {
    my $self = shift;

    unless ($self->env->{'plack.request.body'}) {
        $self->_parse_request_body;

        # Accept JSON, TODO more serializers
        my $type = $self->content_type();
        if ($type and $type eq 'application/json') {
            my $json = Statis::Util::hashify($self->content);
            my $body = Hash::MultiValue->from_mixed($json);
            $self->env->{'plack.request.body'} = $body;
        }

    }

    return $self->env->{'plack.request.body'};
}

1;
