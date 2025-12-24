//set the sprite
sprite_index = _sprite;
image_index = _variant;
image_speed = 0;


// --- Shake Variables ---
// uses scr_shake and scr_update_shake
shake_duration = 0; // how long
shake_magnitude = 0; // how intense
shake_time = 0;
hit_flash = false; // Tracks if the flash is currently active
flash_countdown = 0;

my_fire_emitter = part_emitter_create(global.part_sys);
isOnFire = false;
fire_duration = 100;
fire_timer = 0;
fire_spread_timer = 0;
fire_spread_delay = 30;
fire_radius = 20; 

is_dying = false;

start_fire = function(){
	if(!isOnFire){
		isOnFire = true;
		fire_timer = fire_duration;
		_health = _health - 0.25;
	}
}

health_check = function(){
		
	if (_health <= 0 && is_dying == false){
		is_dying = true;
		show_debug_message("checking health");
		alarm_set(0, 3); //death
	}
}

spread_fire = function(){
	//contagious fire
	var _list = ds_list_create();
    var _burnable_targets = [obj_destructable, obj_zombie]; // Or use a Parent object
    
    var _num = collision_circle_list(x, y, fire_radius, _burnable_targets, false, true, _list, false);
    
    // 2. Filter the list for objects NOT yet on fire
    var _potential_targets = false;
    for (var i = 0; i < _num; i++) {
        var _inst = _list[| i];
        if (variable_instance_exists(_inst, "isOnFire") && !_inst.isOnFire) {
            _potential_targets = true;
            break; // Found at least one neighbor to ignite
        }
    }

    // 3. Timer Logic
    if (_potential_targets) {
        fire_spread_timer++;
        
        if (fire_spread_timer >= fire_spread_delay) {
            // Spread to EVERY valid target in the radius
            for (var i = 0; i < _num; i++) {
                var _inst = _list[| i];
                if (variable_instance_exists(_inst, "isOnFire")) {
                    _inst.start_fire();
                }
            }
            fire_spread_timer = 0; // Reset after spreading
        }
    } else {
        fire_spread_timer = 0; // Reset if no neighbors are nearby to catch fire
    }
    
    ds_list_destroy(_list);
}

got_hit = function(){
	// SHAKE IT!
	scr_shake_object(10, 3);
	
	
	var _hit_dir = point_direction(other.x, other.y, x, y);

	//get edges
	var _left_edge_x = x - (sprite_width / 2);
	var _right_edge_x = x + (sprite_width / 2);
	var _top_edge_y = y - (sprite_height / 2);
	var _bottom_edge_y = y + (sprite_height / 2);

	var _leftsplash = instance_create_depth(_left_edge_x - 6, y, 0, obj_splash);
	var _rightsplash = instance_create_depth(_right_edge_x + 6, y, 0, obj_splash);
	_rightsplash.image_xscale = -1;

	// show hit spark on destruction
	// Initialize spark spawn coordinates at center
	var _spawn_x = x;
	var _spawn_y = y;

	// Determine which direction hit happened from
	if (_hit_dir >= 45 && _hit_dir < 135) {
	    // Hit from below (Source is at 90 degrees relative to you)
	    _spawn_x = x;
	    _spawn_y = bbox_bottom + 8;
	} 
	else if (_hit_dir >= 135 && _hit_dir < 225) {
	    // Hit from the right (Source is at 180 degrees relative to you)
	    _spawn_x = bbox_right + 8;
	    _spawn_y = y;
	} 
	else if (_hit_dir >= 225 && _hit_dir < 315) {
	    // Hit from above (Source is at 270 degrees relative to you)
	    _spawn_x = x;
	    _spawn_y = bbox_top - 8;
	} 
	else {
	    // Hit from the left (Source is between 315 and 45 degrees)
	    _spawn_x = bbox_left - 8;
	    _spawn_y = y;
	}

	// Create the spark at the calculated edge
	// Note: Use depth - 1 to make sure it appears ON TOP of the player
	var _hitspark = instance_create_depth(_spawn_x, _spawn_y, depth - 1, obj_hit_spark);
	_hitspark.image_angle = _hit_dir;
	

	_health = _health - other.damage;
	show_debug_message($"health is {_health}, damage was {other.damage}")

}