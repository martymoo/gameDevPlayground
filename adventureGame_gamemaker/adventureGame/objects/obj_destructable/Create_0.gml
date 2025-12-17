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