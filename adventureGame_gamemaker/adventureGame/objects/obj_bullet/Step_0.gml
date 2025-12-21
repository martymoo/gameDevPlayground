var _vx = lengthdir_x(bullet_speed, direction);
var _vy = lengthdir_y(bullet_speed, direction);

x += _vx;
y += _vy;

if (place_meeting(x, y, collision_tilemap_id)) {
    
    // 1. Calculate the offset based on your direction
    // If direction is 0 (Right), _off_x becomes 24, _off_y becomes 0.
    // If direction is 90 (Up), _off_x becomes 0, _off_y becomes -24.
    var _dist = 1;
    var _off_x = lengthdir_x(_dist, direction);
    var _off_y = lengthdir_y(_dist, direction);
    
    // 2. Create the spark at the offset position
    var _spark = instance_create_depth(x + _off_x, y + _off_y, depth - 1, obj_hit_spark);
    
    // 3. Set the angle to face back toward the player (Impact reflection)
    _spark.image_angle = direction;
    
    // 4. Destroy the bullet
    instance_destroy();
}

// kill if leaves zone
var _zone = instance_place(x, y, obj_camera_zone);

// if bullet leaves zone, kill it
if (_zone != start_zone) {	
		instance_destroy();
}