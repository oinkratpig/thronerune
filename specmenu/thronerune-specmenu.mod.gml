
#define init

// Specmenu
menu_close(); // Initialize global variables
global.menu_highlighted = 0;

// Sprites
global.sprSpecmenu = sprite_add("sprSpecmenu.png", 0, 0, 0);
global.sprSpecmenuHighlight = sprite_add("sprSpecmenuHighlight.png", 4, 0, 0);

// Sounds
global.sndMenuMove = sound_add("sndMenuMove.ogg");
global.sndMenuSelect = sound_add("sndMenuSelect.ogg");

#define menu_close

// Force close menu
global.menu_rad = 0;
global.menu_open = false;

#define toggle_menu

// Menu is what it wasn't (what?)
global.menu_open = !global.menu_open;

// Paralyze/Unparalyze
with(Player)
{
    // Can't move while menu open
    if(global.menu_open) mod_script_call("race", "thronerune-kris", "paralyze", true);
    // Can move while menu closed
    else mod_script_call("race", "thronerune-kris", "paralyze", false);
}

#define step

// Force close
if(global.menu_open && !instance_exists(Player))
    menu_close();

// Menu interaction
if(global.menu_open)
{
    
    // Get key presses
    var _right_pressed = false;
    var _left_pressed = false;
    var _select_pressed = false;
    with(Player)
    {
        _right_pressed = button_pressed(index, "east");
        _left_pressed = button_pressed(index, "west");
        _select_pressed = button_pressed(index, "pick");
    }
    
    // Move selected
    if(_right_pressed ^^ _left_pressed)
    {
        // Sound
        sound_play(global.sndMenuMove);
        // Move
        global.menu_highlighted += _right_pressed - _left_pressed;
        if(global.menu_highlighted > sprite_get_number(global.sprSpecmenuHighlight)-1)
            global.menu_highlighted = 0;
        else if(global.menu_highlighted < 0)
            global.menu_highlighted = sprite_get_number(global.sprSpecmenuHighlight)-1;
    }
    
}

// Menu open/close animation
global.menu_rad += (global.menu_open) ? 0.325 : -0.325;
if(global.menu_rad > pi/2) global.menu_rad = pi/2;
else if(global.menu_rad < 0) global.menu_rad = 0;

#define draw_gui

// Draw menu
var _y = -sprite_get_height(global.sprSpecmenu)*cos(global.menu_rad);
draw_sprite(global.sprSpecmenu, 0, 0, _y);
draw_sprite(global.sprSpecmenuHighlight, global.menu_highlighted, 0, _y);
