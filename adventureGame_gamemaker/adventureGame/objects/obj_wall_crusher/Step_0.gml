scr_update_shake();

if (state.logic != undefined) state.logic();


if (state.next != undefined) {
    state = states[$ state.next]; 
}
