my_speed = 0.25;
direction_facing = direction;
collision_tilemap_id = layer_tilemap_get_id("tile_walls");
_collision_objects = [obj_destructable, obj_playerTest];
_full_collision_set = array_concat([collision_tilemap_id], _collision_objects);

direction = irandom(360);
_health = 3;

// FOV & Shake
fov_dir = 0;
view_distance = 180; 
view_angle = 40;
shake_duration = 0;
shake_magnitude = 0;
shake_time = 0;
hit_flash = false;
flash_countdown = 0;
knockback_hspeed = 0;
knockback_vspeed = 0;

// --- State Machine Setup ---
zombie_wander_logic = function() {
    _hspd = lengthdir_x(my_speed, direction);
    _vspd = lengthdir_y(my_speed, direction);
	show_debug_message($"wandering, my _hspd is {_hspd} my _vspd is {_vspd}");
    
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

states = {
    wander: new State(spr_zombie_idle, 0.5, true, undefined, zombie_wander_logic),
    chase:  new State(spr_zombie_run, 1.5, true, undefined, zombie_chase_logic),
    hit:    new State(spr_zombie_hit, 0.5, false, "wander", zombie_wander_logic)
};

state = states.wander;