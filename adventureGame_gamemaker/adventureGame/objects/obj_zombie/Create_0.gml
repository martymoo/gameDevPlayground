my_speed = 0.25;
direction_facing = direction;
collision_tilemap_id = layer_tilemap_get_id("tile_walls");
_collision_objects = [obj_destructable, obj_zombie, obj_wall_crusher, obj_brazier];
_full_collision_set = array_concat([collision_tilemap_id], _collision_objects);

mask_index = spr_zombie_idle;

direction = irandom(360);
_health = 3;

// FOV & Shake
fov_dir = 0;
view_distance = 180; 
view_angle = 90;
shake_duration = 0;
shake_magnitude = 0;
shake_time = 0;
hit_flash = false;
flash_countdown = 0;
knockback_hspeed = 0;
knockback_vspeed = 0;

//fire stuff
my_fire_emitter = part_emitter_create(global.part_sys);
isOnFire = false;
fire_duration = 100;
fire_timer = 0;
fire_spread_timer = 0;
fire_spread_delay = 10; 

is_dying = false;

start_fire = function(){
	if(!isOnFire){
		isOnFire = true;
		fire_timer = fire_duration;
	}
}

health_check = function(){
	 if(_health <= 0 && is_dying == false){
		is_dying = true;
		alarm_set(2, 10); 
	 }
}

// --- State Machine Setup ---
zombie_wander_logic = function() {
    _hspd = lengthdir_x(my_speed, direction);
    _vspd = lengthdir_y(my_speed, direction);
	//show_debug_message($"wandering, my _hspd is {_hspd} my _vspd is {_vspd}");
    
    // FOV Check
    if (instance_exists(obj_playerTest)) {
        var _can_see = scr_can_see_unit(id, obj_playerTest, view_distance, view_angle, fov_dir, collision_tilemap_id);
        if (_can_see) {
            show_debug_message("I SEE YOU!");
			state = states.chase; 
			
        }
    }

    // Movement & Collision
    if (knockback_hspeed == 0 && knockback_vspeed == 0) {
        var _colliders = move_and_collide(_hspd, _vspd, _full_collision_set);
        if (array_length(_colliders) > 0) {
            alarm_set(1, 1); // Bounce/Change direction
        } 
    } else {
		show_debug_message("knocking back");
		direction = point_direction(x, y, obj_playerTest.x, obj_playerTest.y);
	}
    
    fov_dir += angle_difference(direction, fov_dir) * 0.1;
};


zombie_chase_logic = function() {
    if (instance_exists(obj_playerTest)) {
        // 1. Point toward the player
        direction = point_direction(x, y, obj_playerTest.x, obj_playerTest.y);
        
        // 2. Set movement (using speed of 1 as requested)
        var _chase_speed = 0.75;
        _hspd = lengthdir_x(_chase_speed, direction);
        _vspd = lengthdir_y(_chase_speed, direction);

        // 3. Collision Handling while chasing
        if (abs(knockback_hspeed) < 0.1 && abs(knockback_vspeed) < 0.1) {
            move_and_collide(_hspd, _vspd, _full_collision_set);
        }

        // 4. Update FOV to look at the player
        fov_dir = direction;

        // 5. Check if we LOST the player
        var _can_see = scr_can_see_unit(id, obj_playerTest, view_distance, view_angle, fov_dir, collision_tilemap_id);
        if (!_can_see) {
            show_debug_message("Lost them...");
            state = states.wander; // Go back to wandering
        }
    } else {
        state = states.wander;
    }
};

got_hit = function(){
	_health = _health - other.damage;
	scr_shake_object(10, 3); // Triggers the flash and screen shake [cite: 137, 138]


	// 2. Knockback Calculation
	var _knockback_dir = point_direction(other.x, other.y, x, y);
	var _initial_force = 10; 
	knockback_hspeed = lengthdir_x(_initial_force, _knockback_dir);
	knockback_vspeed = lengthdir_y(_initial_force, _knockback_dir);

	// 3. Visuals (Splatter)
	instance_create_depth(x - (knockback_hspeed * 0.5), y - (knockback_vspeed * 0.5), depth - 1, obj_splash);
	var _rightsplash = instance_create_depth(x + (knockback_hspeed * 0.5), y + (knockback_vspeed * 0.5), depth - 1, obj_splash);
	_rightsplash.image_xscale = -1;

	var _hitspark = instance_create_depth(x, y, +1, obj_hit_spark);
	_hitspark.image_angle = _knockback_dir;


	// 4. STATE MACHINE TRANSITION
	// Instead of alarms/sprite_index, we switch the state object
	if (_health > 0) {
	    state = states.hit; 
		show_debug_message($"should be hit state, is {state.sprite}");
	    image_index = 0; // Reset animation to start of hit [cite: 20]
	} else {
	    // If you have a death state, trigger it here
	    // state = states.death;
	    alarm_set(2, 10); 
	}
}


spread_fire = function(){
	//contagious fire
	var _check_x = 0;
    var _check_y = 0;
    var _dist = 8; // Distance in front of the monster

    // Determine where to look based on facing direction
    _check_x = lengthdir_x(_dist, direction_facing);
    _check_y = lengthdir_y(_dist, direction_facing);
	
	var _burnable_targets = [obj_destructable, obj_zombie];

    var _target = instance_place(x + _check_x, y + _check_y, _burnable_targets);
    
	if (_target != noone) {
        // If the target isn't already on fire, start/continue counting
        if (variable_instance_exists(_target, "isOnFire") && !_target.isOnFire) {
            fire_spread_timer++;
            
            if (fire_spread_timer >= fire_spread_delay) {
                _target.start_fire();
                fire_spread_timer = 0; // Reset after spreading
            }
        }
    } else {
        // Reset the timer if the monster moves away or target is gone
        fire_spread_timer = 0;
    }
}

states = {
    wander: new State(spr_zombie_idle, 0.5, true, undefined, zombie_wander_logic),
    chase:  new State(spr_zombie_run, 1.5, true, undefined, zombie_chase_logic),
    hit:    new State(spr_zombie_hit, 1, false, "chase", undefined)
};

state = states.wander;