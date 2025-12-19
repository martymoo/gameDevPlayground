my_speed = 3;
direction_facing = 270; // Start facing 'down' (270 degrees)
has_attacked = false; // make sure attacks don't stack


mask_index = spr_hero_idle;

//charge attack stuff
charge_input_buffer = 0;
charge_input_threshold = 10; // Frames to hold before charge begins
charge_timer = 0;
charge_limit = 60; // How many frames to full charge (e.g., 60 = 1 second)
is_fully_charged = false;

//collision stuff
collision_tilemap_id = layer_tilemap_get_id("tile_walls");
_collision_objects = [ // things you can collide with
    obj_destructable
];
//full collection of collision objects
_full_collision_set = array_concat([collision_tilemap_id], _collision_objects);
//end collision stuff



// STATES

// Capture user input
get_input = function() {
    var _right = keyboard_check(vk_right) or keyboard_check(ord("D"));
    var _left  = keyboard_check(vk_left)  or keyboard_check(ord("A"));
    var _up    = keyboard_check(vk_up)    or keyboard_check(ord("W"));
    var _down  = keyboard_check(vk_down)  or keyboard_check(ord("S"));
	
    
    input_x = _right - _left;
    input_y = _down - _up;
    input_action = keyboard_check_pressed(vk_space);
	input_test = keyboard_check(ord("1"));
}



var idle_behavior = function() {
   // behaviors here
};

var walk_behavior = function() {
	// behaviors here
};


// MOVE LOGIC (Shared by Walk and Idle)
move_behavior = function() {
    if (input_x != 0 || input_y != 0) {
        // 1. Calculate direction
        var _move_dir = point_direction(0, 0, input_x, input_y);
        
        // 2. Update direction_facing (only when moving)
        // This snaps the input to 0, 90, 180, 270 for the animator
        direction_facing = round(_move_dir / 90) * 90;
        if (direction_facing == 360) direction_facing = 0;

        // 3. Move and Collide
        var _hspd = lengthdir_x(my_speed, _move_dir);
        var _vspd = lengthdir_y(my_speed, _move_dir);
        move_and_collide(_hspd, _vspd, _full_collision_set);
		moving = true;
    }
}

swordSwing = function(){
	var _hitbox_offset_x = 0;
	var _hitbox_offset_y = 0;

	if (direction_facing == 0){ // right
			_hitbox_offset_x = 10;
			_hitbox_offset_y = 0;
		} else if (direction_facing == 180){ // left 
			_hitbox_offset_x = -10;
			_hitbox_offset_y = 0;
		} else if (direction_facing == 90){ // up
			_hitbox_offset_x = 0;
			_hitbox_offset_y = -12;
		} else if (direction_facing == 270){ //down
			_hitbox_offset_x = 0;
			_hitbox_offset_y = 12;
	}

	instance_create_depth(x + _hitbox_offset_x, y + _hitbox_offset_y, 0, obj_hitbox);
	show_debug_message("i made a hitbox");

	has_attacked = false; 
}

var attack_behavior = function(){
	move_behavior();
	
	var _rel_frame = get_relative_frame();
	

    // 4. Create the hitbox on the 3rd frame (index 2)
    if (_rel_frame == 1 && !has_attacked) {
        swordSwing();
        has_attacked = true;
    }
	
	// If we are at the end of the swing and space is STILL held, start charging
	if (keyboard_check(vk_space)) {
        charge_input_buffer++;
    } else {
        charge_input_buffer = 0;
    }

    // Only transition to charge if they've held it past the threshold 
    // AND the swing animation is nearly done
    if (_rel_frame >= 3 && charge_input_buffer >= charge_input_threshold) {
        state = states.charge;
        charge_input_buffer = 0;
        has_attacked = false; // Reset for next state
    }
	
};

var spin_behavior = function() {
// 1. Movement logic (inherited from move_behavior) [cite: 107]
    move_behavior(); 
	
	var _rel_frame = get_relative_frame(); // starting frame
    
    // Adjust these frame numbers based on your spr_hero_spin length
    if (_rel_frame == 0 && !has_attacked) {
        instance_create_depth(x, y, depth + 1, obj_spin_flare);
        has_attacked = true; // Prevents double-spawning on frame 0 
    }
    
    if (_rel_frame == 2 && has_attacked == true) {
        instance_create_depth(x, y, depth + 2, obj_spin_flare);
        var _inst = instance_create_depth(x, y, depth, obj_hitbox);
        _inst.image_xscale = 2; // Make the hitbox larger for the spin
        _inst.image_yscale = 2;
		_inst.damage = 2;
        has_attacked = 2; // Iterating the flag to track stages
    }
    
if (_rel_frame == 4 && has_attacked == 2) {
        instance_create_depth(x, y, depth + 3, obj_spin_flare);
        has_attacked = 3; // Keep it at 3 so it doesn't repeat!
    }

};

var charge_behavior = function() {
    // 1. Half-speed movement
    var _temp_speed = my_speed;
    my_speed = _temp_speed * 0.5;
    move_behavior();
    my_speed = _temp_speed; 
	
	if (input_x != 0 || input_y != 0) {
        state.sprite = spr_hero_run;
    } else {
        state.sprite = spr_hero_idle;
    }

    charge_timer++;
	
	if(is_fully_charged){

	}

    // 2. Visual Effects: Flashing and Sparks
    if (charge_timer >= charge_limit) {
        is_fully_charged = true;
        // Spawn sparks sporadically
		if (charge_timer % 6 == 0) {
            instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth - 1, obj_spark);
        }	

    }

    // 3. Release Logic: Trigger Spin or Return to Idle
    if (!keyboard_check(vk_space)) {
        if (is_fully_charged) {
            state = states.spinattack;
        } else {
            state = states.idle;
        }
        // Cleanup
        charge_timer = 0;
        is_fully_charged = false;
        gpu_set_fog(false, c_white, 0, 0); 
    }
};


states = {
    idle:  new State(spr_hero_idle, 1, true, undefined, move_behavior),
    walk:  new State(spr_hero_run, 1.0, true, undefined, move_behavior),
    attack: new State(spr_hero_attack, 1.5, false, "idle", attack_behavior),
	spinattack: new State(spr_hero_spin_attack, 1, false, "idle", spin_behavior), 
	charge: new State(spr_hero_idle, 1, true, undefined, charge_behavior)
};

state = states.idle; // Set initial state


