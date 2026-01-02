scr_take_damage(other.id, x, y, 0.5);
instance_destroy();

var _hitspark = instance_create_depth(x, y, +1, obj_hit_spark);
_hitspark.image_angle = image_angle;