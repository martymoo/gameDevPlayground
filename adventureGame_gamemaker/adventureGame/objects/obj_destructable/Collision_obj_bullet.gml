got_hit();

if(other.type == "fireball"){
	isOnFire = true;
}

with(other){
	instance_destroy();
}