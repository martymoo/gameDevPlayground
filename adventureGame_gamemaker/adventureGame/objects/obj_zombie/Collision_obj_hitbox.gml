_health--; 

// SHAKE IT!
scr_shake_object(10, 3);


var _knockback_dir = point_direction(other.x, other.y, x, y);
var _initial_force = 10; // Start with a strong burst

// 2. Set the variables we created in the Create Event
knockback_hspeed = lengthdir_x(_initial_force, _knockback_dir);
knockback_vspeed = lengthdir_y(_initial_force, _knockback_dir);


//move_and_collide(_hspeed, _vspeed, collision_tilemap_id, true, true);

//destroy sword
with(other){
	//instance_destroy(); // not sure i need this...
}

//make blood splatter!
var _splashx = lengthdir_x(1, _knockback_dir);
var _splashy = lengthdir_y(1, _knockback_dir);

var _leftsplash = instance_create_depth(x - knockback_hspeed, y - knockback_vspeed, 0, obj_splash);
var _rightsplash = instance_create_depth(x + knockback_hspeed, y + knockback_vspeed, 0, obj_splash);

_rightsplash.image_xscale = -1;

_is_hit = true;

sprite_index = spr_zombie_hit;
image_speed = 1;
alarm_set(0, 32);

if(_health == 0){
	alarm_set(2, 10);
	
}