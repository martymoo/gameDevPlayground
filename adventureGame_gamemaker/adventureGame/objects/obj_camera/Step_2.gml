#macro view view_camera[0]

camera_set_view_size(view, view_width, view_height);

// if(instance_exists(obj_playerTest)){
//	var _x = clamp(obj_playerTest.x - view_width/2,0,room_width-view_width),
//	//max(0,global.camera_zone.bbox_left),
//	var _y = clamp(obj_playerTest.y - view_height/2,0,room_height-view_height);
	
	
//	var _cur_x = camera_get_view_x(view);
//	var _cur_y = camera_get_view_y(view);
	
//	var _spd = .1;
	
//	camera_set_view_pos(view, lerp(_cur_x, _x, _spd) , lerp(_cur_y, _y, _spd));
//}

if (instance_exists(obj_playerTest) && instance_exists(global.camera_zone)) {
	var _x = clamp(obj_playerTest.x - (view_width/2), 
	max(0,global.camera_zone.bbox_left),
	min(room_width,global.camera_zone.bbox_right)-view_width);
	var _y = clamp(obj_playerTest.y - (view_height/2),
	max(0,global.camera_zone.bbox_top),
	min(room_height,global.camera_zone.bbox_bottom)-view_height);
	
	var _cur_x = camera_get_view_x(view);
	var _cur_y = camera_get_view_y(view);

	var _spd = 0.1;
	
	camera_set_view_pos(view,
						lerp(_cur_x,_x,_spd),
						lerp(_cur_y,_y,_spd));
}