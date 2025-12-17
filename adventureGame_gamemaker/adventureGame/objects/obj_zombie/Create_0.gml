my_speed = 0.25;


_x_direction = choose(0, 1, -1);
_y_direction = choose(0, 1, -1);

direction_facing = direction;


collision_tilemap_id = layer_tilemap_get_id("tile_walls"); //collision tilemap
_collision_objects = [ // things you can collide with
    obj_destructable,
	obj_playerTest
];
//full collection of collision objects
_full_collision_set = array_concat([collision_tilemap_id], _collision_objects);



// --- Shake Variables ---
// uses scr_shake and scr_update_shake
shake_duration = 0; // how long
shake_magnitude = 0; // how intense
shake_time = 0;
hit_flash = false; // Tracks if the flash is currently active
flash_countdown = 0;

_is_hit = false;

_health = 3;

_hspd = 0;
_vspd = 0;


image_speed = 0.5;

