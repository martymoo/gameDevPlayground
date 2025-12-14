my_speed = 4;
direction_facing = 270; // Start facing 'down' (270 degrees)

collision_tilemap_id = layer_tilemap_get_id("tile_walls");

// Character State 
enum STATE
{
    NORMAL,  // Idle, Walking, Running - Character can move and initiate actions
    ACTION   // Attacking, Drawing Bow - Character can move but CANNOT initiate a NEW action
}

// Initial Setup
state = STATE.NORMAL;
// Timer for how long the action animation lasts (in frames)
action_timer = 0;
// Total duration of the action (e.g., 30 frames for a sword swing)
action_duration = 16;

swing_start_frame = 0; //temp, maybe get rid of?