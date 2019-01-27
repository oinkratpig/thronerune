
// Sprites
global.sprNothing = sprite_add("sprNothing.png", 1, 0, 0);
global.sprTextBox = sprite_add("sprTextBox.png", 1, 0, 0);
global.sprFaces = [
    /*  0 */ global.sprNothing,
    /*  1 */ sprite_add("sprToriel.png", 20, 0, 0)
    ];

// Sounds
global.sndVoices = [
    /*  0 */ sound_add("sndText.ogg"),
    /*  1 */ sound_add("sndToriel.ogg")
    ];

#macro MARG_BOTTOM 5
#macro STROKE_SIZE 3
#macro TEXT_MARGIN_TOP 15
#macro TEXT_MARGIN 3
#macro TEXT_XSCALE 0.925

#macro WIDTH sprite_get_width(global.sprTextBox)
#macro HEIGHT sprite_get_height(global.sprTextBox)

#macro X (game_width/2)
#macro Y (game_height - HEIGHT/2 - MARG_BOTTOM)

#macro LEFT (X - WIDTH/2)
#macro RIGHT (X + WIDTH/2)
#macro TOP (Y - HEIGHT/2)
#macro BOTTOM (Y + HEIGHT/2)

#macro TEXT_SPEED 0.75

global.enabled = false;
global.face = undefined;
#macro FACE_WIDTH (sprite_get_width(global.sprFaces[global.face]))
global.char_index = 1;
global.text_index = 0;
global.voice = undefined;
global.text = [];
global.paused = 0;
global.next_char_alarm = 0;
global.emote_index = 0;
#macro MOUTH_ALARM 3
global.mouth_alarm = 0;
global.mouth_open = false;

#define step
if(!instance_exists(Player)) global.enabled = false;
if(global.enabled) box_step();
#define draw_gui
if(global.enabled) box_draw();

#define textbox_say(_msgs, _face_ind, _voice_ind)

// Say messages in text box
global.enabled = true;
global.text = _msgs;
global.char_index = 1;
global.text_index = 0;
global.emote_index = 0;
global.face = _face_ind;
global.voice = _voice_ind;
global.paused = 0;
global.next_char_alarm = 0;

#define get_array_from_text()

// Converts text to array from newlines
var _ind = 0;
var _arr = [];
var _str = "";
for(var i = 1; i <= string_length(global.text[global.text_index]); i++)
{
    var _char = string_char_at(global.text[global.text_index], i);
    // Newline
    if(_char == "#")
    {
        _arr[_ind++] = _str;
        _str = "";
    }
    // Not
    else _str += _char;
}
// Add final string
_arr[_ind] = _str;
// Return
return _arr;

#define box_step

// Turn text to array
var _text = string_replace_all(global.text[global.text_index], "#", "");
var _text_len = string_length(_text);

// Get emote
if(string_char_at(_text, 0) == "<")
{
    // Raw format tag
    var _format = "";
    for(var i = 1; i <= string_length(_text); i++)
    {
        var _char = string_char_at(_text, i);
        _format += _char;
        if(_char == ">") break;
    }
    // Get index of emote
    var _emote = "";
    var _hit_emote = false;
    for(var i = 1; i <= string_length(_format); i++)
    {
        var _char = string_char_at(_text, i);
        if(_char == ":") _hit_emote = true;
        else if(_hit_emote)
        {
            if(_char == ">") break;
            else _emote += _char;
        }
    }
    // Set emote index
    global.emote_index = real(_emote);
}

// Scroll text
if(global.paused >= 1) global.paused--;
else if(global.next_char_alarm >= 1) global.next_char_alarm--;
else if(global.char_index < _text_len)
{
    global.next_char_alarm += TEXT_SPEED;
    // Scroll
    var _char = string_char_at(_text, global.char_index);
    var _bracketed = false;
    do
    {
        // Bracketed formatting
        if(_char == "<") _bracketed = true;
        else if(_char == ">") _bracketed = false;
        // Scroll text
        global.char_index += 1;
        _char = string_char_at(_text, global.char_index);
    }   until(_char != " " && !_bracketed);
    // Pause
    if(_char == "&")
        global.paused += 10;
    // Normal character
    else
        sound_play(global.sndVoices[global.voice]);
}

// Move mouth
if(global.char_index < _text_len && global.paused < 1)
{
    if(global.mouth_alarm >= 1) global.mouth_alarm--;
    else
    {
        global.mouth_alarm = MOUTH_ALARM;
        global.mouth_open = !global.mouth_open;
    }
}
else global.mouth_open = false;

// Confirm
var _confirm = button_pressed(0, "pick") || button_pressed(0, "fire") || button_pressed(0, "spec");
if(_confirm)
{
    // Skip text
    if(global.char_index < _text_len)
        global.char_index = _text_len;
    // Continue
    else
    {
        if(global.text_index < array_length_1d(global.text)-1)
        {
            global.char_index = 1;
            global.text_index += 1;
        }
        else global.enabled = false;
    }
}

#define box_draw

// Draw text box
draw_sprite(global.sprTextBox, 0, LEFT, TOP);
draw_sprite(global.sprFaces[global.face], global.emote_index + global.mouth_open, LEFT, TOP);

// Draw text
draw_set_font(fntM);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var _x = LEFT + max(FACE_WIDTH - 10, TEXT_MARGIN_TOP);
var _y = TOP + STROKE_SIZE + TEXT_MARGIN_TOP;
var _char_index = global.char_index;
var _text = get_array_from_text();
// Draw strings
var _bracketed = false;
for(var i = 0; i < array_length_1d(_text); i++)
{
    // String to draw
    var _str = string_copy(_text[i], 1, _char_index);
    // Draw each character individually
    var __x = _x;
    for(var c = 1; c <= string_length(_str); c++)
    {
        var _char = string_char_at(_str, c);
        
        if(_char == "<") _bracketed = true;
        else if(_char == ">")
        {
            _bracketed = false;
            continue;
        }
        
        if(!_bracketed && _char != "&" && _char != "%")
        {
            if(_char == " ") draw_set_color(c_white);
            draw_text_transformed(__x, _y, _char, TEXT_XSCALE, 1, 0);
            __x += string_width(_char)*TEXT_XSCALE;
        }
        else if(_char == "%")
            draw_set_color(c_yellow);
    }
    // Next strings are further down
    _y += string_height(_text[i]) + TEXT_MARGIN;
    // Fix char index of next strings
    _char_index -= string_length(_str);
}
