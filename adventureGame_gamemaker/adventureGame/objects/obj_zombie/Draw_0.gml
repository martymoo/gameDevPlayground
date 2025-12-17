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


var _ray_count = 20; // Number of rays to cast 
var _total_fov = _fov_angle * 2;
var _ray_step = _total_fov / (_ray_count - 1); 

var _start_angle = _current_angle - _fov_angle;
var _ray_points = array_create(_ray_count * 2); 

// 1. Cast Rays and Find Intersection Points
for (var i = 0; i < _ray_count; i++)
{
    var _ray_angle = _start_angle + (_ray_step * i);
    
    // Use the existing GetRayCastDistance function
    var _hit_dist = GetRayCastDistance(_ray_angle, x, y, _max_range, _tile_wall_layer);
    
    // Calculate the X/Y coordinates of the hit point
    var _hit_x = x + lengthdir_x(_hit_dist, _ray_angle);
    var _hit_y = y + lengthdir_y(_hit_dist, _ray_angle);
    
    // Store the hit coordinates
    _ray_points[i * 2] = _hit_x;
    _ray_points[i * 2 + 1] = _hit_y;
}

// 2. Draw the Polygon Fan (Series of Triangles)
// We only need to set the drawing properties once before the drawing loop
draw_set_alpha(0.3);
draw_set_color(c_yellow);

// Draw a series of triangles from the origin to two adjacent ray hit points.
for (var i = 0; i < _ray_count - 1; i++)
{
    draw_triangle(
        x, y, // Origin (Point 1)
        _ray_points[i * 2], _ray_points[i * 2 + 1], // Current Ray Hit (Point 2)
        _ray_points[(i + 1) * 2], _ray_points[(i + 1) * 2 + 1], // Next Ray Hit (Point 3)
        false // Filled
    );
}

// 3. Reset drawing properties (CRUCIAL!)
draw_set_alpha(1);
draw_set_color(c_white);

