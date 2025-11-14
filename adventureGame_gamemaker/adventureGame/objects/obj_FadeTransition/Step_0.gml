timer++
if(isFadingOut) {
	alpha = lerp(0, 1, timer / length);
	if(timer >= length){
		room_goto(targetRoom);
		isFadingOut = false;
		timer = 0;
	}
} else {
	alpha = lerp(1, 0, timer / length);
	if(timer >= length){
		instance_destroy();
	}

}