display_set_gui_size(320, 180); // GUI camera

my_speed = 2;
direction_facing = 270; // Start facing 'down' (270 degrees)
has_attacked = false; // make sure attacks don't stack


mask_index = spr_hero_idle; // reduce collision bugs

//health
hp = 3;
hp_max = 5;
hp_sprite = spr_heart_small;

//hit variables
hit_knockback_dir = 0;
hit_knockback_speed = 6; 
hit_timer = 0;
hit_duration = 15; // Frames the player is stunned/knocked back

shake_duration = 0;
shake_magnitude = 0;
shake_time = 0;
hit_flash = false;
flash_countdown = 0;

invincible_timer = 0;
invincible_duration = 60; // 1 second at 60fps

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

//dust particles
is_walking = false;     // Tracks if we were moving last frame
dust_timer = 0;        // Countdown for the next puff
dust_interval = 25;    // Number of frames between puffs (adjust for more/less dust)

//weapon type
bullet_type = "basic";


// STATES

// Capture user input
get_input = function() {
    var _right = keyboard_check(vk_right) or keyboard_check(ord("D"));
    var _left  = keyboard_check(vk_left)  or keyboard_check(ord("A"));
    var _up    = keyboard_check(vk_up)    or keyboard_check(ord("W"));
    var _down  = keyboard_check(vk_down)  or keyboard_check(ord("S"));
	var _shift = keyboard_check(vk_shift);
    
	input_shift = _shift;
    input_x = _right - _left;
    input_y = _down - _up;
    input_action = keyboard_check_pressed(vk_space);
	input_test = keyboard_check_pressed(ord("1"));
}



var idle_behavior = function() {
   // behaviors here
   move_behavior();
   
   if(input_test){
	show_debug_message("pew");
	shoot_bullet();
   }
   
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

		var _current_speed;
		var _dust_speed;

		if (input_shift) {
		    _current_speed = my_speed * 1.75;
			_dust_speed = dust_interval / 3;
		} else {
		    _current_speed = my_speed;
			_dust_speed = dust_interval;
		}

        // 3. Move and Collide
        var _hspd = lengthdir_x(_current_speed, _move_dir);
        var _vspd = lengthdir_y(_current_speed, _move_dir);
        move_and_collide(_hspd, _vspd, _full_collision_set);
		
		//make dust particles
		// instance_create_depth(x,y + 6, depth +1, obj_dust);	
		var _dist = 6; 
        var _dust_x = x + lengthdir_x(_dist, direction_facing + 180) + irandom_range(-2, 2);
        var _dust_y = y + 6 + irandom_range(-2, 2); // Still offset down for feet

        if (!is_walking) {
            // This is the START of movement (First Frame)
			var _dust = instance_create_depth(_dust_x, _dust_y, depth + 1, obj_dust);

			// 1. Flip based on direction
			_dust.image_xscale = (direction_facing == 0) ? -1 : 1;

			// 2. Add random rotation jitter
			_dust.image_angle = random_range(-15, 15);

			// 3. Optional: Randomize size slightly for even more variety
			var _random_size = random_range(0.8, 1.2);
			_dust.image_xscale *= _random_size;
			_dust.image_yscale = _random_size;				
			
            dust_timer = _dust_speed;
            is_walking = true;
        } else {
            // This is CONTINUOUS movement
            dust_timer--;
            if (dust_timer <= 0) {
				var _dust = instance_create_depth(_dust_x, _dust_y, depth + 1, obj_dust);

				// 1. Flip the dust if facing left
				_dust.image_xscale = (direction_facing == 0) ? -1 : 1;

				// 2. Add random rotation jitter
				_dust.image_angle = random_range(-15, 15);

				// 3. Optional: Randomize size slightly for even more variety
				var _random_size = random_range(0.8, 1.2);
				_dust.image_xscale *= _random_size;
				_dust.image_yscale = _random_size;               
                dust_timer = _dust_speed;
            }
        }		
		
    } else {
		is_walking = false;
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

	var _sword_hit = instance_create_depth(x + _hitbox_offset_x, y + _hitbox_offset_y, 0, obj_hitbox);
	_sword_hit.image_xscale = 1.5;
	_sword_hit.image_yscale = 1.5;
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

var shoot_behavior = function(){
	move_behavior();
	
	var _rel_frame = get_relative_frame();
    // 4. Create the bullet on the 2nd frame
    if (_rel_frame == 1 && !has_attacked) {
        shoot_bullet();
        has_attacked = true;
    }	
	

}

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
	
	if (input_x != 0 || input_y != 0) { state.sprite = spr_hero_run; } 
	else { state.sprite = spr_hero_idle; }

    charge_timer++;

    // 2. Visual Effects: Flashing and Sparks
    if (charge_timer >= charge_limit) {
        is_fully_charged = true;
        // Spawn sparks sporadically
		if (charge_timer % 6 == 0) {
            instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
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

var hit_behavior = function() {
    // 1. Apply knockback movement
    var _hspd = lengthdir_x(hit_knockback_speed, hit_knockback_dir);
    var _vspd = lengthdir_y(hit_knockback_speed, hit_knockback_dir);
    
    // Use your existing collision set
    move_and_collide(_hspd, _vspd, _full_collision_set);
    
    // 2. Reduce speed over time for a "sliding" stop effect
    hit_knockback_speed = max(0, hit_knockback_speed - 0.4);
};

shoot_bullet = function() {
	
	
		// only one bullet
		
		//make sure spawns at bottom of collision mask
		var _spawn_x = x;
		var _spawn_y = bbox_bottom - 6; // 4px up from the feet/base
		
		var _type = bullet_type;
		var _bullet_data = global.bullet_library[$ _type];		
		
		if (_bullet_data != undefined) {
		    // Pass the data struct directly into the new bullet
		    var _bullet = instance_create_depth(_spawn_x, _spawn_y +1, depth, obj_bullet, _bullet_data);
			with (_bullet) {
			    direction = other.direction_facing; // Set movement direction
			    image_angle = direction;             // Rotate sprite to face movement
				speed = _bullet_data.bullet_speed;
			    //speed = 3;                           // How many pixels to move per frame
			}			
			
			
		}		
		
		//var _bullet = instance_create_depth(_spawn_x, _spawn_y, +1, obj_bullet);
		//with (_bullet) {
		  //  direction = other.direction_facing; // Set movement direction
		    //image_angle = direction;             // Rotate sprite to face movement
		    //speed = 3;                           // How many pixels to move per frame
		//}
	
	
	
	
}


states = {
    idle:  new State(spr_hero_idle, 1, true, undefined, idle_behavior),
    walk:  new State(spr_hero_run, 1.0, true, undefined, idle_behavior),
    attack: new State(spr_hero_attack, 1.5, false, "idle", attack_behavior),
	shoot: new State(spr_hero_shoot, 1.5, false, "idle", shoot_behavior),
	spinattack: new State(spr_hero_spin_attack, 1, false, "idle", spin_behavior), 
	charge: new State(spr_hero_idle, 1, true, undefined, charge_behavior),
	hit:    new State(spr_hero_hurt, 1.0, false, "idle", hit_behavior)
};

state = states.idle; // Set initial state


