
global.sndFadein = sound_add("sndFadein.ogg");

#macro RAD (global.time/TIME)
#macro TIME 133
global.time = 0;
global.enabled = false;
create_surf();

#define create_surf

global.surf = surface_create(game_width, game_height);

#define transition_start()

// Transition disabled; just die
with(Player) my_health = 0;
with(Wall) instance_destroy();
with(Floor) instance_destroy();
with(CustomObject) instance_destroy();
mod_variable_set("mod", "thronerune-main", "intro", false);
/*
audio_play_sound(global.sndFadein, 0, false);
with(Player)
{
    if(race == "thronerune-kris-normal") cutscene = true;
}
global.enabled = true;
global.scale_rad = 0;
*/

#define step

if(instance_exists(CharSelect)) global.enabled = false;

if(global.enabled)
{
    global.time += 1;
    if(global.time == TIME)
    {
        with(Player) my_health = 0;
        global.enabled = false;
        mod_variable_set("mod", "thronerune-main", "intro", false);
    }
}

#define draw_gui_end

/*
if(global.enabled)
{
    if(!surface_exists(global.surf)) create_surf();
    surface_screenshot(global.surf);
    
    // Surface scale
    var _scale = 1 + 6*sin(RAD);
    
    // Normal surface position
    var _x = -53;
    var _y = 0;
    
    // Dimensions of scaled surface
    var _scaled_game_width = game_width*_scale;
    var _scaled_game_height = game_height*_scale;
    
    // New surface position
    _x -= (_scaled_game_width - game_width) / 2;
    _y -= (_scaled_game_height - game_height) / 2;
    
    draw_surface_ext(global.surf, _x, _y, _scale, _scale, 0, c_white, 1);
    
    // White
    draw_set_color(c_white);
    draw_set_alpha(sin(RAD));
    draw_rectangle(-999, -999, game_width+999, game_height+999, false);
    draw_set_alpha(1);
}
*/