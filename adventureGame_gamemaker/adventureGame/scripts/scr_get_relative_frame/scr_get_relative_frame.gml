/// @function get_relative_frame()
/// @description Returns the frame index (0, 1, 2...) relative to the current direction's animation strip.
function get_relative_frame() {
    var _total_frames = sprite_get_number(sprite_index);
    var _frames_per_dir = _total_frames / 3; // Based on your 3-direction strip logic [cite: 12]
    
    // Identify direction index: 270=0 (Down), 0/180=1 (Side), 90=2 (Up) [cite: 13]
    var _dir_idx = (direction_facing == 90) ? 2 : (direction_facing == 270 ? 0 : 1);
    var _start_frame = _dir_idx * _frames_per_dir;

    return floor(image_index - _start_frame);
}