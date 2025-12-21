// original_speed = obj_playerTest.my_speed;

// --- Global Particle Setup ---
global.part_sys = part_system_create();
part_system_depth(global.part_sys, -100); // Ensure fire is on top

// Define the Fire Particle Type
global.pt_fire = part_type_create();
part_type_sprite(global.pt_fire, spr_flame, true, true, false); // Uses your animated sprite
part_type_size(global.pt_fire, 0.5, 1.2, -0.01, 0.05);          // Random sizes + slight shrinking
part_type_alpha3(global.pt_fire, 1, 0.8, 0);                    // Fade out at the end
part_type_color2(global.pt_fire, c_white, c_orange);            // Tint it orange as it dies
part_type_speed(global.pt_fire, 0.5, 1.5, -0.02, 0);            // Float upwards
part_type_direction(global.pt_fire, 80, 100, 0, 5);             // Mostly Up (90 degrees)
part_type_life(global.pt_fire, 20, 40);                         // How many frames it lasts
part_type_blend(global.pt_fire, true);                          // Additive blending for "glow"