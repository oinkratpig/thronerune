
#define init

// Constants
#macro TILE_SIZE 16
#macro BATTLE_WIDTH 4
#macro BATTLE_HEIGHT 4
#macro PLAYER_GRAZE_DIST 8

// Macros
#macro BATTLE_MARGIN (game_width*0.175)
#macro IMAGE_INDEX (current_time/100)

// Globals
global.blindfolds = ds_list_create();               // List of walls 'blinding' enemies; preventing them from attacking
global.graze_rad = pi/2;                            // Radians used for graze animation
global.graze_avail = true;                          // If graze can be used (cooldown)
global.info_box_text = "";                          // Text to display in info box
global.info_box_char_index = 0;                     // index of last char to display in info box
global.names = ["Kris", "Susie", "Ralsei"];         // Names of each character
global.colors[0] = make_color_rgb(0, 255, 255);     // Colors of each character's box
global.colors[1] = make_color_rgb(255, 0, 255);
global.colors[2] = make_color_rgb(0, 255, 0);
global.colors_dark[0] = make_color_rgb(0, 125, 125);    // Colors of each character's box (darker)
global.colors_dark[1] = make_color_rgb(125, 0, 125);
global.colors_dark[2] = make_color_rgb(0, 125, 0);
global.battle_start_time = 0;                           // Time (current_frame) the battle started
global.text_pause_time = 0;                         // Pause after text is done cycling

// Sprites
global.sprKrisIdle = sprite_add("sprKrisIdle.png", 4, 12, 12);
global.sprSusieIdle = sprite_add("sprSusieIdle.png", 4, 12, 12);
global.sprRalseiIdle = sprite_add("sprRalseiIdle.png", 4, 12, 12);
global.sprHeart = sprite_add("sprHeart.png", 1, 3, 3);
global.sprHeartGraze = sprite_add("sprHeartGraze.png", 1, 8, 8);
global.sprKrisMenu = sprite_add("sprKrisMenu.png", 1, 0, 0);
global.sprSusieMenu = sprite_add("sprSusieMenu.png", 1, 0, 0);
global.sprRalseiMenu = sprite_add("sprRalseiMenu.png", 1, 0, 0);
global.sprKrisMenuSelected = sprite_add("sprKrisMenuSelected.png", 1, 0, 0);
global.sprSusieMenuSelected = sprite_add("sprSusieMenuSelected.png", 1, 0, 0);
global.sprRalseiMenuSelected = sprite_add("sprRalseiMenuSelected.png", 1, 0, 0);
global.sprLine = sprite_add("sprLine.png", 1, 0, 0);
global.sprLineTop = sprite_add("sprLineTop.png", 1, 0, 0);
global.sprMenuHighlightAct = sprite_add("sprMenuHighlightAct.png", 3, 0, 0);
global.sprMenuHighlightMagic = sprite_add("sprMenuHighlightMagic.png", 2, 0, 0);
global.sprBattlebox = sprite_add("sprBattlebox.png", 1, 42, 42);
global.sprNothing = sprite_add("sprNothing.png", 1, 0, 0);
global.sprFace[0] = sprite_add("sprKrisFace.png", 1, 0, 6);
global.sprFace[1] = sprite_add("sprSusieFace.png", 1, 0, 6);
global.sprFace[2] = sprite_add("sprRalseiFace.png", 1, 0, 7);
global.sprDiamondCutter = sprite_add("sprDiamondCutter.png", 1, 6, 4);
global.sprKrisEntrance = sprite_add("sprKrisEntrance.png", 6, 14, 20);
global.sprRalseiEntrance = sprite_add("sprRalseiEntrance.png", 6, 12, 12);
global.sprSusieEntrance = sprite_add("sprSusieEntrance.png", 4, 12, 12);
global.sprCharSelectButtons = sprite_add("sprCharSelectButtons.png", 2, 0, 0);

// Sounds
global.musRudeBuster = sound_add("musRudeBuster.ogg");
global.sndMenuMove = sound_add("sndMenuMove.ogg");
global.sndMenuSelect = sound_add("sndMenuSelect.ogg");
global.sndBattleStart = sound_add("sndBattleStart.ogg");
global.sndHit = sound_add("sndHit.ogg");
global.sndDefeatRun = sound_add("sndDefeatRun.ogg");
global.sndDamage = sound_add("sndDamage.ogg");
global.sndGraze = sound_add("sndGraze.ogg");
global.sndText = sound_add("sndText.ogg");

// Battle box
#macro BATTLEBOX_X (game_width/2)
#macro BATTLEBOX_Y (MENU_BOTTOM*0.55)
#macro BATTLEBOX_WIDTH sprite_get_width(global.sprBattlebox)
#macro BATTLEBOX_HEIGHT sprite_get_height(global.sprBattlebox)
#macro BATTLEBOX_LEFT (BATTLEBOX_X - BATTLEBOX_WIDTH/2 + 4)
#macro BATTLEBOX_RIGHT (BATTLEBOX_X + BATTLEBOX_WIDTH/2 - 4)
#macro BATTLEBOX_TOP (BATTLEBOX_Y - BATTLEBOX_HEIGHT/2 + 4)
#macro BATTLEBOX_BOTTOM (BATTLEBOX_Y + BATTLEBOX_HEIGHT/2 - 4)
global.attack_alarm_max = room_speed*5;                         // Max frames until enemy stops attacking
global.attack_alarm = global.attack_alarm_max;                  // Frames until the enemy stops attacking
global.px = BATTLEBOX_X;                                        // X position of player heart
global.py = BATTLEBOX_Y;                                        // Y position of player heart
global.box_spin_rad = 0;                                        // Box spin in radians

// Menu
global.button_selected = 0;                         // Index of button that is highlighted on player turn
global.rpg_activated = false;                       // Whether or not you're in battle
global.finished = false;                            // Whether or not the battle is over
enum states {
    selecting,
    act,
    player_attacking,
    acting,
    enemy_attacking,
    battle_won
}
global.state = states.selecting;
global.turn = 0;

// Buttons
#macro MENU_MARGIN 10
#macro MENU_TOP (game_height*0.58)
#macro MENU_BOTTOM (MENU_TOP + sprite_get_height(global.sprKrisMenu))
#macro MENU_KRIS_LEFT ((game_width - (sprite_get_width(global.sprKrisMenu)*3 + MENU_MARGIN*2)) / 2)
#macro MENU_KRIS_RIGHT (MENU_KRIS_LEFT + sprite_get_width(global.sprKrisMenu))
#macro MENU_SUSIE_LEFT (MENU_KRIS_RIGHT + MENU_MARGIN)
#macro MENU_SUSIE_RIGHT (MENU_SUSIE_LEFT + sprite_get_width(global.sprSusieMenu))
#macro MENU_RALSEI_LEFT (MENU_SUSIE_RIGHT + MENU_MARGIN)
#macro MENU_RALSEI_RIGHT (MENU_RALSEI_LEFT + sprite_get_width(global.sprRalseiMenu))

// Attack
#macro ATTACK_RECT_WIDTH 50                 // Width of rectangle behind goal bar
#macro ATTACK_RECT_HEIGHT 17                // Height of rectangle behind goal bar
#macro ATTACK_RECT_LEFT 60                  // Left position of rectangle behind goal bar
#macro ATTACK_TOP (MENU_BOTTOM + 4)         // Top position of first attack bar
#macro ATTACK_GOAL_WIDTH 3                  // Width or attack bars/goals
#macro ATTACK_RECT_MARGIN 2                 // Margin between each bar/goal
#macro ATTACK_GRACE_DIST 6                  // Max distance from goal bar to not be miss
#macro ATTACK_GRACE_YELLOW_DIST 2           // Max distance from goal bar to not be miss (yellow)
#macro ATTACK_BAR_SPEED 5.25                // Speed of attack bars
global.attack_bars = ds_list_create();      // List of x positions of attack bars
enum actions {
    nothing,
    defend,
    attack,
    act,
    skill,
    spare
}
global.char_actions = [];                   // Array of what characters did
global.attack_bar_anims = ds_list_create(); // List of attack bar animations to display [x, index, rad, yellow]

// Acting
#macro ACT_MARGIN_TOP 15
#macro ACT_MARGIN_LEFT (game_width*0.175)
#macro ACT_HEART_MARGIN 10
#macro ACT_TOP (MENU_BOTTOM + ACT_MARGIN_TOP)
#macro ACT_LEFT ACT_MARGIN_LEFT
#macro ACT_LEFT2 (ACT_LEFT + ACT_MARGIN_LEFT*1.75)
global.act_selected = 0;                    // Index of act option currently selected
global.acted = undefined;                   // Array of acts characters did
global.act_options = ds_list_create();      // List of possible acts to make (dictionaries)
ds_list_add(global.act_options, {desc: "Flirt", on_act: act_flirt});
ds_list_add(global.act_options, {desc: "Talk", on_act: act_talk});
#macro ACTING_CONTINUE_ALARM 15
global.acting_continue_alarm = 0;

// Bullets
enum bullet_types {
    friendliness_pellet,
    diamond_cutter
}

// Misc animations
global.reposition_characters_rad = 0;   // Radians of moving characters to edge of screen smoothly

// Back to menu
while(true)
{
    if(global.rpg_activated && instance_exists(CharSelect))
        end_rpg();
    wait(1);
}

#define x_to_gui(_x)
// MAIN SCRIPT
return mod_script_call("mod", "thronerune-main", "x_to_gui", _x);
#define y_to_gui(_y)
// MAIN SCRIPT
return mod_script_call("mod", "thronerune-main", "y_to_gui", _y);
#define round_to(_n, _num)

// Rounds a number to given number
var _divides = floor(_n / _num);
_n -= _num*_divides;
var _higher = _n >= _num/2;
return _num * (_divides + _higher);

#define meeting_heart(_x, _y)

// Returns if coordinates are colliding with the heart's position
var _meeting = false;
with(instance_create(global.px, global.py, CustomObject))
{
    sprite_index = global.sprHeart;
    if(position_meeting(_x, _y, id) || place_meeting(x, y, other))
        _meeting = true;
    instance_destroy();
}
return _meeting;

#define destroy_walls(_xstart, _ystart, _w, _h)

// Destroys any walls in given position in rectangle of w*h
var _x, _y;
for(var h = 0; h < _h; h++)
    for(var w = 0; w < _w; w++)
    {
        _x = round_to(_xstart, TILE_SIZE) + TILE_SIZE*w;
        _y = round_to(_ystart, TILE_SIZE) + TILE_SIZE*h;
        with(instance_create(_x, _y, PortalClear))
        {
            image_xscale = 0.03;
            image_yscale = 0.03;
        }
    }

#define info_box_say(_str)

// Say string in info box
if(_str != global.info_box_text)
{
    global.info_box_text = _str;
    global.info_box_char_index = 1;
}

#define start_rpg

// Start music, sound effect
audio_pause_all();
sound_loop(global.musRudeBuster);
sound_play(global.sndBattleStart);

// Close spec menu
mod_script_call("mod", "thronerune-specmenu", "menu_close");

// Message
info_box_say("* Some enemies approached!#* They don't smell good.");

// Activate
global.rpg_activated = true;
global.finished = false;
global.state = states.selecting;
global.battle_start_time = current_frame + 6;
global.char_actions = [actions.nothing, actions.nothing, actions.nothing];
global.acted = undefined;
global.acting_continue_alarm = ACTING_CONTINUE_ALARM;
global.turn = 0;

// Player stuff
global.reposition_characters_rad = pi*0.15;
mod_script_call("race", "thronerune-kris", "paralyze", true);

// Trap player
with(Player)
{
    for(var h = -2; h <= 1; h++)
        for(var w = -2; w <= 1; w++)
        {
            var _inst = instance_create(x + TILE_SIZE*w, y + TILE_SIZE*h, Wall);
            with(_inst)
            {
                sprite_index = global.sprNothing;
                mask_index = sprWall1Bot;
            }
            ds_list_add(global.blindfolds, _inst);
        }
}

// Add enemies to enemies array
var _enemies = [];
with(enemy)
{
    // Kill
    if(point_in_view(x, y))
    {
        // Give rads
        if("raddrop" in id)
        {
            repeat(raddrop)
                instance_create(other.x, other.y, Rad);
            raddrop = 0;
        }
        // Add to enemy array
        _enemies[array_length_1d(_enemies)] = id;
    }
}

// Spawn enemy objects
for(var i = array_length_1d(_enemies)-1; i >= 0 i--)
{
    var _enemy = _enemies[i];
    with(instance_create(0, 0, CustomObject))
    {
        // Misc variables
        is_rpg_enemy = true;
        xoff = (i+1)/array_length_1d(_enemies) * random_range(-5, 5);
        yoff = game_height*0.1 + (i+1)/(array_length_1d(_enemies)+1) * (game_height*0.5);
        spr_idle = _enemy.spr_idle;
        spr = spr_idle;
        spr_defeat = _enemy.spr_walk;
        spr_hurt = _enemy.spr_hurt;
        mhp = max(round(_enemy.maxhealth/10), 1);
        hp = mhp;
        dead = false;
        run_rad = 0;
        on_step = rpg_enemy_step;
        bullet_cd = 0;
        hurting = 0;
        
        flirts_left = 2;
        talks_left = 1;
        
        // Bullet type
        bullet_type = undefined;
        switch(_enemy.object_index)
        {
            // Diamond cutter
            case GoldScorpion:
            case Scorpion: bullet_type = bullet_types.diamond_cutter; break;
            // Friendliness pellet
            default: bullet_type = bullet_types.friendliness_pellet; break;
        }
    }
    with(_enemy) instance_destroy();
}

// Give player pickups
with(Pickup)
{
    x = other.x;
    y = other.y;
}

#define rpg_enemy_step
// Run away
if(dead)
{
    if(run_alarm >= 1) run_alarm--;
    else
    {
        run_rad = min(run_rad + 0.125, pi/2);
        spr = spr_defeat;
    }
}
// Hurt animation
else if(hurting >= 1)
{
    hurting--;
    spr = spr_hurt;
}
else spr = spr_idle;

#define characters_attacking()

// Returns number of characters attacking
_chars_attacking = 0;
for(var i = 0; i < 3; i++) if(global.char_actions[i] == actions.attack)
    _chars_attacking += 1;
return _chars_attacking;

#define end_rpg()

// Stop battle music
sound_stop(global.musRudeBuster);
audio_resume_all();

// Unparalyze player
mod_script_call("race", "thronerune-kris", "paralyze", false);

// Disable/clear stuff
global.rpg_activated = false;
global.button_selected = 0;
global.state = states.selecting;
global.box_spin_rad = 0;
ds_list_clear(global.attack_bars);
ds_list_clear(global.attack_bar_anims);

// Destroy RPG objects
with(CustomObject) if("is_rpg_enemy" in id || "is_rpg_bullet" in id || "is_rpg_dmgnum" in id)
    instance_destroy();

// Destroy blindfolds
for(var i = 0; i < ds_list_size(global.blindfolds); i++)
    with(global.blindfolds[|i]) instance_delete(id);
ds_list_clear(global.blindfolds);

#define draw_grid_tiled(_xoff, _yoff, _size)

// Draw grids covering whole screen
while(_xoff > _size) _xoff -= _size;
while(_yoff > _size) _yoff -= _size;
var _x, _y;
var _grid_w = _size;
var _grid_h = _size;
for(var h = game_height % _grid_h * -1 / 3; h < game_height % _grid_h / 3; h++)
    for(var w = game_width % _grid_w * -1 / 3; w < game_width % _grid_w / 3; w++)
    {
        _x = _grid_w * w + _xoff;
        _y = _grid_h * h + _yoff;
        draw_rectangle(_x, _y, _x+_grid_w, _y+_grid_h, true);
    }

#define draw_rectangle_size(_x, _y, _w, _h, _outline)

// Draws a rectangle with given size with origin at center
draw_rectangle(_x - _w/2, _y - _h/2, _x + _w/2, _y + _h/2, _outline);

#define draw_gui

// RPG
if(global.rpg_activated)
{

    // Background
    draw_set_color(c_black);
    draw_set_alpha(sin(global.reposition_characters_rad));
    draw_rectangle(0, 0, game_width, game_height, false);
    
    // Grid thingy
    draw_set_color(c_green);
    draw_set_alpha(0.15 * sin(global.reposition_characters_rad));
    draw_grid_tiled(current_time/35, current_time/35, 75);
    draw_set_alpha(sin(global.reposition_characters_rad));
    draw_grid_tiled(current_time/50, current_time/50, 50);
    draw_set_alpha(1);
    
    // Draw characters
    var _idle_sprites = [global.sprKrisIdle, global.sprSusieIdle, global.sprRalseiIdle];
    var _entr_sprites = [global.sprKrisEntrance, global.sprSusieEntrance, global.sprRalseiEntrance];
    for(var i = 2; i >= 0; i--)
    {
        // Position
        var _player_x = BATTLE_MARGIN;
        var _player_y = game_height*0.1 + (i+1)/(3+1) * (game_height*0.5);
        _player_x += (x_to_gui(Player.x) - _player_x) * cos(global.reposition_characters_rad);
        _player_y += (y_to_gui(Player.y) - _player_y) * cos(global.reposition_characters_rad);
        
        // Sprite
        var _spr = _idle_sprites[i];
        var _spr_index = IMAGE_INDEX;
        var _anim_time = 12;
        // Entrance animation
        if(global.battle_start_time >= current_frame - _anim_time)
        {
            _spr = _entr_sprites[i];
            _spr_index = (current_frame - global.battle_start_time) / _anim_time * sprite_get_number(_spr);
        }
        
        // Draw
        draw_sprite_ext(_spr, _spr_index, _player_x, _player_y, 1, 1, 0, c_white, sin(global.reposition_characters_rad));
    }
    
    // Draw enemies
    with(CustomObject) if("is_rpg_enemy" in id)
    {
        var _running = spr == spr_defeat;
        var _enemy_x = game_width - BATTLE_MARGIN + xoff;
        _enemy_x += (game_width - _enemy_x + sprite_get_width(spr))*sin(run_rad);
        var _enemy_y = yoff;
        _enemy_x += BATTLE_MARGIN*0.1*cos(global.reposition_characters_rad);
        for(var i = 0; i <= _running; i++)
            draw_sprite_ext(spr, (dead) ? sprite_get_number(spr)-1 : IMAGE_INDEX, _enemy_x - 16*i, _enemy_y, (_running) ? 1 : -1, 1, 0, c_white, 1 - 0.5*i);
    }

    // Draw battle box
    if(global.box_spin_rad > 0)
    {
        var _max = (global.box_spin_rad < pi/2)*2 + 1;
        for(var i = 0; i < _max; i++)
        {
            var _scale = sin(global.box_spin_rad - 0.15*i);
            var _angle = 90*sin(global.box_spin_rad - 0.15*i);
            var _alpha = 1;
            if(i == 1) _alpha = 0.15;
            else if(i == 2) _alpha = 0.075;
            draw_sprite_ext(global.sprBattlebox, 0, BATTLEBOX_X, BATTLEBOX_Y, _scale, _scale, _angle, c_white, _alpha);
        }
        draw_set_alpha(1);
    }
    
    // Inside battle box
    if(global.state == states.enemy_attacking)
    {
        
        // Draw player heart
        draw_sprite(global.sprHeart, 0, global.px, global.py);
        var _alpha = 0.66*cos(global.graze_rad);
        draw_sprite_ext(global.sprHeartGraze, 0, global.px, global.py, 1, 1, 0, c_white, _alpha);
        
        // Draw bullets
        with(CustomObject) if("is_rpg_bullet" in id)
        {
            switch(type)
            {
                // Diamond cutter
                case bullet_types.diamond_cutter:
                    draw_sprite_ext(sprite_index, 0, bx, by, 1, 1, dir, c_white, image_alpha);
                    break;
                // Normal
                case bullet_types.friendliness_pellet:
                    draw_set_color(c_white);
                    draw_circle(bx, by, 1.75, false);
                    break;
                // Error
                default:
                    instance_destroy();
                    break;
            }
        }
    }
    
    // Selecting option
    else if(global.state == states.selecting || global.state == states.act)
    {
        // Fight menus
        var _line_off_y = 14;
        draw_sprite_ext(global.sprLineTop, 0, 0, MENU_TOP+_line_off_y, game_width, 1, 0, c_white, 1);
        draw_sprite((global.turn == 0) ? global.sprKrisMenuSelected : global.sprKrisMenu, 0, MENU_KRIS_LEFT, MENU_TOP);
        draw_sprite((global.turn == 1) ? global.sprSusieMenuSelected : global.sprSusieMenu, 0, MENU_SUSIE_LEFT, MENU_TOP);
        draw_sprite((global.turn == 2) ? global.sprRalseiMenuSelected : global.sprRalseiMenu, 0, MENU_RALSEI_LEFT, MENU_TOP);
        switch(global.turn)
        {
            case 0:
                draw_sprite(global.sprCharSelectButtons, 0, MENU_KRIS_LEFT, MENU_TOP);
                break;
            case 1:
                draw_sprite(global.sprCharSelectButtons, 1, MENU_SUSIE_LEFT, MENU_TOP);
                break;
            case 2:
                draw_sprite(global.sprCharSelectButtons, 1, MENU_RALSEI_LEFT, MENU_TOP);
                break;
        }
        // Highlight
        if(global.state != states.act)
        {
            var _y = MENU_TOP;
            var _x;
            switch(global.turn)
            {
                case 0: _x = MENU_KRIS_LEFT; break;
                case 1: _x = MENU_SUSIE_LEFT; break;
                case 2: _x = MENU_RALSEI_LEFT; break;
            }
            var _spr = global.sprMenuHighlightMagic;
            if(global.turn == 0) _spr = global.sprMenuHighlightAct;
            draw_sprite(_spr, global.button_selected, _x, _y);
        }
    }
    
    // Info box
    draw_set_color(c_black);
    draw_set_alpha(sin(global.reposition_characters_rad));
    draw_rectangle(0, MENU_BOTTOM-1, game_width, game_height, false);
    draw_sprite_ext(global.sprLine, 0, 0, MENU_BOTTOM-1, game_width, 1, 0, c_white, draw_get_alpha());
    draw_set_alpha(1);
    
    // Attacking
    if(global.state == states.player_attacking)
    {
        // Goal
        var _y = ATTACK_TOP;
        var _h = ATTACK_RECT_HEIGHT;
        for(var k = 0; k < 3; k++) if(global.char_actions[k] == actions.attack)
        {
            draw_set_color(global.colors_dark[k]);
            draw_rectangle(ATTACK_RECT_LEFT, _y, ATTACK_RECT_LEFT + ATTACK_RECT_WIDTH, _y+_h, true);
            draw_set_color(global.colors[k]);
            draw_rectangle(ATTACK_RECT_LEFT, _y, ATTACK_RECT_LEFT + ATTACK_GOAL_WIDTH, _y+_h, true);
            _y += _h + ATTACK_RECT_MARGIN;
        }
        // Bars
        _y = ATTACK_TOP;
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_font(fntSmall);
        var i = 0;
        for(var k = 0; k < 3; k++) if(global.char_actions[k] == actions.attack)
        {
            // Animation
            for(var j = 0; j < ds_list_size(global.attack_bar_anims); j++) if(global.attack_bar_anims[|j][1] == i)
            {
                if(global.attack_bar_anims[|j][3]) draw_set_color(c_yellow);
                var _xoff = 3*sin(global.attack_bar_anims[|j][2]);
                var _yoff = 3*sin(global.attack_bar_anims[|j][2]);
                draw_set_alpha(cos(global.attack_bar_anims[|j][2]));
                draw_rectangle(global.attack_bar_anims[|j][0] - _xoff, _y - _yoff, global.attack_bar_anims[|j][0] + ATTACK_GOAL_WIDTH + _xoff, _y+_h + _yoff, true);
                draw_set_alpha(1);
                draw_set_color(c_white);
            }
            // Bar (with ghosty ones behind it)
            for(var l = 2; l >= 0; l--)
            {
                var _bar_left = global.attack_bars[|i] + ATTACK_GOAL_WIDTH*2.25*l;
                var _bar_top = _y;
                var _bar_right = _bar_left + ATTACK_GOAL_WIDTH;
                var _bar_bottom = _y+_h;
                draw_set_alpha((l == 2) ? 0.15 : ((l == 1) ? 0.5 : 1));
                draw_rectangle(_bar_left, _bar_top, _bar_right, _bar_bottom, false);
            }
            // Face
            var _face_left = 8;
            var _face_right = _face_left + sprite_get_width(global.sprFace[k]);
            draw_sprite(global.sprFace[k], 0, _face_left, _y + _h/2);
            draw_text(_face_right + 3, _y + _h/2, "PRESS E");
            
            _y += _h + ATTACK_RECT_MARGIN;
            i++;
        }
    }
    
    // Info text
    else if(global.state != states.act)
    {
        draw_set_alpha(sin(global.reposition_characters_rad));
        draw_set_color(c_white);
        draw_set_font(fntM);
        draw_set_halign(fa_left);
        draw_set_valign(fa_center);
        var _x = 20;
        var _y = MENU_BOTTOM + (game_height - MENU_BOTTOM)/2;
        var _str = string_copy(global.info_box_text, 0, global.info_box_char_index);
        draw_text(_x, _y, _str);
        draw_set_alpha(1);
    }
    
    // Act/magic text
    else
    {
        draw_set_alpha(sin(global.reposition_characters_rad));
        draw_set_color(c_white);
        draw_set_font(fntM);
        draw_set_halign(fa_left);
        draw_set_valign(fa_center);
        var _y = ACT_TOP;
        for(var i = 0; i < ds_list_size(global.act_options); i++)
        {
            var _right = i % 2 == 1;
            var _x = (_right) ? ACT_LEFT2 : ACT_LEFT;
            if(global.act_selected == i)
                draw_sprite_ext(global.sprHeart, 0, _x - ACT_HEART_MARGIN, _y, 1, 1, 0, c_white, draw_get_alpha());
            var _str = global.act_options[|i].desc;
            draw_text(_x, _y, _str);
            if(_right) _y += string_height(_str) * 1.66;
        }
        draw_set_alpha(1);
    }
    
    // Damage numbers
    draw_set_font(fntM);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    with(CustomObject) if("is_rpg_dmgnum" in id)
    {
        if(done) draw_set_alpha(max(cos(rad), 0));
        draw_set_color(col);
        draw_text_shadow(dx, dy - ((done) ? 0 : 20 - 12*bounced)*sin(rad), str);
    }
    draw_set_alpha(1);
    
}

#define player_hurt

// Hurt player (damage is equal to number of characters attacking)
with(Player) projectile_hit_raw(id, characters_attacking(), 1);

#define point_on_battle_box(_x, _y)

// Returns if point is on the battle box
return (_x >= BATTLEBOX_LEFT && _x <= BATTLEBOX_RIGHT && _y >= BATTLEBOX_TOP && _y <= BATTLEBOX_BOTTOM);

#define grazed

// Grazed a bullet
sound_play(global.sndGraze);
global.graze_rad = 0;
global.graze_avail = false;

#define hit_enemy(_attacker, _dmg, _show_dmg_num)

// Hurt first enemy
with(CustomObject) if("is_rpg_enemy" in id) if(!dead)
{
    // Position at player so 3d sound doesn't make it sound weird
    with(Player)
    {
        other.x = x;
        other.y = y;
    }
    
    // Hurt
    var _old_hp = hp;
    hp -= _dmg;
    sound_play(global.sndDamage);
    if(_show_dmg_num) with(instance_create(0, 0, CustomObject))
    {
        is_rpg_dmgnum = true;
        col = global.colors[_attacker];
        str = string(_dmg);
        dx = game_width - BATTLE_MARGIN + other.xoff + random_range(-9, 9);
        dy = other.yoff + random_range(-9, 9);
        on_step = rpg_dmgnum_step;
        rad = pi*0.33;
        bounced = false;
        done = false;
    }
    
    // Killed
    if(hp <= 0)
    {
        sound_play(global.sndDefeatRun);
        dead = true;
        run_alarm = 13;
        run_rad = 0;
        spr = spr_hurt;
    }
    // Hurted
    else hurting = 5;
    
    break;
}

#define rpg_dmgnum_step

// Movement
rad += (done) ? 0.075 : 0.375 - 0.2*bounced;
if(rad >= pi)
{
    // Done bouncing
    if(done)
        instance_destroy();
    // Big bounce
    else if(!bounced)
    {
        bounced = true;
        rad -= pi;
    }
    // Small bounce
    else
    {
        rad -= pi;
        done = true;
    }
}

#define enemies_alive()

// Returns number of living enemies
var _enemy_count = 0;
with(CustomObject) if("is_rpg_enemy" in id) if(!dead)
    _enemy_count += 1;
return _enemy_count;

#define step

// If RPG
if(global.rpg_activated)
{
    
    // Cycle text
    if(global.info_box_char_index < string_length(global.info_box_text))
    {
        sound_play(global.sndText);
        global.info_box_char_index = min(global.info_box_char_index+2.33, string_length(global.info_box_text));
        if(global.info_box_char_index == string_length(global.info_box_text))
            global.text_pause_time = 20;
    }
    // Text pause after cycled
    if(global.text_pause_time >= 1) global.text_pause_time--;
    var _text_cycled = (global.info_box_char_index == string_length(global.info_box_text) && global.text_pause_time < 1);
    
    // Player dead, force close RPG
    if(!instance_exists(Player))
    {
        end_rpg();
        exit;
    }
    // Enemies dead, won
    else if(global.state != states.battle_won && enemies_alive() <= 0 && _text_cycled)
    {
        global.finished = true;
        global.state = states.battle_won;
        info_box_say("* You won! You earned 0 D$.");
    }
    
    // Finished
    if(global.finished)
    {
        // Get if all enemies gone
        var _all_gone = true;
        with(CustomObject) if("is_rpg_enemy" in id) if(run_rad != pi/2)
            _all_gone = false;
        // End battle
        if(_all_gone)
        {
            global.reposition_characters_rad -= 0.075;
            if(global.reposition_characters_rad <= 0) end_rpg();
            exit;
        }
    }
    // Move characters to edge
    else
    {
        global.reposition_characters_rad += 0.2;
        if(global.reposition_characters_rad > pi/2) global.reposition_characters_rad = pi/2;
    }
    
    // Keys
    var _right = false;
    var _left = false;
    var _up = false;
    var _down = false;
    var _right_pressed = false;
    var _left_pressed = false;
    var _up_pressed = false;
    var _down_pressed = false;
    var _select = false;
    with(Player)
    {
        _right = button_check(index, "east");
        _up = button_check(index, "nort");
        _left = button_check(index, "west");
        _down = button_check(index, "sout");
        _right_pressed = button_pressed(index, "east");
        _up_pressed = button_pressed(index, "nort");
        _left_pressed = button_pressed(index, "west");
        _down_pressed = button_pressed(index, "sout");
        _select = button_pressed(index, "pick");
    }
    
    // No projectiles
    with(projectile) instance_delete(id);
    
    // Spin box
    global.box_spin_rad += (global.state == states.enemy_attacking) ? 0.12 : -0.2;
    if(global.box_spin_rad > pi/2) global.box_spin_rad = pi/2;
    else if(global.box_spin_rad < 0) global.box_spin_rad = 0;
    
    // Enemy attacking
    if(global.state == states.enemy_attacking)
    {
        
        // Timer
        if(global.attack_alarm >= 1) global.attack_alarm--;
        // Back to player action selection
        else goto_player_selecting();
        
        // Player movement
        var _spd = 1.3;
        global.px = clamp(global.px + _spd*(_right - _left), BATTLEBOX_LEFT, BATTLEBOX_RIGHT);
        global.py = clamp(global.py + _spd*(_down - _up), BATTLEBOX_TOP, BATTLEBOX_BOTTOM);
        
        // Graze animation
        global.graze_rad += 0.1375;
        if(global.graze_rad > pi/2) global.graze_rad = pi/2;
        if(global.graze_rad == pi/2) global.graze_avail = true;
        
        // Bullet movement
        with(CustomObject) if("is_rpg_bullet" in id)
        {
            // Move
            bx += dcos(dir)*spd;
            by += dsin(-dir)*spd;
            spd += spdinc;
            // Alpha
            image_alpha = clamp(image_alpha + alphainc, 0, 1);
            // Can be destroyed
            if(dont_destroy) dont_destroy = !point_on_battle_box(bx, by);
            // Player collision
            if(meeting_heart(bx, by))
            {
                player_hurt();
                instance_destroy();
            }
            // Not colliding
            else
            {
                // Graze
                if(global.graze_avail && point_distance(bx, by, global.px, global.py) <= PLAYER_GRAZE_DIST)
                    grazed();
                
                // Wall collision
                if(!dont_destroy && !point_on_battle_box(bx, by))
                    instance_destroy();
            }
        }

        // Spawn bullets
        if(global.box_spin_rad == pi/2) with(CustomObject) if("is_rpg_enemy" in id) if(!dead)
        {
            if(bullet_cd >= 1) bullet_cd--;
            else with(instance_create(0, 0, CustomObject))
            {
                is_rpg_bullet = true;
                spd = 0;
                dir = 0;
                image_alpha = 1;
                alphainc = 0;
                spdinc = 0;
                dont_destroy = true;
                other.bullet_cd = 30;
                
                // Type-specific
                type = other.bullet_type;
                switch(type)
                {
                    // Diamond cutter
                    case bullet_types.diamond_cutter:
                        other.bullet_cd = 15;
                        sprite_index = global.sprDiamondCutter;
                        image_alpha = 0;
                        alphainc = 0.025;
                        spd = 0;
                        spdinc = 0.075;
                        dir = 90;
                        bx = BATTLEBOX_X + random_range(-BATTLEBOX_WIDTH, BATTLEBOX_WIDTH)/2;
                        by = BATTLEBOX_Y + BATTLEBOX_HEIGHT/2 + 10;
                        break;
                    // Friendliness pellet
                    case bullet_types.friendliness_pellet:
                        other.bullet_cd = 30 + random_range(-10, 10);
                        dir = random(360);
                        spd = 2;
                        bx = BATTLEBOX_X - BATTLEBOX_WIDTH*dcos(dir);
                        by = BATTLEBOX_Y - BATTLEBOX_HEIGHT*dsin(-dir);
                        break;
                    // Other
                    default: break;
                }
            }
        }
    }
    
    // Attacking
    else if(global.state == states.player_attacking)
    {
        
        // Bar animations
        for(var i = 0; i < ds_list_size(global.attack_bar_anims); i++)
        {
            var _rad = global.attack_bar_anims[|i][2] + 0.4;
            if(_rad >= pi/2) ds_list_delete(global.attack_bar_anims, i);
            else global.attack_bar_anims[|i] = [global.attack_bar_anims[|i][0], global.attack_bar_anims[|i][1], _rad, global.attack_bar_anims[|i][3]];
        }
        
        // Bars move
        var _done = true;
        var i = 0;
        for(var k = 0; k < 3; k++) if(global.char_actions[k] == actions.attack)
        {
            // Move bar
            global.attack_bars[|i] -= ATTACK_BAR_SPEED;
            // If bar is at / almost at goal
            if(global.attack_bars[|i] >= ATTACK_RECT_LEFT - ATTACK_GRACE_DIST)
            {
                // Not done attacking
                _done = false;
                
                // Pressed
                if(_select && global.attack_bars[|i] <= ATTACK_RECT_LEFT + ATTACK_RECT_WIDTH)
                {
                    // Timed
                    var _yellow = (global.attack_bars[|i] >= ATTACK_RECT_LEFT - ATTACK_GRACE_YELLOW_DIST && global.attack_bars[|i] <= ATTACK_RECT_LEFT + ATTACK_GOAL_WIDTH + ATTACK_GRACE_YELLOW_DIST);
                    if(global.attack_bars[|i] <= ATTACK_RECT_LEFT + ATTACK_GOAL_WIDTH + ATTACK_GRACE_DIST)
                    {
                        sound_play(global.sndHit);
                        hit_enemy(k, 1 + _yellow, true);
                    }
                    // Animation
                    ds_list_add(global.attack_bar_anims, [global.attack_bars[|i], i, 0, _yellow]);
                    // Make invisible
                    global.attack_bars[|i] = -100;
                }
            }
            
            i++;
        }
        
        // Done
        if(_done)
        {
            if(global.acted == undefined) goto_enemy_attacking();
            else goto_perform_act();
        }
    }
    
    // Player choose act
    else if(global.state == states.act)
    {
        // Move highlighted in menu
        if(_right_pressed ^^ _left_pressed ^^ _down_pressed ^^ _up_pressed)
        {
            // Move highlighted in menu
            var _act = global.act_selected;
            global.act_selected += _right_pressed - _left_pressed;
            if(global.act_selected < 0)
                global.act_selected = ds_list_size(global.act_options)-1;
            else if(global.act_selected > ds_list_size(global.act_options)-1)
                global.act_selected = 0;
            else if(global.act_selected >= 2)
                global.act_selected -= 2*_up_pressed;
            else if(global.act_selected <= ds_list_size(global.act_options)-1 - 2)
                global.act_selected += 2*_down_pressed;
            
            // Sound
            if(_act != global.act_selected) sound_play(global.sndMenuMove);
        }
        
        // Confirm
        if(_select)
        {
            // Sound
            sound_play(global.sndMenuSelect);
            
            // Save act
            global.acted = global.act_options[|global.act_selected];
            goto_next_character_selected();
        }
    }
    
    // Player is acting
    else if(global.state == states.acting)
    {
        if(global.info_box_char_index == string_length(global.info_box_text))
        {
            if(global.acting_continue_alarm >= 1) global.acting_continue_alarm--;
            else goto_enemy_attacking();
        }
    }
    
    // Player turn
    else if(global.state == states.selecting)
    {
        // Move highlighted in menu
        if(_right_pressed ^^ _left_pressed)
        {
            // Sound
            sound_play(global.sndMenuMove);
            
            // Move highlighted in menu
            global.button_selected += _right_pressed - _left_pressed;
            var _max = sprite_get_number(global.sprMenuHighlightMagic)-1;
            if(global.turn == 0) _max = sprite_get_number(global.sprMenuHighlightAct)-1;
            if(global.button_selected > _max)
                global.button_selected = 0;
            else if(global.button_selected < 0)
                global.button_selected = _max;
        }
        
        // Select in menu
        if(_select)
        {
            // Sound
            sound_play(global.sndMenuSelect);
            
            var _next_select = false;
            // Fight
            if(global.button_selected == 0)
            {
                _next_select = true;
                global.char_actions[global.turn] = actions.attack;
            }
            // Act
            else if(global.button_selected == 1 && global.turn == 0)
            {
                global.char_actions[global.turn] = actions.act;
                goto_act();
            }
            // Defend
            else if(global.button_selected == 2 && global.turn == 0 ||
            global.button_selected == 1 && global.turn != 0)
            {
                _next_select = true;
                global.char_actions[global.turn] = actions.defend;
            }
            
            // Next turn
            if(_next_select) goto_next_character_selected();
        }
    }
}

#define point_in_view(_x, _y)

// Returns if point is within player view
return (_x >= view_xview[0] && _x <= view_xview[0] + game_width && _y >= view_yview[0] && _y <= view_yview[0] + game_height);

#define goto_player_attacking()

// Start player attacking
global.turn = 0;
global.state = states.player_attacking;
// Attack bar positions
ds_list_clear(global.attack_bars);
ds_list_clear(global.attack_bar_anims);
for(var i = 0; i < characters_attacking(); i++)
    ds_list_add(global.attack_bars, game_width*0.66 + (ATTACK_RECT_WIDTH+ATTACK_GRACE_DIST+1)*irandom(2));

#define goto_enemy_attacking()

// If enemies alive
if(enemies_alive() >= 1)
{
    // Start enemy attacking
    with(CustomObject) if("is_rpg_enemy" in id) bullet_cd = 0;
    ds_list_clear(global.attack_bars);
    global.px = BATTLEBOX_X;
    global.py = BATTLEBOX_Y;
    global.state = states.enemy_attacking;
    global.button_selected = 0;
    global.rpg_battlebox_enabled = true;
    global.attack_alarm = global.attack_alarm_max;
    global.bullet_spawn_alarm_max = max(room_speed*1.25 - 6*enemies_alive(), room_speed/5);
    global.bullet_spawn_alarm = global.bullet_spawn_alarm_max;
}

#define goto_player_selecting()

// Start player selecting
with(CustomObject) if("is_rpg_bullet" in id) instance_destroy();
global.turn = 0;
global.rpg_battlebox_enabled = false;
global.state = states.selecting;
global.graze_rad = pi/2;
global.char_actions = [actions.nothing, actions.nothing, actions.nothing];
global.acted = undefined;
global.px = game_width/2;
global.py = game_height/2;

#define goto_next_character_selected()

// Goes to next character selection
global.state = states.selecting;
global.turn += 1;
global.button_selected = 0;
// Done choosing
if(global.turn == 3)
{
    // At least one person is attacking
    if(characters_attacking > 0) goto_player_attacking();
    // Acted
    else if(global.acted != undefined) goto_perform_act();
    // No one's attacking or acting
    else goto_enemy_attacking();
}

#define goto_act()

// Start act menu
global.act_selected = 0;
global.state = states.act;

#define goto_perform_act()

// Performs selected act
goto_enemy_attacking();
if(global.acted != undefined)
{
    global.state = states.acting;
    global.acting_continue_alarm = ACTING_CONTINUE_ALARM;
    script_execute(global.acted.on_act);
}

#define act_flirt()

// Flirt
var _text = "* You tried to flirt.#  No one seems interested.";
with(CustomObject) if("is_rpg_enemy" in id) if(!dead)
{
    switch(flirts_left)
    {
        case 2:
        case 1:
            var _options = [];
            _options[0] = "* You told the enemy they're#  leaking radiation.#* They seemed flattered?";
            _options[1] = "* You told the enemy you're#  glad to meet them.#* They might've blushed?";
            _options[2] = "* You smiled at the enemy.#* They tried to smile back.";
            _options[3] = "* You tried to dance.#* The enemy wasn't much better.";
            _options[4] = "* You whistled at the enemy.# The enemy didn't understand.";
            _text = _options[irandom(array_length_1d(_options)-1)]
            break;
        case 0:
            _text = "* You told the enemy to#  stop attacking.#* They ran away.";
            hit_enemy(id, 9999999, false);
            break;
    }
    flirts_left -= 1;
    break;
}
info_box_say(_text);

#define act_talk()

// Talk
var _text = "* You tried to talk.#* No one seemed interested.";
var _max_mhp_to_talk = 3;
with(CustomObject) if("is_rpg_enemy" in id) if(!dead && mhp <= _max_mhp_to_talk)
{
    switch(talks_left)
    {
        case 1:
            var _texts;
            _texts[0] = "* You told the enemies that hurting#  people is mean.";
            _texts[1] = "* You told the enemies to stop#  fighting.";
            _texts[2] = "* You told the enemies that violence#  is not the answer.";
            _texts[3] = "* You told the enemies you don't#  want to fight.";
            _texts[4] = "* You told the enemies it's not#  fair, it's not right.";
            _text = _texts[irandom(array_length_1d(_texts)-1)];
            break;
        case 0:
            var _texts;
            _texts[0] = "* The enemies realized there's#  no reason to fight.";
            _texts[1] = "* The enemies were utterly swayed.";
            _texts[2] = "* The enemies stopped being#  your enemy.";
            _texts[3] = "* The enemies decided to stop#  fighting.";
            _text = _texts[irandom(array_length_1d(_texts)-1)];
            with(CustomObject) if("is_rpg_enemy" in id) if(!dead && mhp <= _max_mhp_to_talk)
                hit_enemy(id, 9999999, false);
            break;
    }
    talks_left -= 1;
    break;
}
info_box_say(_text);
