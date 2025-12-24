if (place_meeting(x, y, obj_playerTest)) {
    // Loop through every trap assigned to this specific panel
    for (var i = 0; i < array_length(target_traps); i++) {
        var _trap = target_traps[i];
        
        // Ensure the trap exists and is currently idle before triggering
        if (instance_exists(_trap)) {
            if (_trap.state == _trap.states.idle) {
                _trap.state = _trap.states.action;
            }
        }
    }
}