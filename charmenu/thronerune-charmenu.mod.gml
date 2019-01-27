
#define init

// Macros
#macro CHECK_BOX_X 132
#macro CHECK_BOX_Y 153
#macro CHECK_BOX_SIZE sprite_get_width(global.sprCheckBox)
#macro CHECK_BOX_LEFT (CHECK_BOX_X)
#macro CHECK_BOX_TOP (CHECK_BOX_Y)
#macro CHECK_BOX_RIGHT (CHECK_BOX_X+CHECK_BOX_SIZE)
#macro CHECK_BOX_BOTTOM (CHECK_BOX_Y+CHECK_BOX_SIZE)
#macro CHECK_BOX_TEXT_MARGIN 2

//
global.ALIVE = false;
global.HIM = noone;
global.DARK = pi/2;

// Sprites
global.sprBed = sprite_add("sprBed.png", 1, 23, 36);
global.sprCheckBox = sprite_add("sprCheckBox.png", 1, 0, 0);
global.sprCheck = sprite_add("sprCheck.png", 1, 3, 3);

// Sounds
global.sndClick[0] = sound_add("sndClick0.ogg");
global.sndClick[1] = sound_add("sndClick1.ogg");

// Bed
global.bed_rad = 0;

// Checkmark
global.paint = ds_list_create();

// Misc
global.screenshake = 0;
#macro SHAKE_OFF (choose(-global.screenshake, global.screenshake)*0.66)

// Fix menu every time you visit it
global.menu = true;
while(true)
{
    if(!instance_exists(CharSelect))
    {
        if(!global.menu)
        {
            global.ALIVE = false;
            global.menu = true;
            ds_list_clear(global.paint);
        }
    }
    else if(global.menu)
    {
        wait(1);
        global.menu = false;
        menu();
    }
    wait(1);
}

#define x_to_gui(_x)
// MAIN SCRIPT
return mod_script_call("mod", "thronerune-main", "x_to_gui", _x);
#define y_to_gui(_y)
// MAIN SCRIPT
return mod_script_call("mod", "thronerune-main", "y_to_gui", _y);

#define add_paint()
var _dic = {
    xpos: random_range(CHECK_BOX_LEFT, CHECK_BOX_RIGHT),
    ypos: random_range(CHECK_BOX_TOP, CHECK_BOX_BOTTOM),
    size: 1+random(2),
    dir: random(180),
    spd: 1+random(2),
    grav: random(1),
    rad: random(pi*0.125)
}
ds_list_add(global.paint, _dic);
#define add_paint_drip()
var _dic = {
    xpos: random_range(CHECK_BOX_LEFT, CHECK_BOX_RIGHT),
    ypos: CHECK_BOX_BOTTOM,
    size: 0.5+random(1),
    dir: 0,
    spd: 0,
    grav: random(1),
    rad: random(pi*0.125)
}
ds_list_add(global.paint, _dic);

#define menu

// Clear chat
/*
var _max = 10;
for(var i = 0; i < _max; i++) if(fork())
{
    wait(i);
    repeat(2) trace("  ");
    exit;
}
*/

// Kris is the only character
with(CharSelect)
{
    if(race != "thronerune-kris") instance_delete(id);
    else xstart = game_width/2 - sprite_width/2;
}

// THE DARK
global.bed_rad = 0;
global.HIM = noone;
global.DARK = pi/2;
background_color = c_black;
with(Wall) instance_delete(id);
with(Floor) instance_delete(id);
with(FloorMaker) instance_delete(id);
with(CampChar) instance_delete(id);
with(LogMenu) instance_delete(id);
with(TV) instance_delete(id);
with(Campfire)
{
    global.ALIVE = true;
    global.HIM = instance_create(x, y, CustomObject);
    with(global.HIM)
    {
        on_step = DARKERSTILL;
        on_draw = DARKERYETDARKER;
    }
    instance_delete(id);
}

#define DARKERSTILL
menu_step();
global.DARK += (CharSelect.mouseover) ? -0.1 : 0.1;
if(global.DARK > pi/2) global.DARK = pi/2;
else if(global.DARK < 0) global.DARK = 0;
#define DARKERYETDARKER
var _str = "Welcome.#Choose your vessel.";
draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_set_font(fntM);
draw_set_alpha(0.15 * sin(global.DARK));
_scale = 1;
draw_text_transformed(x + dcos(current_time/6)*2, y + dsin(-current_time/6)*2, _str, _scale, _scale, 0);
draw_set_alpha(0.15 * sin(global.DARK));
draw_text_transformed(x + dsin(current_time/6)*2, y + dcos(-current_time/6)*2, _str, _scale, _scale, 0);
draw_set_alpha(sin(global.DARK));
draw_text_transformed(x+random_range(-0.14, 0.14), y+random_range(-0.14, 0.14), _str, _scale, _scale, 0);
draw_set_alpha(1);

#define menu_step

// Bed fade-in
if(global.DARK == 0) global.bed_rad = min(global.bed_rad + 0.05, pi/2);
else global.bed_rad = 0;

// Check box
if(global.bed_rad > pi/4)
{
    // Check box
    if(point_in_rectangle(x_to_gui(mouse_x), y_to_gui(mouse_y), CHECK_BOX_LEFT, CHECK_BOX_TOP, CHECK_BOX_RIGHT, CHECK_BOX_BOTTOM))
        if(button_pressed(0, "fire"))
        {
            global.screenshake = 3;
            var _enabled = !mod_variable_get("mod", "thronerune-main", "intro");
            mod_variable_set("mod", "thronerune-main", "intro", _enabled);
            sound_play(global.sndClick[!_enabled]);
            repeat(9 + 6*_enabled) add_paint();
        }
    // Check box drip
    if(mod_variable_get("mod", "thronerune-main", "intro"))
        if(current_frame % 10 == 0 && random(2) < 1)
            add_paint_drip();
}

// Paint movement
for(var i = 0; i < ds_list_size(global.paint); i++)
{
    // Movement
    global.paint[|i].xpos += dcos(global.paint[|i].dir) * global.paint[|i].spd;
    global.paint[|i].ypos += dsin(-global.paint[|i].dir) * global.paint[|i].spd;
    // Gravity
    global.paint[|i].ypos += global.paint[|i].grav;
    global.paint[|i].grav += global.paint[|i].size*0.15;
    // Life
    global.paint[|i].rad += 0.05;
    if(global.paint[|i].rad >= pi/2) ds_list_delete(global.paint, i);
}

// Screenshake
global.screenshake *= 0.7;
if(global.screenshake < 0.1) global.screenshake = 0;

#define draw_gui
if(global.ALIVE) menu_draw_gui();

#define menu_draw_gui

// Draw bed
var _alpha = sin(global.bed_rad);
var _scale = 0.75;
var _off_x = random_range(1.5, 3) * dcos(current_time/4);
var _off_y = random_range(1.5, 3) * dsin(-current_time/4);
draw_sprite_ext(global.sprBed, 0, game_width/2+SHAKE_OFF - _off_x, game_height/2+SHAKE_OFF - _off_y, _scale, _scale, 0, c_white, _alpha*0.075);
draw_sprite_ext(global.sprBed, 0, game_width/2+SHAKE_OFF + _off_x, game_height/2+SHAKE_OFF + _off_y, _scale, _scale, 0, c_white, _alpha*0.075);
draw_sprite_ext(global.sprBed, 0, game_width/2+SHAKE_OFF, game_height/2+SHAKE_OFF, _scale, _scale, 0, c_white, _alpha);

// Draw check box
draw_sprite_ext(global.sprCheckBox, 0, CHECK_BOX_LEFT+SHAKE_OFF, CHECK_BOX_TOP+SHAKE_OFF, 1, 1, 0, c_white, _alpha);
if(mod_variable_get("mod", "thronerune-main", "intro"))
    draw_sprite_ext(global.sprCheck, 0, CHECK_BOX_LEFT+SHAKE_OFF, CHECK_BOX_TOP+SHAKE_OFF, 1, 1, 0, c_white, _alpha);
draw_set_color(c_white);
draw_set_font(fntSmall);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_alpha(_alpha);
draw_text(CHECK_BOX_RIGHT+SHAKE_OFF + CHECK_BOX_TEXT_MARGIN, CHECK_BOX_TOP+SHAKE_OFF+(CHECK_BOX_BOTTOM-CHECK_BOX_TOP)/2, "Enable intro");
draw_set_alpha(1);

// Checkmark paint
draw_set_color(make_color_rgb(0, 255, 0));
for(var i = 0; i < ds_list_size(global.paint); i++)
{
    var _size = global.paint[|i].size * cos(global.paint[|i].rad);
    draw_circle(global.paint[|i].xpos, global.paint[|i].ypos, _size, false);
}