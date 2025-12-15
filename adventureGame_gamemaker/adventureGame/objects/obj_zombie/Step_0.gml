




// Movement - walking
// Calculate the direction angle in degrees
var _dir = point_direction(0, 0, _x_direction, _y_direction);
    
// Calculate the movement components for the given angle and speed
// This uses trig functions (sin/cos) to split the speed correctly.
var _hspd = lengthdir_x(my_speed, _dir);
var _vspd = lengthdir_y(my_speed, _dir);
    
move_and_collide(_hspd, _vspd, collision_tilemap_id, true, true);	


if (_hspd != 0 || _vspd != 0)
{
    var _angle = point_direction(0, 0, _hspd, _vspd);
	var _frame_offset = 0;
    
    // We adjust the angle slightly before checking ranges to handle the 0°/360° wrap-around.
    // Adding 45 ensures the right direction (0°) covers the -45° to +45° range.
    var _adj_angle = (_angle + 45) mod 360;
    
    // 2. Determine the Cardinal Direction
    if (_adj_angle < 90) // Between 315° and 45°
    {
        // Facing Right
        _frame_offset =  4 // Face right
		image_xscale = 1; // Face left	
        
    }
    else if (_adj_angle < 180) // Between 45° and 135°
    {
        // Facing Up
        _frame_offset = 8;
    }
    else if (_adj_angle < 270) // Between 135° and 225°
    {
        // Facing Left
        _frame_offset = 4 
        image_xscale = -1; // Face left
    }
    else // Between 225° and 315°
    {
        // Facing Down
        _frame_offset = 0; 
    }
	
	//image_index = _frame_offset;
	
	if(_is_hit = false){ // looping animation
		if (image_index >= _frame_offset + 4) {
			// If we passed the end of the intended block, loop back to the start of that block.
			image_index = _frame_offset;
		}	
	}	
	
}




	
	
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