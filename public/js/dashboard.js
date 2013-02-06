/* Dashboard */

var socket = new SockJS('/event');

socket.onopen = function () {
    console.log('open');
}

socket.onclose = function () {
    console.log('close');
}

socket.onmessage = function (rep) {
    state = JSON.parse(rep.data);
    if (state.event == 'on_update') {
        updateGrid(state);
        updateState(state);
    }
};

// Grid update
function updateGrid(state) {
    var grid_found = $('#grid-' + state.id);
    if (!grid_found.length) {
        grid_found = $('<div/>');
        grid_found.attr('id', 'grid-' + state.id);
        grid_found.addClass('state state-' + state.value);
        grid_found.hide();
        $('#grid').append(grid_found);
        grid_found.fadeIn();
    }
    else {
        grid_found.removeClass();
        grid_found.addClass('state state-' + state.value);
    }
}

// State log update
function updateState(state) {
    var msg = $('<div/>'),
        icon = $('<div/>'),
        text = $('<span/>');

    if (state.value == 'pass') {
        icon.attr('icon', 'W');
    }
    if (state.value == 'warn') {
        icon.attr('icon', 'c');
    }
    if (state.value == 'fail') {
        icon.attr('icon', 'X');
    }

    icon.addClass('icon');
    msg.append(icon);

    text.html(state.title + ' is now ' + state.value);
    msg.append(text);

    msg.addClass('state state-' + state.value);
    msg.hide();
    $('#states').prepend(msg);
    msg.slideDown(200);

    setTimeout(function () {
        msg.fadeOut(500, function () {
            msg.remove();
        });
    }, 10000);

}
