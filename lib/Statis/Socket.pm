package Statis::Socket;

use 5.010;
use strict;
use warnings;

use AnyEvent::Statis;

sub event {
    my $socket = shift;

    # Output closure for emitting events
    my $output = sub {
        my ($event, $state) = @_;
        $socket->sockets->emit($event => {
            id => $state->id,
            title => $state->title,
            value => $state->value,
            type => $state->type,
            extra => $state->extra
        });
    };

    # Pass Statis events through to sockets
    my $db  = AnyEvent::Statis->new(
        on_create => sub { $output->('on_create', @_) },
        on_update => sub { $output->('on_update', @_) },
        on_receive => sub { $output->('on_receive', @_) }
    );
    $db->listen();
}

1;
