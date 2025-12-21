show_debug_message("alarm");

//make sparks
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);
instance_create_depth(x + irandom_range(-10, 10), y + irandom_range(-10, 10), depth + 1, obj_spark);


//make zombie
instance_create_depth(x, y, +1, obj_zombie);

// destroy spawn
instance_destroy();