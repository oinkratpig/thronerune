
#define init

// Globals
global.followers_active = false;
global.first_follower = noone;

// Sprites
global.sprSusieIdle = sprite_add("sprSusieIdle.png", 4, 12, 12);
global.sprRalseiIdle = sprite_add("sprRalseiIdle.png", 4, 12, 12);

#define toggle_follow()

// Toggle follow
with(global.first_follower)
{
    following = !following;
    if(!following)
    {
        with(instance_create(creator.x, creator.y, PopupText)) mytext = "Stay here.";
        goto_x = mouse_x[creator.index];
        goto_y = mouse_y[creator.index];
    }
    else
        with(instance_create(creator.x, creator.y, PopupText)) mytext = "Follow!";
}

#define followers_create()

// Create both followers
global.followers_active = true;
with(follower_create(id, 0))
{
    leader = true;
    global.first_follower = id;
    follower_create(id, 1);
}

#define follower_create(_creator, _follower_id)

// Create follower
var _inst;
with(_creator) with(instance_create(x, y, CustomHitme))
{
    _inst = id;
    is_ralsei = _follower_id == 1;
    leader = false;
    
    creator = _creator;
    friction = creator.friction;
    image_speed = creator.image_speed;
    spr_idle = (is_ralsei) ? global.sprRalseiIdle : global.sprSusieIdle;
    spr_walk = spr_idle;
    sprite_index = spr_idle;
    spr_shadow_y += 4;
    spr_shadow_x += 1;
    
    team = creator.team;
    maxhealth = 30;
    my_health = maxhealth;
    maxspeed = _creator.maxspeed*0.9;
    reload = 0;
    
    on_step = follower_step;
    
    // Leader only
    following = true;
    goto_x = 0;
    goto_y = 0;
}
return _inst;

#define step

// If first follower doesn't exist, none do
if(!instance_exists(global.first_follower))
{
    global.followers_active = false;
    global.first_follower = false;
}

#define follower_step

// Creator is nonexistent
if(!instance_exists(creator)) instance_destroy();
// Creator is alive
else
{
    // Follower walking
    if(leader && !following)
        mp_potential_step_object(goto_x, goto_y, maxspeed, Wall);
    else if(distance_to_object(creator) > 20)
        mp_potential_step_object(creator.x, creator.y, maxspeed, Wall);
    speed = 0;
    
    // Shooting
    image_xscale = (Player.right) ? 1 : -1;
    if(reload >= 1) reload--;
    // Enemies are alive
    if(instance_exists(enemy))
    {
        var _n = instance_nearest(x, y, enemy);
        var _dir = point_direction(x, y, _n.x, _n.y);
        var _old_xscale = image_xscale;
        image_xscale = (_n.x < x) ? -1 : 1;
        
        // Reload
        if(reload < 1)
        {
            // Susie axe
            if(!is_ralsei && distance_to_object(enemy) <= 85)
            {
                reload = 45;
                sound_play(sndHammer);
                instance_create(x, y, Dust);
                var _dist = 10 + skill_get(13)*4;
                with(instance_create(x + dcos(_dir)*_dist, y + dsin(-_dir)*_dist, Slash))
                {
                    damage = 10;
                    motion_add(_dir, 2 + 2*skill_get(13));
                    image_angle = direction;
                    team = other.team;
                    creator = other;
                }
            }
            /*
            // Ralsei fireballs
            else if(is_ralsei && distance_to_object(enemy) <= 200)
            {
                reload = 30;
                for(var i = -1; i <= 1; i++) with(instance_create(x, y, FireBall))
                {
                    team = other.team;
                    direction = _dir + 20*i;
                    damage = 10;
                    speed = 6;
                }
            }
            */
            // None
            else image_xscale = _old_xscale;
        }
    }
}



