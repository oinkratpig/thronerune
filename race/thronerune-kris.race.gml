
#define init

global.spr_select = sprite_add("sprSelect.png", 1, 0, 0);
global.spr_ultras = sprite_add("SprUltras.png",	2, 12, 16);
global.spr_ults[1] = sprite_add("sprUltraA.png", 1, 8, 9);
global.spr_ults[2] = sprite_add("sprUltraB.png", 1, 8, 9);
global.spr_mapicon = sprite_add("sprMapicon.png", 1, 10, 10);
global.spr_portrait = sprite_add("sprPortrait.png", 0, 40, 243);

global.spr_idle = sprite_add("sprIdle.png", 4, 12, 12);
global.spr_walk = sprite_add("sprWalk.png", 6, 12, 12);
global.spr_hurt = sprite_add("sprHurt.png", 3, 12, 12);
global.spr_dead = sprite_add("sprDead.png", 6, 12, 12);

global.spr_nothing = sprite_add("sprNothing.png", 1, 0, 0);

global.snd_empty = sound_add("sndNothing.ogg");
global.snd_hurt = sound_add("sndHurt.ogg");

var _race = [];
global.new_level = false;
for(var i = 0; i < maxp; i++) _race[i] = player_get_race(i);
while(true)
{
  // Character select sound
  for(var i = 0; i < maxp; i++){
    var r = player_get_race(i);
    if(_race[i] != r && r == "kris"){
      sound_play(global.snd_empty);
    }
    _race[i] = r;
  }
  
  // New level
  if(instance_exists(GenCont)) global.new_level = true;
  else if(global.new_level)
  {
      global.new_level = false
      new_level();
  }
  
  wait(1);
}

#define new_level

// Followers
/*
with(Player) if(!mod_variable_get("mod", "thronerune-followers", "followers_active"))
    mod_script_call("mod", "thronerune-followers", "followers_create");
*/

#define race_portrait
return global.spr_nothing;

#define race_name
return "KRIS";

#define race_swep
return "thronerune-sword";

#define race_menu_button
sprite_index = global.spr_select;

#define race_text
return "";

#define race_mapicon
return global.spr_mapicon;

#define race_ttip
return ["LOADING TIP"];

#define race_ultra_name
switch(argument0) {
  case 1: return "ULTRA A";
  case 2: return "ULTRA B";
}

#define race_ultra_text
switch(argument0) {
  case 1: return "ULTRA A DESC";
  case 2: return "ULTRA B DESC";
}

#define race_ultra_take
if(instance_exists(mutbutton)) switch(argument0){
  case 1:
    sound_play(global.snd_empty);
    break;
  case 2:
    sound_play(global.snd_empty);
    break;
}

#define race_ultra_button
sprite_index = global.spr_ultras;
image_index = argument0 + 1;

#define race_ultra_icon
return global.spr_ults[argument0];

#define race_tb_text
return "RUDER BUSTER#GREATER HEAL";

#define paralyze(enable)

// Disable/enable player
with(Player)
{
    canwalk = !enable;
    canfire = !enable;
    canpick = !enable;
    canswap = !enable;
    canaim = !enable;
}

#define draw

// Toilet paper
if(toiletpaper != 0)
{
    draw_set_font(fntSmall);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_orange);
    if(mouse_y[index] <= y) draw_set_alpha(0.75);
    else draw_set_alpha(0.95);
    draw_text(x, bbox_top - 7, string(toiletpaper));
    draw_set_alpha(1);
}

#define create

toiletpaper = 0;

// Intro kris
if(mod_variable_get("mod", "thronerune-main", "intro"))
{
    wep = wep_none;
    race = "thronerune-kris-normal";
    mod_script_call("race", "thronerune-kris-normal", "create");
    exit;
}

spr_idle = global.spr_idle;
spr_walk = global.spr_walk;
spr_hurt = global.spr_hurt;
spr_dead = global.spr_dead;

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
snd_hurt = global.snd_hurt;

#define step

// Close spec menu if touching portal
if(distance_to_object(Portal) == 0)
{
    mod_script_call("mod", "thronerune-specmenu", "menu_close");
    paralyze(false);
}

// If not fighting
if(!mod_variable_get("mod", "thronerune-rpg", "rpg_activated"))
{
    // Battle
    if(distance_to_object(enemy) <= 16)
        mod_script_call("mod", "thronerune-rpg", "start_rpg");
    // Spec menu
    /*
    if(button_pressed(index, "horn"))
        mod_script_call("mod", "thronerune-specmenu", "toggle_menu");
    */
    // Summon follower
    if(button_pressed(index, "spec") && toiletpaper >= 20)
    {
        toiletpaper -= 20;
        mod_script_call("mod", "thronerune-susie", "susie_create", x, y);
    }
}

#define game_start
sound_play(global.snd_empty);
