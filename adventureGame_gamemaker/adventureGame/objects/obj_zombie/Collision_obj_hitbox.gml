_health--; 

// SHAKE IT!
scr_shake_object(10, 3);

// 1. Calculate the angle from the other object (the attacker/pusher) to this object (the one getting hit)
// This gives you the direction the player needs to be pushed: AWAY from the enemy.
var _knockback_dir = point_direction(other.x, other.y, x, y);

// 2. Define the force of the knockback (e.g., 5 pixels per frame)
var _knockback_force = 8; 

// 3. Apply the force to the object's horizontal and vertical speed variables
// Use lengthdir_x/y to convert the angle and force into (hspeed, vspeed) components.
var _hspeed = lengthdir_x(_knockback_force, _knockback_dir);
var _vspeed = lengthdir_y(_knockback_force, _knockback_dir);

move_and_collide(_hspeed, _vspeed, collision_tilemap_id, true, true);

//destroy sword
with(other){
	//instance_destroy(); // not sure i need this...
}

//make blood splatter!
var _splashx = lengthdir_x(1, _knockback_dir);
var _splashy = lengthdir_y(1, _knockback_dir);

var _leftsplash = instance_create_depth(x - _hspeed, y - _vspeed, 0, obj_splash);
var _rightsplash = instance_create_depth(x + _hspeed, y + _vspeed, 0, obj_splash);

_rightsplash.image_xscale = -1;

_is_hit = true;

sprite_index = spr_zombie_hit;
image_speed = 1;
alarm_set(0, 32);

if(_health == 0){
	alarm_set(2, 10);
	
}