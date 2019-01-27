
global.sprIdle = sprite_add("sprSusieIdle.png", 4, 12, 12);
global.sprWalk = sprite_add("sprSusieWalk.png", 6, 12, 12);
global.sprSmoke = sprite_add("sprSusieSmoke.png", 5, 12, 12);

#define susie_create(_x, _y)

// Create Susie
with(instance_create(_x, _y, CustomHitme))
{
    visible = true;
    creator = other;
    depth = creator.depth;
    image_speed = creator.image_speed;
    spr_idle = global.sprIdle;
    spr_walk = global.sprWalk;
    sprite_index = spr_idle;
    spr_shadow_y += 4;
    spr_shadow_x += 1;
    
    team = creator.team;
    maxspeed = 0;
    
    maxreload = 6
    reload = maxreload;
    hits_left = 6;
    
    on_step = susie_step;
    on_destroy = susie_destroy;
}

#define susie_destroy()

// poof
repeat(4)
    with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), Smoke))
        sprite_index = global.sprSmoke;

#define susie_step()

// Hit nearby enemies
if(reload >= 1) reload--;
else if(instance_exists(enemy))
{
    sound_play(sndHammer);
    instance_create(x, y, Dust);
    var _dist = 13;
    var _n = instance_nearest(x, y, enemy);
    var _angle = point_direction(x, y, _n.x, _n.y);
    with(instance_create(x + dcos(_angle)*_dist, y + dsin(-_angle)*_dist, Slash))
    {
        damage = 16;
        motion_set(_angle, 6);
        image_angle = direction;
        team = other.team;
        creator = other;
    }
    reload = maxreload;
    hits_left--;
    if(hits_left <= 0)
    {
        instance_destroy();
        exit;
    }
    motion_add(_angle, 3);
    // Flip sprite with enemy position
    image_xscale = abs(image_xscale);
    if(_angle >= 90 && _angle <= 270) image_xscale *= -1;
}
// No enemies exist
else
{
    instance_destroy();
    exit;
}

// Animations
if(speed > friction) sprite_index = spr_walk;
else sprite_index = spr_idle;
