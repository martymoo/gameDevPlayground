


var _half_fov = view_angle / 2;

// Calculate the two outer points of the triangle
var _x2 = x + lengthdir_x(view_distance, fov_dir - _half_fov);
var _y2 = y + lengthdir_y(view_distance, fov_dir - _half_fov);

var _x3 = x + lengthdir_x(view_distance, fov_dir + _half_fov);
var _y3 = y + lengthdir_y(view_distance, fov_dir + _half_fov);

// Draw the triangle with transparency
draw_set_alpha(0.3);
draw_set_color(c_yellow);

// Create a small flicker effect using random or a sine wave
var _flicker = 0.4 + (sin(get_timer() / 100000) * 0.1);

draw_set_alpha(_flicker);
// scr_draw_fov_flashlight(view_distance, view_angle, fov_dir, collision_tilemap_id, 40);
draw_set_alpha(1.0);

// Reset draw settings so other objects aren't affected
//draw_set_alpha(1.0);
//draw_set_color(c_white);