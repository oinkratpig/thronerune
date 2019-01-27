
#define init

// Sprites
global.sprFloor = sprite_add("sprFloor.png", 5, 0, 0);
global.sprFloorB = sprite_add("sprFloorB.png", 1, 0, 0);
global.sprFloorExplo = sprite_add("sprFloorExplo.png", 4, 0, 0);
global.sprWallTop = sprite_add("sprWallTop.png", 8, 0, 0);
global.sprWallBot = sprite_add("sprWallBot.png", 4, 0, 0);
global.sprWallTrans = sprite_add("sprWallTrans.png", 8, 0, 0);
global.sprWallOut = sprite_add("sprWallOut.png", 1, 0, 0);
global.sprDebris = sprite_add("sprDebris.png", 4, 0, 0);
global.sprTree = sprite_add("sprTree.png", 1, 0, 0);
global.sprLeaf = sprite_add("sprLeaf.png", 3, 0, 0);
global.sprFloorBack = sprite_add("sprFloorBack.png", 1, 5, 5);
global.sprNothing = sprite_add("sprNothing.png", 1, 0, 0);

#define area_name
return "FLD "+string(GameCont.subarea);

#define area_sprite(q)
switch (q) {
    case sprFloor1: return global.sprFloor;
    case sprFloor1B: return global.sprFloor;
    case sprFloor1Explo: return global.sprFloorExplo;
    case sprWall1Trans: return global.sprWallTrans;
    case sprWall1Bot: return global.sprWallBot;
    case sprWall1Out: return global.sprWallOut;
    case sprWall1Top: return global.sprWallTop;
    case sprDebris1: return global.sprDebris;
}

#define area_transit
// First level
if(!mod_variable_get("mod", "thronerune-main", "intro") && area == 1 && subarea == 1)
    area = "thronerune-field";

#define area_finish
// Next subarea
subarea += 1;
// Next area
if(subarea == 4)
{
    area = "thronerune-forest";
    subarea = 1;
}

#define area_setup

sound_play_music(mus1);
goal = 125;
background_color = c_black;
BackCont.shadcol = c_black;

#define area_make_floor

// Turn
var turn = choose(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -90, -90, 90, 90);
direction += turn;

// Fat corridors
with(instance_create(x, y, Floor))
    if(place_meeting(x, y, Floor)) instance_destroy();
var _min = [choose(-2, -1, -1), choose(-2, -1, -1)];
var _max = [choose(1, 1, 2), choose(1, 1, 2)];
for(var h = _min[0]; h <= _max[0]; h++)
    for(var w = _min[1]; w <= _max[1]; w++)
        with(instance_create(x + 32*w, y + 32*h, Floor))
        {
            if(place_meeting(x, y, Floor)) instance_destroy();
            else create_floor_back(id);
        }

#define create_floor_back(_creator)
with(instance_create(x, y, CustomObject))
{
    creator = _creator;
    sprite_index = global.sprFloorBack;
    mask_index = global.sprNothing;
    on_step = floor_back_step;
}
#define floor_back_step
if(!instance_exists(creator)) instance_destroy();
else
{
    depth = creator.depth + 10;
    x = creator.x;
    y = creator.y;
}

#define area_start

// Spawn trees
mod_script_call("area", "thronerune-forest", "spawn_trees");

#define area_pop_enemies

// Spawn enemies
if(random(2) < 1) instance_create(x + 16, y + 16, Bandit);
if(random(3) < 1) instance_create(x + 16, y + 16, Scorpion);

#define tree_dead

// Called when tree is destroyed
mod_script_call("area", "thronerune-forest", "tree_dead");
