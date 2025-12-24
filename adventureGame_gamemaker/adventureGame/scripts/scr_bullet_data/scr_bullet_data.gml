// This runs automatically at the very start of the game
function init_bullet_library() {
    // Constructor: The blueprint for every bullet type
    function BulletType(_name, _type, _sprite, _speed, _damage,) constructor {
		name = _name;    
		type = _type;
		sprite = _sprite;
        bullet_speed    = _speed;
        damage = _damage;
    }

    // Global Library: Use a Struct to store all your presets
    global.bullet_library = {
        fireball: new BulletType("fireball", "fire", spr_bullet_fireball01, 2.5, 1),
        basic:    new BulletType("basic", "normal", spr_bullet_simple, 3, 1)
    };
}

// Call the function once to initialize everything
init_bullet_library();	