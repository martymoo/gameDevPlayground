gpu_set_blendmode(bm_add);
draw_set_alpha(image_alpha);

// draw_self() automatically uses image_angle, image_xscale, and image_yscale
draw_self();

draw_set_alpha(1.0);
gpu_set_blendmode(bm_normal);