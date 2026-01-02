scr_update_shake();

// Execute the logic function stored in the current state
if (state.logic != undefined) {
    state.logic();
}

// Handle animation using your custom script
animate_entity(state);

health_check();