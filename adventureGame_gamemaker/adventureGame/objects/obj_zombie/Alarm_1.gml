// todo be smart & flip direction or something
var _current_x_direction = _x_direction;
var _current_x_direction = _y_direction;


show_debug_message("Change direction!");

_x_direction = choose(0, 1, -1);
_y_direction = choose(0, 1, -1);