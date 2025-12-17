function scr_draw_fov_complex(_range, _fov_angle, _facing_dir, _tilemap_id, _precision) {
    var _half_fov = _fov_angle / 2;
    var _angle_step = _fov_angle / _precision;
    
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(x, y); // Origin at the mob's center

    for (var i = 0; i <= _precision; i++) {
        var _current_angle = (_facing_dir - _half_fov) + (i * _angle_step);
        
        // Start at the maximum range
        var _dist = _range;
        
        // Raycasting: Step along the ray to find the wall
        // We use a simple loop to check pixels along the path of the angle
        // For performance, we check every 4-8 pixels (step_size)
        var _step_size = 4; 
        for (var j = 0; j < _range; j += _step_size) {
            var _check_x = x + lengthdir_x(j, _current_angle);
            var _check_y = y + lengthdir_y(j, _current_angle);
            
            // USE YOUR TILEMAP CHECK HERE
            var _tile = tilemap_get_at_pixel(_tilemap_id, _check_x, _check_y);
            
            if (_tile > 0) { // If there is a tile at this coordinate
                _dist = j;
                break;
            }
        }
        
        // Calculate the final vertex based on where we hit the tile (or max range)
        var _final_x = x + lengthdir_x(_dist, _current_angle);
        var _final_y = y + lengthdir_y(_dist, _current_angle);

        draw_vertex(_final_x, _final_y);
    }
    
    draw_primitive_end();
}