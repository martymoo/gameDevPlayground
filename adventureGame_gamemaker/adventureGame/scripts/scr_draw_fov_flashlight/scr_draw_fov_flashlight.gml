function scr_draw_fov_flashlight(_range, _fov_angle, _facing_dir, _tilemap_id, _precision) {
    var _half_fov = _fov_angle / 2;
    var _angle_step = _fov_angle / _precision;
    
    // 1. SET THE BLEND MODE TO ADDITIVE
    // This makes the light "stack" on top of the background colors
    gpu_set_blendmode(bm_add);
    
    // We use pr_trianglefan to create a solid "bloom" shape
    draw_primitive_begin(pr_trianglefan);
    
    // The center point (the light source) is the brightest
    draw_vertex_color(x, y, c_orange, 0.6); 

    for (var i = 0; i <= _precision; i++) {
        var _current_angle = (_facing_dir - _half_fov) + (i * _angle_step);
        
        // Raycasting logic (same as before)
        var _dist = _range;
        var _step_size = 4; 
        for (var j = 0; j < _range; j += _step_size) {
            var _check_x = x + lengthdir_x(j, _current_angle);
            var _check_y = y + lengthdir_y(j, _current_angle);
            if (tilemap_get_at_pixel(_tilemap_id, _check_x, _check_y) > 0) {
                _dist = j;
                break;
            }
        }
        
        var _final_x = x + lengthdir_x(_dist, _current_angle);
        var _final_y = y + lengthdir_y(_dist, _current_angle);

        // 2. GRADIENT EFFECT
        // We set the edge of the cone to a darker color and lower alpha
        // This makes the light look like it's dissipating
        draw_vertex_color(_final_x, _final_y, c_black, 0);
    }
    
    draw_primitive_end();
    
    // 3. ALWAYS RESET THE BLEND MODE
    gpu_set_blendmode(bm_normal);
}