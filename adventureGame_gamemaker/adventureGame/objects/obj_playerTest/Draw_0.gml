// Draw the hero normally
if (state == states.charge) {
    // Flash white based on a sine wave or simple toggle
    var _flash = (floor(charge_timer / 4) % 2 == 0);
    if (_flash && is_fully_charged) gpu_set_fog(true, c_white, 0, 1);
}

draw_self();

// Always reset fog
gpu_set_fog(false, c_white, 0, 0);