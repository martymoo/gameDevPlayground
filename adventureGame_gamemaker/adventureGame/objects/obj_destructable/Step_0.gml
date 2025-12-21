
// do a shake test!
scr_update_shake();
 

if (isOnFire) {
    // Define the area where particles spawn (around the object's feet/center)
    part_emitter_region(global.part_sys, my_fire_emitter, bbox_left - 10, bbox_right, y - 4, y + 4, ps_shape_ellipse, ps_distr_gaussian);
    
    // Burst a few particles every frame
    part_emitter_burst(global.part_sys, my_fire_emitter, global.pt_fire, 1);
}