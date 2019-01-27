
global.spr = sprite_add_weapon("sprSword.png", 3, 6);

#define weapon_name
return "SWORD";

#define weapon_type
return 0;

#define weapon_auto
return 0;

#define weapon_cost
return 0;

#define weapon_load
return 20;

#define weapon_sprt
return global.spr;

return sword_sprite;

#define weapon_area
return -1;

#define weapon_swap
return sndSwapHammer;

#define weapon_text
return "resorting to violence";

#define weapon_fire

sound_play(sndHammer);
instance_create(x, y, Dust);
var _dist = 13 + skill_get(13)*4;

with(instance_create(x + dcos(gunangle)*_dist, y + dsin(-gunangle)*_dist, Slash))
{
    damage = 10;
    motion_add(other.gunangle, 2 + 2*skill_get(13));
    image_angle = direction;
    team = other.team;
    creator = other;
}

wepangle = -wepangle;
motion_add(gunangle, 6);
weapon_post(-5, 10, 3);

