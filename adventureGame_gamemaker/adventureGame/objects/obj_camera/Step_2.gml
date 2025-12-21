#macro view view_camera[0]

camera_set_view_size(view, view_width, view_height);


if (instance_exists(obj_playerTest) && instance_exists(global.camera_zone)) {
	var _x = clamp(obj_playerTest.x - (view_width/2), 
	max(0,global.camera_zone.bbox_left),
	min(room_width,global.camera_zone.bbox_right)-view_width);
	var _y = clamp(obj_playerTest.y - (view_height/2),
	max(0,global.camera_zone.bbox_top),
	min(room_height,global.camera_zone.bbox_bottom)-view_height);
	
	var _cur_x = camera_get_view_x(view);
	var _cur_y = camera_get_view_y(view);
	
// 2. Apply the random shake offset
_cur_x += random_range(-shake_remain, shake_remain);
_cur_x += random_range(-shake_remain, shake_remain);

// 3. Reduce shake for the next frame
shake_remain = max(0, shake_remain - (1 / shake_length) * shake_magnitude);

// 4. Update camera with the new "shaken" position
//camera_set_view_pos(view_camera[0], _cam_x, _cam_y);	
	
	
	

	var _spd = 0.1;
	
	camera_set_view_pos(view,
		lerp(_cur_x,_x,_spd),
		lerp(_cur_y,_y,_spd));
}