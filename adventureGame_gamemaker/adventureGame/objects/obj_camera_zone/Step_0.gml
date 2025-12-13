if (instance_exists(obj_playerTest)) {
	if (rectangle_in_rectangle(obj_playerTest.bbox_left,obj_playerTest.bbox_top,obj_playerTest.bbox_right,obj_playerTest.bbox_bottom,bbox_left,bbox_top,bbox_right,bbox_bottom)	== 1) {
		global.camera_zone = id;	
	}
}