// 1. Update Visual Effects
scr_update_shake();

// 2. Handle Knockback Physics
if (abs(knockback_hspeed) > 0.1 || abs(knockback_vspeed) > 0.1) {
    move_and_collide(knockback_hspeed, knockback_vspeed, collision_tilemap_id);
    knockback_hspeed = lerp(knockback_hspeed, 0, 0.5);
    knockback_vspeed = lerp(knockback_vspeed, 0, 0.5);
} else {
	knockback_hspeed = 0;
    knockback_vspeed = 0;
}

//handle onFire
if (isOnFire) {
	fire_timer--;
    // Define the area where particles spawn (around the object's feet/center)
    part_emitter_region(global.part_sys, my_fire_emitter, bbox_left - 10, bbox_right, y - 4, y + 4, ps_shape_ellipse, ps_distr_gaussian);
    
    // Burst a few particles every frame
    part_emitter_burst(global.part_sys, my_fire_emitter, global.pt_fire, 1);
	
	// timer countdown
	if(fire_timer == fire_duration/2){
		_health = _health - 1;
		scr_shake_object(10, 3); // Triggers the flash and screen shake [cite: 137, 138]		
		if (_health <= 0){
			alarm_set(2, 10); 
		}
	}
	
	//stop fire when off
	if(fire_timer <= 0){
	 isOnFire = false;
	}
	
	spread_fire();	
	
}


// 3. Execute Current State Logic
if (state.logic != undefined) {
    state.logic();
}

// 4. Update Animation Direction
if (abs(_hspd) > 0.1 || abs(_vspd) > 0.1) {
    direction_facing = round(direction / 90) * 90;
    if (direction_facing == 360) direction_facing = 0;
}

// 5. Run Animator and State Transitions
var _anim_finished = animate_entity(state); 


if (_anim_finished && state.next != undefined) {
    state = states[$ state.next]; 
}

health_check();