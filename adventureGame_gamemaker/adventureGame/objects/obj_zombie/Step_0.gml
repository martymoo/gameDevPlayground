// Movement - walking
// Calculate the direction angle in degrees
var _dir = point_direction(0, 0, _x_direction, _y_direction);
    
// Calculate the movement components for the given angle and speed
// This uses trig functions (sin/cos) to split the speed correctly.
_hspd = lengthdir_x(my_speed, _dir);
_vspd = lengthdir_y(my_speed, _dir);
    
// move_and_collide(_hspd, _vspd, collision_tilemap_id, true, true);	
var _tilemap_colliders = noone;

// do a shake test!
scr_update_shake();

if (_hspd != 0 || _vspd != 0)
{
    var _angle = point_direction(0, 0, _hspd, _vspd);
	direction = _angle;
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
if (knockback_hspeed == 0 && knockback_vspeed == 0) { //only if not hit
	var _tilemap_colliders = move_and_collide(_hspd, _vspd, collision_tilemap_id);
}

if (abs(knockback_hspeed) > 0.1 || abs(knockback_vspeed) > 0.1) {
    
    // 2. Perform the movement (handling wall collisions)
    var _tilemap_colliders = move_and_collide(knockback_hspeed, knockback_vspeed, collision_tilemap_id);
    
    // 3. APPLY DECAY (Friction)
    // lerp moves a value toward 0 by a percentage (0.1 = 10% reduction per frame)
    knockback_hspeed = lerp(knockback_hspeed, 0, 0.5);
    knockback_vspeed = lerp(knockback_vspeed, 0, 0.5);
    
} else {
    // 4. Fully reset speeds once they get low enough to avoid "micro-movements"
    knockback_hspeed = 0;
    knockback_vspeed = 0;
}


// FIELD OF VIEW STUFF 


if (abs(_hspd) > 0.1 || abs(_vspd) > 0.1) {
    var _target_dir = point_direction(0, 0, _hspd, _vspd);
    
    // Smoothly rotate fov_dir toward the target_dir
    // 0.1 is the speed of the turn (lower is slower)
    fov_dir += angle_difference(_target_dir, fov_dir) * 0.1;
}

// Only check if the player exists to avoid errors
if (instance_exists(obj_playerTest)) {
    var _can_see = scr_can_see_unit(id, obj_playerTest, view_distance, view_angle, fov_dir, collision_tilemap_id);
    
    if (_can_see) {
        // state = ENEMY_STATE.CHASE; // Switch to aggro
        show_debug_message("I SEE YOU!");
    }
}




/// COLLISION STUFF
if (array_length(_tilemap_colliders) > 0) {
    // If you hit a tilemap wall, change direction
    alarm_set(1, 1);
    // You can stop processing further movement here if you hit a solid wall.
}

if (array_length(_tilemap_colliders) == 0) { // collision check
    // Calculate the target position
    var _target_x = x + _hspd;
    var _target_y = y + _vspd;
// Check if any object in the list is at the target position
    for (var i = 0; i < array_length(_collision_objects); i++) {
        var _object_index = _collision_objects[i];
        
        // Use instance_place to check for collision with the *type* of object
        var _hit_instance = instance_place(_target_x, _target_y, _object_index);
        
        if (_hit_instance != noone) {
            // Collision detected with an object!
            show_debug_message("i hit something");
			if (_hit_instance.object_index == obj_destructable) { // furniture collision
				alarm_set(1, 1);
				show_debug_message("it's a destructable");
			} else if (_hit_instance.object_index == obj_playerTest){ //player collision!
				scr_shake_object(10, 3);
				alarm_set(1, 1);
				show_debug_message("i hit player");				
			}
            
            break; 
        }
    }
}	
