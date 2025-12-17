function scr_can_see_unit(_viewer, _target, _range, _fov_angle, _facing_angle, _wall_layer) {
    // 1. DISTANCE CHECK
    // Optimization: If they are too far away, don't bother with expensive math
    var _dist = point_distance(_viewer.x, _viewer.y, _target.x, _target.y);
    if (_dist > _range) return false;

    // 2. ANGLE CHECK
    // Determine the direction from the enemy to the target
    var _dir_to_target = point_direction(_viewer.x, _viewer.y, _target.x, _target.y);
    
    // angle_difference returns the shortest way to turn from A to B.
    // If the difference is less than half our FOV, the target is "inside" the cone.
    var _angle_diff = abs(angle_difference(_facing_angle, _dir_to_target));
    
    if (_angle_diff > (_fov_angle / 2)) return false;

    // 3. LINE OF SIGHT CHECK

	var _can_see = true;
	var _dist_to_player = point_distance(x, y, _target.x, _target.y);

	for (var j = 0; j < _dist_to_player; j += 8) {
	    var _cx = x + lengthdir_x(j, _dir_to_target);
	    var _cy = y + lengthdir_y(j, _dir_to_target);
    
	    if (tilemap_get_at_pixel(_wall_layer, _cx, _cy) > 0) {
	        _can_see = false; // Wall is in the way!
	        break;
	    }
	}

	if (!_can_see) return false;
	


    // If all checks pass, the enemy sees the target!
    return true;
}