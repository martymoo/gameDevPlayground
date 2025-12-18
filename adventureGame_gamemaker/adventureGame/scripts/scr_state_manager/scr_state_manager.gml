/// @function State(_sprite, _speed, _can_loop, _next_state, _func)
function State(_sprite, _speed, _can_loop = true, _next_state = undefined, _func = undefined) constructor {
    sprite = _sprite;
    speed = _speed;
    loop = _can_loop;
    next = _next_state; // What state to switch to when finished (if not looping)
    logic = _func; // This stores the behavior code (movement, AI, etc.)
}