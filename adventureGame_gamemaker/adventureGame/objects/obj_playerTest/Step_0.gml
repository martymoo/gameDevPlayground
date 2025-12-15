var _right = keyboard_check(vk_right) or keyboard_check(ord("D"));
var _left = keyboard_check(vk_left) or keyboard_check(ord("A"));
var _up = keyboard_check(vk_up) or keyboard_check(ord("W"));
var _down = keyboard_check(vk_down) or keyboard_check(ord("S"));
var _action = keyboard_check_pressed(vk_space);

//get direction
var _xinput = _right - _left;
var _yinput = _down - _up;


// Check if there is any movement input
if (_xinput != 0 || _yinput != 0)
{
    // Calculate the direction angle in degrees
    var _dir = point_direction(0, 0, _xinput, _yinput);
    
    // Calculate the movement components for the given angle and speed
    // This uses trig functions (sin/cos) to split the speed correctly.
    var _hspd = lengthdir_x(my_speed, _dir);
    var _vspd = lengthdir_y(my_speed, _dir);
    
    move_and_collide(_hspd, _vspd, collision_tilemap_id, true, true);
}


//Determining facing directions
var _moving = (_left || _right || _up || _down); // Check if *any* movement key is down

if (_moving) {
    if (_left) {
        direction_facing = 180; // Left
    }
    if (_right) {
        direction_facing = 0;   // Right
    }
    if (_up) {
        direction_facing = 90;  // Up
    }
    if (_down) {
        direction_facing = 270; // Down
    }
    // Note: If multiple are pressed (e.g., up and right), the last one in this sequence wins.
}


/////////    STATE MACHINE     ///////////

switch (state)
{
    case STATE.NORMAL:
        // Handle input for movement (walking/running)
		//TODO - consider just creating multiple sprites for states, this is too complicated
		// --- Sprite Selection ---
		var _target_sprite = _moving ? spr_hero_run : spr_hero_idle; // run or idle
		var _frames_per_direction = _moving ? 6 : 4; // 6 for Run, 4 for Idle

		var frame_offset = 0;
		image_xscale = 1; // Default to facing Right (no mirroring)

		// Use direction_facing to find the starting frame index and mirroring
		if (direction_facing == 0) { // Right (Base Direction)
			// Down, Right, Up -> Right is the second set (index 1)
			frame_offset = _frames_per_direction * 1; 
			image_xscale = 1;
		} else if (direction_facing == 180) { // Left (Mirror Right)
			// Find the Right frames, but flip the sprite
			frame_offset = _frames_per_direction * 1; 
			image_xscale = -1; // *** This is the mirroring line ***
		} else if (direction_facing == 90) { // Up
			// Up is the third set (index 2)
			frame_offset = _frames_per_direction * 2; 
			image_xscale = 1; // No mirroring for vertical movement
		} else if (direction_facing == 270) { // Down
			// Down is the first set (index 0)
			frame_offset = _frames_per_direction * 0; 
			image_xscale = 1; // No mirroring for vertical movement
		}


		// Only change the sprite if it's different to prevent resetting the animation
		if (sprite_index != _target_sprite) {
			sprite_index = _target_sprite;
    
			// Crucial: When we switch sprites, we set the image_index to the offset,
			// which tells GameMaker where in the strip to START the animation.
			image_index = frame_offset; 
		}

		// Set animation speed
		image_speed = 1; // Use frames per second instead of raw speed (Example: 6 FPS vs 8 FPS)

		// Check if the current frame is outside the intended directional block.
		// Example: If frame_offset is 6 (Up), the animation should cycle 6, 7, 8...
		// If image_index reaches 9 (the start of the next block), we loop it back to the start (6).

		// need to check if it loops back on the "up" direciton to zero
		if (image_index >= frame_offset + _frames_per_direction) {
			// If we passed the end of the intended block, loop back to the start of that block.
			image_index = frame_offset;
		}		
		
		
        // Check for the action key (Spacebar) to transition to ACTION state
        if (_action)
        {
            // Initiate the action state
            state = STATE.ACTION;
            // Set the animation/action properties
			var _swing_direction = direction_facing;
			sprite_index = spr_hero_attack;
			image_speed = 1.5;
	
			show_debug_message($"Attack, facing: {direction_facing} - 0 right, 90 up, 180 left, 270 down");
			if (_swing_direction == 0){ // right
				image_index = 5;
			} else if (_swing_direction == 180){ // left 
				image_index = 5;
				image_xscale = -1;
			} else if (_swing_direction == 90){ // up
				image_index = 10;
			} else if (_swing_direction == 270){ //down
				image_index = 0;
			}
			
            action_timer = action_duration;
			
			swing_start_frame = image_index;
			alarm_set(0, 1); // create hitbox object!
            
            // EXECUTE THE ACTION CODE (e.g., Create a weapon object)
            // Example:
           // var _weapon = instance_create_layer(x, y, "Instances", obj_sword_hitbox);
           
        }
        break;

    case STATE.ACTION:
        // Update the action timer
        action_timer--;
		
		if (image_index >= swing_start_frame + 4) {
			image_speed = 0;
		}
        
        // Check if the action is complete
        if (action_timer <= 0)
        {
            // Transition back to the NORMAL state
            state = STATE.NORMAL;
            // Reset sprite to the appropriate idle/walk sprite
            //sprite_index = spr_hero_idle; // Or whatever is appropriate
        }
        break;
}


/////////  END STATE MACHINE   ///////////
