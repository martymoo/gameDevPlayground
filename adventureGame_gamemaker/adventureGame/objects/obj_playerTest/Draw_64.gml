// GUI Settings
var _padding_x = 10;
var _padding_y = 10;
var _spacing = 18; 

for (var i = 0; i < hp_max; i++) {
    var _img_idx = 2; // Default to Frame 2 (Empty)
    
    // Check if this heart container should be Full, Half, or Empty
    if (hp >= i + 1) {
        // Current HP is at least 1 full point higher than this heart's index
        _img_idx = 0; // Full Heart
    } else if (hp >= i + 0.5) {
        // Current HP is at least 0.5 higher than this heart's index
        _img_idx = 1; // Half Heart
    } else {
        _img_idx = 2; // Empty Heart
    }

    // Draw the heart
    var _draw_x = _padding_x + (i * _spacing);
    var _draw_y = _padding_y;
    
    draw_sprite(hp_sprite, _img_idx, _draw_x, _draw_y);
}