current_speed = 0.5;   // Starting very slow
target_speed = 4;      // Your "my_speed" goal
acceleration = 0.1;    // How much speed is added each frame
direction = _direction;

_collision_objects = [obj_wall_crusher, obj_wall_stopper];

rumble_timer = 40;
rumble_duration = 40;
move_started = false;

shake_duration = 0;
shake_magnitude = 0;
shake_time = 0;
hit_flash = false;
flash_countdown = 0;


if (direction == 0){
	image_xscale = -1;
}

var idle_behavior = function(){

}

var action_behavior = function(){
	
	if(move_started == false){
		if(rumble_timer == rumble_duration){
			scr_shake_object(50, 1); // Triggers the flash and screen shake 
		}
		rumble_timer--;
		instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_dust);
		
		if(rumble_timer <= 0){
			move_started = true;
			rumble_timer = rumble_duration;
		}
	} else {

	// Increase speed until it hits the target
	if (current_speed < target_speed) {
	    current_speed += acceleration;
	}

	// Clamp the speed to ensure it doesn't overshoot the target
	current_speed = min(current_speed, target_speed);

	// Apply movement using lengthdir 
	var _hspd = lengthdir_x(current_speed, _direction);
	var _vspd = lengthdir_y(current_speed, _direction);


	// Check if the player is in the path of the movement
    var _inst_player = instance_place(x + _hspd, y + _vspd, obj_playerTest);

    if (_inst_player != noone) {
        with (_inst_player) {
            // The crusher checks if the player is blocked by the player's own collision set
            // This includes wall tiles and destructible objects
            if (place_meeting(x + _hspd, y + _vspd, _full_collision_set)) {
                // CRUSHED: The player has nowhere to go
                instance_destroy();
            } else {
                // PUSHED: The space is clear, so move the player along with the wall
                x += _hspd;
                y += _vspd;
            }
        }
    }	
	
	
	move_and_collide(_hspd, _vspd, _collision_objects);		
	
	}
	
	


}

var finished_behavior = function(){

}

states = {
    idle:  new State(spr_Wall_crush, 1, true, undefined, idle_behavior),
    action:  new State(spr_Wall_crush, 1, true, undefined, action_behavior),
    finished: new State(spr_Wall_crush, 1, false, undefined, finished_behavior)
}

state = states.idle; // Set initial state