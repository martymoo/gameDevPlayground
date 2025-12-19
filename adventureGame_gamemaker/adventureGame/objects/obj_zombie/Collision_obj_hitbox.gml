// 1. Reduce Health and Shake

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

// 4. STATE MACHINE TRANSITION
// Instead of alarms/sprite_index, we switch the state object
if (_health > 0) {
    state = states.hit; 
    image_index = 0; // Reset animation to start of hit [cite: 20]
} else {
    // If you have a death state, trigger it here
    // state = states.death;
    alarm_set(2, 10); 
}