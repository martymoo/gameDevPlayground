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


_is_hit = true;

sprite_index = spr_zombie_hit;
image_speed = 1;
alarm_set(0, 32);

