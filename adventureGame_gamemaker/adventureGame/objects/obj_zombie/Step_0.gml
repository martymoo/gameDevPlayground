
if(_is_hit = false){
	if (image_index >= 2) {
		// If we passed the end of the intended block, loop back to the start of that block.
		image_index = 0;
	}	
}

    // Calculate the direction angle in degrees
    var _dir = point_direction(0, 0, _x_direction, _y_direction);
    
    // Calculate the movement components for the given angle and speed
    // This uses trig functions (sin/cos) to split the speed correctly.
    var _hspd = lengthdir_x(my_speed, _dir);
    var _vspd = lengthdir_y(my_speed, _dir);
    
    move_and_collide(_hspd, _vspd, collision_tilemap_id, true, true);
	
	
	
//resolve collisions
// Move and get collisions with the specified tilemap ID
var _colliding_elements = move_and_collide(_hspd, _vspd, collision_tilemap_id); 

if (array_length(_colliding_elements) > 0) {
    for (var i = 0; i < array_length(_colliding_elements); i++) {
        var _collider_id = _colliding_elements[i];
        
        // Check if the collider is indeed the tilemap (optional, as you only passed one target)
        //if (is_tilemap(_collider_id)) {
            // Actions specific to tile collision
            //show_debug_message("Hit a tile!");
			alarm_set(1, 1);
            // You can use tilemap_get_at_pixel() with extra math to find the specific tile data if needed
        //}
    }
}	