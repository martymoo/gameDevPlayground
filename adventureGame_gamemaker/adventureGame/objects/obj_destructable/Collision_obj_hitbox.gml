 

// SHAKE IT!
scr_shake_object(10, 3);

//make blood splatter!
var _left_edge_x = x - (sprite_width / 2);
var _right_edge_x = x + (sprite_width / 2);

var _leftsplash = instance_create_depth(_left_edge_x - 6, y, 0, obj_splash);
var _rightsplash = instance_create_depth(_right_edge_x + 6, y, 0, obj_splash);

_rightsplash.image_xscale = -1;

_health--;

show_debug_message($"health is {_health}")
if (_health == 0){
	alarm_set(0, 3);
	
}