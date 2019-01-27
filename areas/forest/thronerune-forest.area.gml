
#define init

// Sprites
global.sprFloor = sprite_add("sprFloor.png", 5, 0, 0);
global.sprFloorB = sprite_add("sprFloor.png", 1, 0, 0);
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
global.sprProp[0] = sprite_add("sprProp0.png", 1, 16, 16);
global.sprProp[1] = sprite_add("sprProp1.png", 1, 16, 16);
global.sprPropHurt[0] = sprite_add("sprProp0Hurt.png", 3, 16, 16);
global.sprPropHurt[1] = sprite_add("sprProp1Hurt.png", 3, 16, 16);

#define area_name
return "FRST "+string(GameCont.subarea);

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

#define area_finish
// Next subarea
subarea += 1;
// Next area
if(subarea == 4)
{
    area = 7;
    subarea = 3;
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
{
    if(place_meeting(x, y, Floor)) instance_destroy();
    else create_floor_back(id);
}
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

#define spawn_trees()
// Spawn trees
var _to_place = ds_list_create();
with(Wall) if(random(2) < 1)
    with(instance_create(random_range(x - 64, x + 64), random_range(y - 64, y + 64), CustomObject))
    {
        var _ind = ds_list_size(_to_place);
        for(var i = 0; i < ds_list_size(_to_place); i++)
            if(_to_place[|i].y >= y)
            {
                _ind = i;
                break;
            }
        ds_list_insert(_to_place, _ind, id);
    }
for(var i = ds_list_size(_to_place)-1; i >= 0; i--)
    with(_to_place[|i])
    {
        with(instance_create(x, y, CustomProp))
        {
            depth = 10;
            on_death = tree_dead;
            spr_idle = global.sprTree;
            mask_index = spr_idle;
            if(place_meeting(x, y, Floor) || place_meeting(x, y, Wall))
                instance_destroy();
        }
        instance_destroy();
    }
ds_list_destroy(_to_place);

#define area_start

// Spawn trees
spawn_trees();
    
#define area_pop_enemies

// Spawn enemies
if(random(2) < 1) instance_create(x + 16, y + 16, Bandit);
if(random(3) < 1) instance_create(x + 16, y + 16, Scorpion);

#define area_pop_props

// Props
if(random(12) < 1) {
    with(instance_create(x, y, CustomProp))
    {
        if(place_meeting(x, y, Wall))
        {
            instance_destroy();
            break;
        }
        
        my_health = 999999;
        var _ind = irandom(array_length_1d(global.sprProp)-1);
        spr_idle = global.sprProp[_ind];
        spr_hurt = global.sprPropHurt[_ind];
    }
}

#define tree_dead

// Called when tree is destroyed
repeat(10)
    with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), Feather))
    {
        image_speed = 0;
        sprite_index = global.sprLeaf;
        image_index = irandom(2);
    }
