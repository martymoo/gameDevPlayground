draw_self();

if (state == states.charge) {
    var _flash_alpha = 0;
    
    // Create a rhythmic pulsing alpha (0.0 to 0.5)
    // Faster pulsing as it gets closer to full charge
    var _pulse_speed = is_fully_charged ? 0.2 : 0.1;
    _flash_alpha = abs(sin(current_time * _pulse_speed)) * 0.5;

    // Set blend mode to additive for a "light" effect
    gpu_set_blendmode(bm_add);
    
    // Draw the white "overlay"
    // We use the same sprite, index, and position as the player
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, _flash_alpha);
    
    // Reset blend mode to normal
    gpu_set_blendmode(bm_normal);
}

