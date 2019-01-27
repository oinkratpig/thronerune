
#define init

// Sprite replacements
sprite_replace(sprSpiral, "sprNothing.png", 1, 0, 0);
sprite_replace(sprPortalIndicator, "sprNothing.png", 1, 0, 0);
sprite_replace(sprBigName, "sprNothing.png", 1, 0, 0);
sprite_replace(sprBigNameFont, "sprNothing.png", 1, 0, 0);
sprite_replace(sprPortal, "sprPortal.png", 4, 16, 16);
sprite_replace(sprPortalDisappear, "sprPortalDisappear.png", 9, 16, 16);
sprite_replace(sprPortalSpawn, "sprNothing.png", 1, 0, 0);
sprite_replace(sprPortalL1, "sprNothing.png", 1, 0, 0);
sprite_replace(sprPortalL2, "sprNothing.png", 1, 0, 0);
sprite_replace(sprPortalL3, "sprNothing.png", 1, 0, 0);
sprite_replace(sprPortalL4, "sprNothing.png", 1, 0, 0);
sprite_replace(sprPortalL5, "sprNothing.png", 1, 0, 0);

// Replace sounds
//sound_replace(sndPortalOpen, "sndNothing.ogg");

// Config
global.intro = false;

#define step

// HUD
with(Player) if(race == "thronerune-kris-normal")
    player_set_show_hud(0, 0, false);
else player_set_show_hud(0, 0, true);

#define next_area()

// Go to next area
with(Player)
    with(instance_create(x, y, Portal))
    {
        timer = 0;
        endgame = 0;
    }

#define x_to_gui(_x)

// Get gui x position from room position
return _x - view_xview[0];

#define y_to_gui(_y)

// Get gui y position from room position
return _y - view_yview[0];
