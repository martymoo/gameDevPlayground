function animate_entity(_state_struct) {
    var _sprite = _state_struct.sprite;
    var _speed = _state_struct.speed;
    
    // 1. Calculations
    var _total_frames = sprite_get_number(_sprite);
    var _frames_per_dir = _total_frames / 3;
    var _dir_idx = (direction_facing == 90) ? 2 : (direction_facing == 270 ? 0 : 1);
    
    // 2. Setup
    image_xscale = (direction_facing == 180) ? -1 : 1;
    var _start_frame = _dir_idx * _frames_per_dir;
    var _end_frame = _start_frame + _frames_per_dir;

    if (sprite_index != _sprite) {
        sprite_index = _sprite;
        image_index = _start_frame;
    }
    image_speed = _speed;

    // 3. Looping vs. Ending Logic
	var _next_frame = image_index + (image_speed * sprite_get_speed(sprite_index) / game_get_speed(gamespeed_fps));

    if (_next_frame >= _end_frame) {
        if (_state_struct.loop) {
            image_index = _start_frame; 
            return false;
        } else {
            // Force the state to end!
            return true; 
        }
    }
    
    // Safety check: If for some reason we jumped outside our range (common in the last direction)
    if (image_index < _start_frame) {
         image_index = _start_frame;
    }
    return false;
}


