draw_self();

var _draw_x = x + shake_x_offset;
var _draw_y = y + shake_y_offset;

// 2. Draw the sprite at the new, offset position

// 2. Draw the sprite at the new, offset position
draw_sprite_ext(
    sprite_index, 
    image_index, 
    _draw_x, 
    _draw_y, 
    image_xscale, 
    image_yscale, 
    image_angle, 
    image_blend, // <-- This is what holds c_white for the flash frame!
    image_alpha
);