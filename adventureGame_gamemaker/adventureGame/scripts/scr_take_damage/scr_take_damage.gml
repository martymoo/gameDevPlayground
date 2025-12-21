/// @function scr_take_damage(_target, _source_x, _source_y, _damage_amount)
function scr_take_damage(_target, _source_x, _source_y, _damage_amount) {
    with (_target) {
        // Only trigger if not currently invincible
        if (variable_instance_exists(id, "invincible_timer") && invincible_timer <= 0) {
            
            // Switch the state to the 'hit' struct defined in your states object
            if (variable_instance_exists(id, "states")) {
                state = states.hit; 
                image_index = 0; // Reset animation 
            }
            
            // Calculate knockback direction away from the source 
            hit_knockback_dir = point_direction(_source_x, _source_y, x, y);
            hit_knockback_speed = 6; 
            
            // Set timers
            invincible_timer = invincible_duration;
            
            // Interrupt current actions 
            has_attacked = false; 
            
            // You can also subtract health here
            hp -= _damage_amount;
			
			//shake screen
			scr_screen_shake(4, 15);
        }
		else if (variable_instance_exists(id, "invincible_timer") && invincible_timer > 0){
			show_debug_message("invincible, no damage")
		}
    }
}