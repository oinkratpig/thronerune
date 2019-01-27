
// Kris
#macro IMAGE_INDEX (current_frame/5)
global.kris = noone;
global.is_kris_normal = false;

// Sprites
global.sprWalkEast = sprite_add("sprWalkEast.png", 4, 10, 19);
global.sprWalkNorth = sprite_add("sprWalkNorth.png", 4, 10, 19);
global.sprWalkWest = sprite_add("sprWalkWest.png", 4, 10, 19);
global.sprWalkSouth = sprite_add("sprWalkSouth.png", 4, 10, 19);

#define draw_me(_spr, _animated)
// Draws sprite at player with Player obj variables
draw_sprite_ext(_spr, _animated*IMAGE_INDEX, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

#define step

// Is kris intro kris?
global.is_kris_normal = false;
with(Player) if(race == "thronerune-kris-normal")
    global.is_kris_normal = true;

// Only intro kris
if(global.is_kris_normal)
{
    // Object with depth and stuff so player doesn't draw weird
    if(!instance_exists(global.kris) && instance_exists(Player))
    {
        global.kris = instance_create(0, 0, CustomObject);
        with(global.kris)
        {
            on_step = kris_step;
            on_draw = kris_draw;
        }
    }
}

#define kris_step

// Destroy if player not here
if(!instance_exists(Player))
{
    instance_destroy();
    exit;
}

// Match depth with player
with(Player) other.depth = depth;

#define kris_draw

with(Player)
{
    // Walking
    var _spr;
    switch(facing)
    {
        case 0: _spr = global.sprWalkEast; break;
        case 90: _spr = global.sprWalkNorth; break;
        case 180: _spr = global.sprWalkWest; break;
        case 270: _spr = global.sprWalkSouth; break;
    }
    draw_me(_spr, moving);
}

