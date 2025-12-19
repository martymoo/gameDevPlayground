

if keyboard_check(vk_shift) 
{
	obj_playerTest.my_speed = 5;
	//show_debug_message("sprinting");
}
else 
{
	obj_playerTest.my_speed = original_speed;
	//show_debug_message("originalspeed");
}

if keyboard_check(ord("R")) 
{
	room_restart();
}