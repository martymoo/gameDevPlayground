my_speed = 0.25;


_x_direction = choose(0, 1, -1);
_y_direction = choose(0, 1, -1);

direction_facing = direction;

collision_tilemap_id = layer_tilemap_get_id("tile_walls");

_is_hit = false;

image_speed = 0.5;

