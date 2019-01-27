#define chat_message
with(Player) if(race == "thronerune-kris-normal")
    if(GameCont.area == "thronerune-intro0" && !mod_variable_get("mod", "thronerune-textboxes", "enabled"))
    {
        var _msgs = [], _pos = 0;
        var _index = 1;
        var _str = "* ";
        var _current_char = 0;
        while(_index <= string_length(argument[0]))
        {
            var _char = string_char_at(argument[0], _index);
            _str += _char;
            _index += 1;
            _current_char += 1;
            
            if(_current_char > 25 && _char == " ")
            {
                _current_char = 0;
                _str += "#  ";
            }
        }
        _msgs[_pos] = _str;
        interact_cd = 5;
        mod_script_call("mod", "thronerune-textboxes", "textbox_say", _msgs, 0, 0);
    }