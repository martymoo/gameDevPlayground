// 1. Get animation data
var _total_frames = sprite_get_number(sprite_index);
var _img_spd = sprite_get_speed(sprite_index);
var _game_spd = game_get_speed(gamespeed_fps);

// 2. Calculate what the frame WILL be after this step
var _next_frame = image_index + (image_speed * _img_spd / _game_spd);

// 3. Check if we are about to exceed the total frames
if (_next_frame >= _total_frames) {
    // --- FIRE YOUR EVENT HERE ---
    instance_destroy(); // Example: remove the effect when done
}