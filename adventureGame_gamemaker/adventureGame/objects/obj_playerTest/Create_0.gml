my_speed = 4;
direction_facing = 270; // Start facing 'down' (270 degrees)
has_attacked = false; // make sure attacks don't stack

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
	
	// Code to start sword swing after certain frames play
	// 1. Get the frame data for the current direction 
    var _total_frames = sprite_get_number(sprite_index);
    var _frames_per_dir = _total_frames / 3;
    
    // 2. Identify which "strip" we are on (Down, Side, or Up)
    var _dir_idx = (direction_facing == 90) ? 2 : (direction_facing == 270 ? 0 : 1);
    var _start_frame = _dir_idx * _frames_per_dir;

    // 3. Calculate how many frames we have played in the CURRENT direction
    var _relative_frame = floor(image_index - _start_frame);

    // 4. Create the hitbox on the 3rd frame (index 2)
    if (_relative_frame == 1 && !has_attacked) {
        swordSwing();
        has_attacked = true;
    }
};


states = {
    idle:  new State(spr_hero_idle, 1, true, undefined, move_behavior),
    walk:  new State(spr_hero_run, 1.0, true, undefined, move_behavior),
    attack: new State(spr_hero_attack, 1.2, false, "idle", attack_behavior)
};

state = states.idle; // Set initial state


