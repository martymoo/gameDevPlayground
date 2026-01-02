_health = 3;

// Pattern Variables
//pattern_rotation = 0;       // The starting angle
//rotation_speed = 0.75;         // How fast the "petals" spin
//petal_count = 3;            // How many bullets per blast
//fire_rate = 10;             // Frames between shots
fire_timer = 0;

// Movement/State Variables (Matching your system)
my_speed = 0; 
direction_facing = 270;

//knockback
shake_duration = 0;
shake_magnitude = 0;
shake_time = 0;
hit_flash = false;
flash_countdown = 0;
knockback_hspeed = 0;
knockback_vspeed = 0;

got_hit = function(){
 
	_health = _health - other.damage;
	scr_shake_object(10, 3); // Triggers the flash and screen shake [cite: 137, 138]


	// 2. Knockback Calculation
	var _knockback_dir = point_direction(other.x, other.y, x, y);
	var _initial_force = 10; 
	knockback_hspeed = lengthdir_x(_initial_force, _knockback_dir);
	knockback_vspeed = lengthdir_y(_initial_force, _knockback_dir);

	// 3. Visuals (Splatter)
	instance_create_depth(x - (knockback_hspeed * 0.5), y - (knockback_vspeed * 0.5), depth - 1, obj_splash);
	var _rightsplash = instance_create_depth(x + (knockback_hspeed * 0.5), y + (knockback_vspeed * 0.5), depth - 1, obj_splash);
	_rightsplash.image_xscale = -1;

	var _hitspark = instance_create_depth(x, y, +1, obj_hit_spark);
	_hitspark.image_angle = _knockback_dir; 
 
 
 

}

health_check = function(){
	if(_health <= 0){
		instance_destroy();
	}
}

// Define the behavior function
flower_attack_behavior = function() {
    // 1. Rotate the pattern
    pattern_rotation += rotation_speed;
	image_angle = pattern_rotation;
    
    // 2. Handle firing timer
    fire_timer++;
    
    if (fire_timer >= fire_rate) {
        fire_timer = 0;
        
        // 3. Fire the "Petals"
        var _angle_step = 360 / petal_count;
        
        for (var i = 0; i < petal_count; i++) {
            var _spawn_angle = pattern_rotation + (i * _angle_step);
            
            var _bullet = instance_create_depth(x, y, depth - 1, obj_enemy_bullet);
            with (_bullet) {
                direction = _spawn_angle;
				image_angle = _spawn_angle;
                // speed = 2;
                // Optional: match bullet sprite here
                // sprite_index = spr_enemy_projectile; 
            }
        }
    }
};

// Define States (Matching your State constructor)
states = {
    attack: new State(spr_emitter, 1, true, undefined, flower_attack_behavior)
};

state = states.attack;