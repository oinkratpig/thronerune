
#define init

// Sprites
global.sprNothing = sprite_add("sprNothing.png", 4, 0, 0);
global.sprFloor = sprite_add("sprFloor.png", 5, 0, 0);
global.sprFloorExplo = sprite_add("sprFloorExplo.png", 1, 0, 0);
global.sprFloorCornerOff = sprite_add("sprFloorCornerOff.png", 4, 0, 0);
global.sprWalls = sprite_add("sprWalls.png", 7, 0, 96);
global.sprBed = sprite_add("sprBed.png", 1, 0, 0);
global.sprBedBlanket = sprite_add("sprBedBlanket.png", 1, 0, 0);
global.sprBedFeet = sprite_add("sprBedFeet.png", 1, 0, 0);
global.sprBedFeetMask = sprite_add("sprBedFeetMask.png", 1, 0, 0);
global.sprTable = sprite_add("sprTable.png", 1, 0, 0);
global.sprWalkBarrier = sprite_add("sprWalkBarrier.png", 1, 0, 0);
global.sprRug = sprite_add("sprRug.png", 1, 37, 23);
global.sprTVBottom = sprite_add("sprTVBottom.png", 1, 0, 0);
global.sprConsole = sprite_add("sprConsole.png", 2, 0, 0);
global.sprController = sprite_add("sprController.png", 1, 0, 0);

// Sounds
global.sndNothing = sound_add("sndNothing.ogg");

// Object stuff
global.player_spawn = noone;

// Blueprints
global.blueprint = {
    bp: [
        ":::::::::",
        ":0123456:",
        ":EF...AB:",
        ":...C...:",
        ":>.....<:",
        " ::>D<:: ",
        "   :::   "],
    key: [
        {char: ".", scr: place_floor},
        {char: ":", scr: walk_barrier},
        {char: "0", scr: place_wall_0},
        {char: "1", scr: place_wall_1},
        {char: "2", scr: place_wall_2},
        {char: "3", scr: place_wall_3},
        {char: "4", scr: place_wall_4},
        {char: "5", scr: place_wall_5},
        {char: "6", scr: place_wall_6},
        {char: "A", scr: floor_table},
        {char: "B", scr: floor_bed},
        {char: "C", scr: floor_rug},
        {char: ">", scr: floor_nocorner_0},
        {char: "<", scr: floor_nocorner_1},
        {char: "D", scr: floor_door},
        {char: "E", scr: floor_tv},
        {char: "F", scr: floor_console}
        ]
}

#define create_dontmove(_x, _y)
// Create object that doesn't move
var _inst = instance_create(x, y, CustomObject);
with(_inst)
{
    creator = other;
    on_step = dontmove_step;
    xoff = 0;
    yoff = 0;
}
return _inst;

#define place_floor(_x, _y)
// BLUEPRINT Place a floor
return instance_create(_x, _y, Floor);
#define floor_nocorner_0(_x, _y)
// BLUEPRINT Place floor with bottom-left corner missing
floor_nocorner(_x, _y, 2);
#define floor_nocorner_1(_x, _y)
// BLUEPRINT Place floor with bottom-right corner missing
floor_nocorner(_x, _y, 3);
#define place_wall(_x, _y, _index)
// BLUEPRINT Place floor that will place wall
var _inst;
with(instance_create(_x, _y, Floor))
    with(create_dontmove(x, y))
    {
        _inst = id;
        sprite_index = global.sprWalls;
        image_index = _index;
        image_speed = 0;
    }
return _inst;
#define place_wall_0(_x, _y)
// BLUEPRINT Place wall 0
place_wall(_x, _y, 0);
#define place_wall_1(_x, _y)
// BLUEPRINT Place wall 1
place_wall(_x, _y, 1);
#define place_wall_2(_x, _y)
// BLUEPRINT Place wall 2
place_wall(_x, _y, 2);
#define place_wall_3(_x, _y)
// BLUEPRINT Place wall 3
place_wall(_x, _y, 3);
#define place_wall_4(_x, _y)
// BLUEPRINT Place wall 4
place_wall(_x, _y, 4);
#define place_wall_5(_x, _y)
// BLUEPRINT Place wall 5
place_wall(_x, _y, 5);
#define place_wall_6(_x, _y)
// BLUEPRINT Place wall 0
place_wall(_x, _y, 6);
#define floor_door(_x, _y)
// BLUEPRINT Place floor that will place door
with(instance_create(_x, _y, Floor))
    with(instance_create(0, 0, CustomObject))
    {
        creator = other;
        on_step = door_step;
        within_range = false;
    }
#define floor_bed(_x, _y)
// BLUEPRINT Place floor that will place bed
with(instance_create(_x, _y, Floor))
    with(create_dontmove(x, y))
    {
        // Player spawn
        global.player_spawn = instance_create(x+9, y-20, CustomObject);
        // Blanket
        with(create_dontmove(x, y))
        {
            interactable(0, 0, ["* Your blanket seems to be#  floating."]);
            depth -= 10;
            sprite_index = global.sprBedBlanket;
        }
        // Feet
        with(create_dontmove(x, y))
        {
            interactable(0, 0, ["* It's your bed."]);
            is_walk_barrier = true;
            sprite_index = global.sprBedFeet;
            mask_index = global.sprBedFeetMask;
            yoff += 35;
        }
        
        sprite_index = global.sprBed;
        xoff = -15;
        yoff = -32;
    }
#define floor_table(_x, _y)
// BLUEPRINT Place floor that will place wall (with bed frame)
with(instance_create(_x, _y, Floor))
    with(create_dontmove(x, y))
    {
        interactable(0, 0, ["* Clothes drawer.", "* It's filled with&.&.&.&#* My clothes."]);
        is_walk_barrier = true;
        sprite_index = global.sprTable;
        xoff = -31;
        yoff = -32;
    }
#define floor_rug(_x, _y)
// BLUEPRINT Place floor and rug
with(instance_create(_x, _y, Floor))
    with(create_dontmove(x, y))
    {
        interactable(0, 0, ["* It's a rug."]);
        sprite_index = global.sprRug;
        spr_idle = sprite_index;
        spr_shadow = global.sprNothing;
        xoff = 16;
        yoff = 0;
    }
#define walk_barrier(_x, _y)
// BLUEPRINT Place wall Player can't move past
with(instance_create(_x, _y, CustomObject))
{
    is_walk_barrier = true;
    sprite_index = global.sprNothing;
    mask_index = global.sprWalkBarrier;
}
#define floor_tv(_x, _y)
// BLUEPRINT Place floor that will place tv
with(instance_create(_x, _y, Floor))
    with(create_dontmove(x, y))
    {
        interactable(0, 0, ["* It's hooked up to a#  game console.", "* Toriel brought it up here#  for me to play on."]);
        is_walk_barrier = true;
        sprite_index = global.sprTVBottom;
        xoff = 2;
        yoff = -32;
    }
#define floor_console(_x, _y)
// BLUEPRINT Place floor that will place console
with(instance_create(_x, _y, Floor))
{
    // Console
    with(create_dontmove(x, y))
    {
        interactable(0, 0, ["* Nuclear Throne is my favorite#  game.", "* Sadly, it sucks on console.", "* Might as well grab the#  controller."]);
        is_walk_barrier = true;
        sprite_index = global.sprConsole;
        image_speed /= 17;
        xoff = 20;
        yoff = -32;
    }
    // Controller
    with(create_dontmove(x, y))
    {
        interactable(0, 0, ["* You picked up the controller."]);
        special_interact = 0;
        is_walk_barrier = true;
        sprite_index = global.sprController;
        xoff = 20;
        yoff = -32;
    }
}

#define interactable(_face, _voice, _desc)

// Set instance to be interactable
is_interactable = true;
desc = _desc;
desc_face = _face;
desc_voice = _voice;

#define door_step()

// Door position
if(!instance_exists(creator)) instance_destroy();
else
{
    // Position
    x = creator.x + 16;
    y = creator.y + 32;
    // Within range of door
    var _vdist = 32;
    var _hdist = 32;
    var _was_within_range = within_range;
    within_range = false;
    with(Player)
        if(x >= other.x-_hdist && x <= other.x+_hdist && y >= other.y-_vdist && y <= other.y+_vdist)
            other.within_range = true;
    // Talk about door
    if(!_was_within_range && within_range)
    {
        var _msgs = ["* You don't feel like exiting#  your room right now."];
        mod_script_call("mod", "thronerune-textboxes", "textbox_say", _msgs, 0, 0);
    }
}

#define dontmove_step()

// Always on their floor
if(!instance_exists(creator)) instance_destroy();
else
{
    x = creator.x + xoff;
    y = creator.y + yoff;
    xstart = x;
    ystart = y;
}

#define floor_nocorner(_x, _y, _ind)
// Create floor with no corner
with(place_floor(_x, _y))
    with(instance_create(x, y, GameObject))
    {
        creator = other;
        depth = other.depth-1;
        sprite_index = global.sprFloorCornerOff;
        image_index = _ind;
        image_speed = 0;
        mask_index = global.sprNothing;
        on_step = floor_corner_step;
    }
#define floor_corner_step
// If floor doesn't exist, neither does it's corner
if(!instance_exists(creator)) instance_destroy();

#define area_name
return "INTRO";

#define area_sprite(q)
switch (q) {
    case sprFloor1: return global.sprFloor;
    case sprFloor1B: return global.sprFloor;
    case sprFloor1Explo: return global.sprFloorExplo;
    case sprWall1Trans: return global.sprNothing;
    case sprWall1Bot: return global.sprNothing;
    case sprWall1Out: return global.sprNothing;
    case sprWall1Top: return global.sprNothing;
    case sprDebris1: return global.sprNothing;
}

#define area_transit
// First level
if(mod_variable_get("mod", "thronerune-main", "intro") && area == 1 && subarea == 1)
    area = "thronerune-intro0";

#define area_finish
// Next area
area = "thronerune-field";

#define area_setup

goal = 2;
sound_play_music(global.sndNothing);
background_color = c_black;
BackCont.shadcol = c_black;

#define build_blueprint(_blueprint)

// Build a given blueprint
var _bp = _blueprint.bp;
var _xstart = 0;
var _x = 100;
var _y = 100;
for(var h = 0; h < array_length_1d(_bp); h++)
{
    // Reset x position to left
    _x = _xstart;
    // Every character in blueprint
    for(var w = 1; w <= string_length(_bp[h]); w++)
    {
        // Place tile
        var _char = string_char_at(_bp[h], w);
        for(var i = 0; i < array_length_1d(_blueprint.key); i++)
            if(_char == _blueprint.key[i].char)
            {
                script_execute(_blueprint.key[i].scr, _x, _y);
                break;
            }
        // Move next tiles
        _x += 32;
    }
    // Move next tiles
    _y += 32;
}

#define move_player()

// Spawn player
with(global.player_spawn)
{
    with(Player)
    {
        x = other.x;
        y = other.y;
    }
    instance_destroy();
}

#define area_start

// Get rid of rad chest
with(RadChest) instance_delete(id);

// Blueprint
build_blueprint(global.blueprint);

// Spawn player
move_player();

// Intro
mod_script_call("mod", "thronerune-introcont", "intro_create");

#define area_make_floor

// Create blueprint
instance_create(x, y, Floor);

