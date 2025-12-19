// 1. Quadratic Expansion using Lerp
// This moves the current scale closer to the target by a % every frame
image_xscale = lerp(image_xscale, target_scale, growth_speed);
image_yscale = image_xscale; // Keep it uniform

// 2. Continuous Rotation
image_angle += rotation_speed; 

// 3. Exponential Fade
image_alpha *= fade_power;


x = obj_playerTest.x;
y = obj_playerTest.y;
// 4. Cleanup
if (image_alpha < 0.02) {
    instance_destroy();
}