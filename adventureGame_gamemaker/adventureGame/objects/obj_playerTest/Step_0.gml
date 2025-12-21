// 1. GATHER: Update input variables
get_input();



if (invincible_timer > 0) {
    invincible_timer -= 1;
    // Visual feedback: Flicker the player
    image_alpha = (invincible_timer % 4 < 2) ? 0.5 : 1.0;
	scr_update_shake(); //update if hit
} else {
    image_alpha = 1.0;
}

// 2. DECIDE: Switch states based on input
if (state == states.idle || state == states.walk) {
    if (input_x != 0 || input_y != 0) state = states.walk;
    else state = states.idle;
    
	
	if (input_action && state != states.attack) {
	    state = states.attack;
	    has_attacked = false; // prevent spamming attacks
	}	
	
	if (input_test && state != states.attack) {
	    state = states.shoot;
	    has_attacked = false; // prevent spamming attacks
	}	
	
	
}

// 3. ACT: Run the current state's movement logic & animation
if (state.logic != undefined) state.logic();

var _finished = animate_entity(state); 
if (_finished && state.next != undefined) {
    state = states[$ state.next]; 
	has_attacked = false; // reset attack!
	charge_input_buffer = 0; // Ensure buffer is cleared for next time
}
