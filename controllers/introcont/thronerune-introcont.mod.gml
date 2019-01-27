
global.sndFadein = sound_add("sndFadein.ogg");
global.sndKnock = sound_add("sndKnock.ogg");

global.enabled = false;
global.fadein = false;

#macro FADEIN_TIME round(4.437*30)
global.fadein_time = 0;

#define time_to_frames(secs)

// Seconds to frames
return room_speed*secs;

#define textbox_say(_msgs, _face_ind, _voice_ind)

// Say something(s) in text box
mod_script_call("mod", "thronerune-textboxes", "textbox_say", _msgs, _face_ind, _voice_ind);

#define draw_gui

if(global.fadein)
{
    draw_clear(c_black);
    draw_set_alpha(global.fadein_time / FADEIN_TIME);
    draw_set_color(c_white);
    draw_rectangle(0, 0, game_width, game_height, false);
    draw_set_alpha(1);
}

#define step

// Fade-in
if(!instance_exists(Player))
{
    global.enabled = false;
    global.fadein = false;
}
else if(global.fadein)
{
    global.fadein_time += 1;
    if(global.fadein_time >= FADEIN_TIME)
    {
        audio_play_sound(global.sndKnock, 0, false);
        global.fadein = false;
    }
}

#define intro_create

with(instance_create(0, 0, CustomObject))
{
    global.enabled = true;
    global.fadein = true;
    global.fadein_time = 0;
    audio_play_sound(global.sndFadein, 0, false);
    alrm = 17;
    on_step = intro_step;
    with(Player) cutscene = true;
}

#define intro_step

// If not fading in
if(!global.fadein)
{
    // Wake up
    if(GameCont.area  == "thronerune-intro0")
    {
        // Speak
        if(alrm >= 1) alrm--;
        else if(alrm > -1)
        {
            alrm = -1;
            var _msgs = [
                "<emote:0>* Kris!& Wake up!#&* It's time for school!",
                "<emote:12>* ...",
                "<emote:4>* It's Sunday?#",
                "<emote:2>* Oh, &sorry!#&* Continue sleeping!"
                ]
            textbox_say(_msgs, 1, 1);
        }
    }
    
    // Done talking
    if(alrm < 0 && !mod_variable_get("mod", "thronerune-textboxes", "enabled"))
    {
        global.enabled = false;
        with(Player)
        {
            interact_cd = 10;
            cutscene = false;
        }
        textbox_say(["* You just remembered you can#  walk with %WASD and interact#  with the %mouse."], 0, 0);
        instance_destroy();
    }
}