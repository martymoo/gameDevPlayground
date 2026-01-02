// Step Event
// 1. Movement logic
x += lengthdir_x(bullet_speed, direction);
y += lengthdir_y(bullet_speed, direction);

// 2. Calculate the Ratio (0.0 at start, 1.0 at max distance)
var _dist_current = point_distance(xstart, ystart, x, y);
var _ratio = clamp(_dist_current / max_distance, 0, 1);

// 3. Apply the Cosine Wave Curve
// cos(0) is 1.0 (full size)
// cos(pi/2) is 0.0 (empty)
var _curve = cos(_ratio * (pi / 2));

image_xscale = _curve;
image_yscale = _curve;

// 4. Destruction logic
if (_ratio >= 1) {
    instance_destroy();
}

// 3. Screen boundary safety 
if (x < -64 || x > room_width + 64 || y < -64 || y > room_height + 64) {
    instance_destroy();
}