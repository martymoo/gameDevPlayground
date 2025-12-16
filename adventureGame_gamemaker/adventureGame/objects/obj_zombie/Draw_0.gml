// --- Cone of Vision Visualization ---
// Define the cone parameters (must match the Step Event logic)
var _max_range = 200;
var _fov_angle = 15; // Total cone width is 120 degrees (60 left, 60 right)

// 1. Calculate the three corner points of the triangle (the cone)
var _current_angle = image_angle;

if (_hspd != 0 || _vspd != 0){ // check if moving
	var _current_angle = point_direction(0, 0, _hspd, _vspd); //get facing angle
} 


// Point 1: The enemy's center (the cone origin)
var _x1 = x;
var _y1 = y;

// Define the two boundary angles
var _left_angle = _current_angle + _fov_angle;
var _right_angle = _current_angle - _fov_angle;


// -- Determine the Range (Length) of the Cone Edges ---

var _tile_wall_layer = layer_tilemap_get_id("tile_walls"); // my collision walls

// Function to find the distance to the closest tile collision point along a ray
function GetRayCastDistance(_dir, _start_x, _start_y, _max_dist, _tile_layer_id)
{
    // Check every 4 pixels along the ray up to the max distance
    var _check_step = 4;
    
    for (var i = _check_step; i <= _max_dist; i += _check_step)
    {
        var _check_x = _start_x + lengthdir_x(i, _dir);
        var _check_y = _start_y + lengthdir_y(i, _dir);
        
        // Use tilemap_get_at_pixel to check if a tile exists at that point.
        // Assuming tile ID 0 is empty. Adjust this if your tile ID for collision is different.
        var _tile_id = tilemap_get_at_pixel(_tile_layer_id, _check_x, _check_y);
        
        // Check if the tile exists AND if it has collision data/is not empty (tile ID > 0)
        // If your tile has complex collision, you might need a different check here.
        if (_tile_id > 0)
        {
            return i; // Return the distance to the first tile found
        }
    }
    return _max_dist; // No tile found within max range
}



// Get the actual visible range for the left and right edges
var _left_dist = GetRayCastDistance(_left_angle, x, y, _max_range, _tile_wall_layer);
var _right_dist = GetRayCastDistance(_right_angle, x, y, _max_range, _tile_wall_layer);

// --- 4. Calculate the Cone Edge Points using the new distances ---

// Point 2 (Left Edge)
var _x2 = x + lengthdir_x(_left_dist, _left_angle);
var _y2 = y + lengthdir_y(_left_dist, _left_angle);

// Point 3 (Right Edge)
var _x3 = x + lengthdir_x(_right_dist, _right_angle);
var _y3 = y + lengthdir_y(_right_dist, _right_angle);


// 2. Set the drawing properties
draw_set_alpha(0.3); // Set transparency (0.3 is 30% opaque)
draw_set_color(c_yellow); // Set the color of the cone

// 3. Draw the filled triangle primitive
draw_triangle(_x1, _y1, _x2, _y2, _x3, _y3, false); // 'false' means it's a filled triangle

// 4. Reset drawing properties (CRUCIAL! So you don't affect other draws)
draw_set_alpha(1);
draw_set_color(c_white);

// 5. Draw the sprite (if you are not using draw_self() at the end)
// draw_self();