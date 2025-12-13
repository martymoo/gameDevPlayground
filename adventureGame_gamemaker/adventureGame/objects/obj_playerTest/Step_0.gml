var _right = keyboard_check(vk_right) or keyboard_check(ord("D"));
var _left = keyboard_check(vk_left) or keyboard_check(ord("A"));
var _up = keyboard_check(vk_up) or keyboard_check(ord("W"));
var _down = keyboard_check(vk_down) or keyboard_check(ord("S"));

//get direction
var _xinput = _right - _left;
var _yinput = _down - _up;


// Check if there is any movement input
if (_xinput != 0 || _yinput != 0)
{
    // Calculate the direction angle in degrees
    var _dir = point_direction(0, 0, _xinput, _yinput);
    
    // Calculate the movement components for the given angle and speed
    // This uses trig functions (sin/cos) to split the speed correctly.
    var _hspd = lengthdir_x(my_speed, _dir);
    var _vspd = lengthdir_y(my_speed, _dir);
    
    move_and_collide(_hspd, _vspd, obj_wallTest);
}


//Determining facing directions
var _moving = (_left || _right || _up || _down); // Check if *any* movement key is down

if (_moving) {
    if (_left) {
        direction_facing = 180; // Left
    }
    if (_right) {
        direction_facing = 0;   // Right
    }
    if (_up) {
        direction_facing = 90;  // Up
    }
    if (_down) {
        direction_facing = 270; // Down
    }
    // Note: If multiple are pressed (e.g., up and right), the last one in this sequence wins.
}

//TODO - consider just creating multiple sprites for states, this is too complicated
// --- Sprite Selection ---
var _target_sprite = _moving ? spr_hero_run : spr_hero_idle; // run or idle
var _frames_per_direction = _moving ? 6 : 4; // 6 for Run, 4 for Idle

var frame_offset = 0;
image_xscale = 1; // Default to facing Right (no mirroring)

// Use direction_facing to find the starting frame index and mirroring
if (direction_facing == 0) { // Right (Base Direction)
    // Down, Right, Up -> Right is the second set (index 1)
    frame_offset = _frames_per_direction * 1; 
    image_xscale = 1;
} else if (direction_facing == 180) { // Left (Mirror Right)
    // Find the Right frames, but flip the sprite
    frame_offset = _frames_per_direction * 1; 
    image_xscale = -1; // *** This is the mirroring line ***
} else if (direction_facing == 90) { // Up
    // Up is the third set (index 2)
    frame_offset = _frames_per_direction * 2; 
    image_xscale = 1; // No mirroring for vertical movement
} else if (direction_facing == 270) { // Down
    // Down is the first set (index 0)
    frame_offset = _frames_per_direction * 0; 
    image_xscale = 1; // No mirroring for vertical movement
}

// --- Sprite Selection ---

// Only change the sprite if it's different to prevent resetting the animation
if (sprite_index != _target_sprite) {
    sprite_index = _target_sprite;
    
    // Crucial: When we switch sprites, we set the image_index to the offset,
    // which tells GameMaker where in the strip to START the animation.
    image_index = frame_offset; 
}

// Set animation speed
image_speed = 1; // Use frames per second instead of raw speed (Example: 6 FPS vs 8 FPS)


// --- Frame Control (The core fix) ---

// Check if the current frame is outside the intended directional block.
// Example: If frame_offset is 6 (Up), the animation should cycle 6, 7, 8...
// If image_index reaches 9 (the start of the next block), we loop it back to the start (6).

if (image_index >= frame_offset + _frames_per_direction) {
    // If we passed the end of the intended block, loop back to the start of that block.
    image_index = frame_offset;
}