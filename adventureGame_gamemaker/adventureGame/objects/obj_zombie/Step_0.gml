



// Movement - walking
// Calculate the direction angle in degrees
var _dir = point_direction(0, 0, _x_direction, _y_direction);
    
// Calculate the movement components for the given angle and speed
// This uses trig functions (sin/cos) to split the speed correctly.
_hspd = lengthdir_x(my_speed, _dir);
_vspd = lengthdir_y(my_speed, _dir);
    
move_and_collide(_hspd, _vspd, collision_tilemap_id, true, true);	


if (_hspd != 0 || _vspd != 0)
{
    var _angle = point_direction(0, 0, _hspd, _vspd);
	var _frame_offset = 0;
	var _frame_multiplier;
	if(_is_hit){
		_frame_multiplier = 3;
	} else {
		_frame_multiplier = 4;
	}
    
    // We adjust the angle slightly before checking ranges to handle the 0°/360° wrap-around.
    // Adding 45 ensures the right direction (0°) covers the -45° to +45° range.
    var _adj_angle = (_angle + 45) mod 360;
    
    // 2. Determine the Cardinal Direction
    if (_adj_angle < 90) // Between 315° and 45°
    {
        // Facing Right
		direction_facing = 0;
        _frame_offset =  1 // Face right
		image_xscale = 1; // Face left	
        
    }
    else if (_adj_angle < 180) // Between 45° and 135°
    {
        // Facing Up
		direction_facing = 90;
        _frame_offset = 2;
    }
    else if (_adj_angle < 270) // Between 135° and 225°
    {
        // Facing Left
		direction_facing = 180;
        _frame_offset = 1 
        image_xscale = -1; // Face left
    }
    else // Between 225° and 315°
    {
        // Facing Down
		direction_facing = 270;
        _frame_offset = 0; 
    }
	
	//image_index = _frame_offset;
	
	//if(_is_hit = false){ // looping animation
		if (image_index >= (_frame_offset * _frame_multiplier) + _frame_multiplier) {
			// If we passed the end of the intended block, loop back to the start of that block.
			image_index = _frame_offset * _frame_multiplier;
		}	
	//} else {
	
	//}
	
}

		
//resolve collisions to bounce off walls
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

// --- Cone of Vision Visualization ---
// Define the cone parameters (must match the Step Event logic)
var _max_range = 300;
var _fov_angle = 60; // Total cone width is 120 degrees (60 left, 60 right)

// 1. Calculate the three corner points of the triangle (the cone)

// Point 1: The enemy's center (the cone origin)
var _x1 = x;
var _y1 = y;

// Point 2: The left edge of the cone at max range
var _left_angle = image_angle + _fov_angle;
var _x2 = x + lengthdir_x(_max_range, _left_angle);
var _y2 = y + lengthdir_y(_max_range, _left_angle);

// Point 3: The right edge of the cone at max range
var _right_angle = image_angle - _fov_angle;
var _x3 = x + lengthdir_x(_max_range, _right_angle);
var _y3 = y + lengthdir_y(_max_range, _right_angle);

// 2. Set the drawing properties
draw_set_alpha(0.3); // Set transparency (0.3 is 30% opaque)
draw_set_color(c_yellow); // Set the color of the cone

// 3. Draw the filled triangle primitive
draw_triangle(_x1, _y1, _x2, _y2, _x3, _y3, false); // 'false' means it's a filled triangle

// 4. Reset drawing properties (CRUCIAL! So you don't affect other draws)
draw_set_alpha(1);
draw_set_color(c_white);

// 5. Draw the sprite (if you are not using draw_self() at the end)
// draw_self();