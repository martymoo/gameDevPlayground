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