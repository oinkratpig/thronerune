
#define init

global.sprMask = sprite_add("sprMask.png", 1, 10, 19);
global.spr_nothing = sprite_add("sprNothing.png", 1, 0, 0);

global.snd_empty = sound_add("sndNothing.ogg");

#define race_name
return "KRIS";

#define race_swep
return wep_none;

#define create

facing = 270;
maxspeed = 0;
moving = false;
cutscene = false;
interact_cd = 0;
special_interact = -1;

spr_shadow = global.spr_nothing;
spr_idle = global.spr_nothing;
spr_walk = global.spr_nothing;
spr_hurt = global.spr_nothing;
spr_dead = global.spr_nothing;

snd_wrld = global.snd_empty;
snd_dead = global.snd_empty;
snd_lowa = global.snd_empty;
snd_lowh = global.snd_empty;
snd_chst = global.snd_empty;
snd_valt = global.snd_empty;
snd_crwn = global.snd_empty;
snd_spch = global.snd_empty;
snd_idpd = global.snd_empty;
snd_cptn = global.snd_empty;
snd_hurt = global.snd_empty;

#define meeting_barrier(_x, _y)

// If instance is meeting a walk barrier
var _meeting = false;
with(CustomObject) if("is_walk_barrier" in id) with(other)
    if(place_meeting(_x, _y, other))
    {
        _meeting = true;
        break;
    }
return _meeting;

#define step

// Mask
mask_index = global.sprMask;

// Can't move while in text boxes
if(!mod_variable_get("mod", "thronerune-textboxes", "enabled") && !cutscene)
{
    // Get direction sprite is facing
    if(button_check(index, "nort")) facing = 90;
    else if(button_check(index, "sout")) facing = 270;
    else if(button_check(index, "east")) facing = 0;
    else if(button_check(index, "west")) facing = 180;

    // Movement and collision
    var _spd = 2.25;
    var _hspd = _spd * (button_check(index, "east") - button_check(index, "west"));
    var _vspd = _spd * (button_check(index, "sout") - button_check(index, "nort"));
    moving = _hspd != 0 || _vspd != 0;
    if(!meeting_barrier(x+_hspd, y)) x += _hspd;
    if(!meeting_barrier(x, y+_vspd)) y += _vspd;
}
// Not moving if in text box
else moving = false;

// Interact
var _confirm = button_pressed(index, "pick") || button_pressed(index, "fire") || button_pressed(index, "spec");
if(_confirm && !cutscene && interact_cd < 1)
{
    with(CustomObject) if("is_interactable" in id)
        if(position_meeting(mouse_x[other.index], mouse_y[other.index], id) && !mod_variable_get("mod", "thronerune-textboxes", "enabled"))
        {
            other.interact_cd = 5;
            if("special_interact" in id) other.special_interact = special_interact;
            mod_script_call("mod", "thronerune-textboxes", "textbox_say", desc, desc_face, desc_voice);
        }
}
// Interact cooldown
if(!mod_variable_get("mod", "thronerune-textboxes", "enabled"))
    if(interact_cd >= 1) interact_cd -= 1;
    
// Special interact
if(special_interact != -1 && !mod_variable_get("mod", "thronerune-textboxes", "enabled"))
{
    // Handle
    switch(special_interact)
    {
        // Controller
        case 0:
            mod_script_call("mod", "thronerune-transitioncont", "transition_start");
            break;
    }
    // Reset
    special_interact = -1;
}

