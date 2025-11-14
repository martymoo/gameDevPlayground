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