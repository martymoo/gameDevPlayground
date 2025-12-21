/// @function scr_screen_shake(_magnitude, _frames)
/// @param _magnitude The strength of the shake (in pixels)
/// @param _frames How long the shake lasts
function scr_screen_shake(_magnitude, _frames) {
    with (obj_camera) {
        if (_magnitude > shake_remain) {
            shake_magnitude = _magnitude;
            shake_remain = _magnitude;
            shake_length = _frames;
        }
    }
}