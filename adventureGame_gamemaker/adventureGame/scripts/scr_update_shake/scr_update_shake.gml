// Script: scr_update_shake

/// @function scr_update_shake
/// @description Updates shake offsets if an object is shaking. Must be called in the Step Event.


function scr_update_shake() {
    // Check if the object is currently shaking

if (hit_flash) {
        // We are on the frame the flash was triggered. Set color.
		        
        
		image_blend = c_yellow;
		show_debug_message("boom");
		
		
        // **KEY CHANGE:** Turn off the flag, but reset the blend LATER.
        hit_flash = false; 
        
        // OPTIONAL: Set a small counter for the reset, instead of relying on shake_duration
        flash_countdown = 3; // Flash for 2 frames
        
    } else {
        // If the flash countdown is active, decrement it
        if (flash_countdown > 0) {
            flash_countdown -= 1;
        }

        // If shake is done AND flash is done, reset color blend to default
        if (shake_duration == 0 && flash_countdown == 0) {
			 
             image_blend = c_white; // Reset color to the default
        }
    }
	
	
    if (shake_duration > 0) {
        
        // 1. Decrease the duration counter
        shake_duration -= 1;

        // 2. Increase the time counter (determines the speed/frequency)
        shake_time += 1.5; 
		
        
        // 3. Calculate the current, fading magnitude
        // NOTE: If you change your trigger duration (e.g., from 10 to 15), 
        // you might need to adjust the divisor here for the best fade-out feel.
        var _current_magnitude = (shake_duration / 10) * shake_magnitude;
        
        // 4. Calculate offsets using sine and cosine for a smooth, organic feel
        shake_x_offset = sin(shake_time) * _current_magnitude;
        shake_y_offset = cos(shake_time * 0.75) * (_current_magnitude * 0.5); 
        
    } else {
        // Shake is finished, reset offsets to zero
        shake_x_offset = 0;
        shake_y_offset = 0;
    }
}