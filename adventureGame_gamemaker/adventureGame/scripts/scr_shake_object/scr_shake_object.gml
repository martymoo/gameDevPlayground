// Script: scr_shake_object

/// @function scr_shake_object
/// @param {Real} duration    The number of steps the shake should last (e.g., 10)
/// @param {Real} magnitude   The maximum pixel offset of the shake (e.g., 3)
function scr_shake_object(_duration, _magnitude) {
    // We use the 'with' keyword implicitly here, so 'self' refers to 
    // the instance that called the script.
    
    // 1. Set the variables on the calling instance (the object being hit)
    shake_duration = _duration; 
    shake_magnitude = _magnitude; 
    shake_time = 0; // Always start the time counter at 0
	
	// FLASH SETUP
    hit_flash = true; // Activate the flash
	

	
}