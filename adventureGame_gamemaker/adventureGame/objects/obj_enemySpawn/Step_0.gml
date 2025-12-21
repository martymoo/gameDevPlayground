// find out what camera_zone i'm in
var _zone = instance_place(x, y, obj_camera_zone);


// if player enters this bounding box, destroy self & create zombie
if (_zone != noone &&  instance_exists(obj_playerTest) && spawning == false) {
	if (rectangle_in_rectangle(obj_playerTest.bbox_left,obj_playerTest.bbox_top,obj_playerTest.bbox_right,obj_playerTest.bbox_bottom,_zone.bbox_left,_zone.bbox_top,_zone.bbox_right,_zone.bbox_bottom)	== 1) {
		spawning = true;
		show_debug_message("you r in my room");
		alarm_set(0, 20);
	}
}
