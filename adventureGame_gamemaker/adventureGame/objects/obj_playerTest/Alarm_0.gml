/// hitbox alarm

// make offsets for direction facing
var _hitbox_offset_x = 0;
var _hitbox_offset_y = 0;

if (direction_facing == 0){ // right
		_hitbox_offset_x = 10;
		_hitbox_offset_y = 0;
	} else if (direction_facing == 180){ // left 
		_hitbox_offset_x = -10;
		_hitbox_offset_y = 0;
	} else if (direction_facing == 90){ // up
		_hitbox_offset_x = 0;
		_hitbox_offset_y = -12;
	} else if (direction_facing == 270){ //down
		_hitbox_offset_x = 0;
		_hitbox_offset_y = 12;
}



instance_create_depth(x + _hitbox_offset_x, y + _hitbox_offset_y, 0, obj_hitbox);