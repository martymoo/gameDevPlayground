got_hit();

if(other.type == "fire"){
	start_fire();
}

with(other){
	instance_destroy();
}