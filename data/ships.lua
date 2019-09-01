Ships = {}

--[[
    Exercises 216-223:
        As I created my own ships, I also created my own stats for them, which also come with a little blurb about how I decided on them.
        Personally, I think the Rocket might be a bit overtuned, but it's my personal favorite, so...
]]--

Ships["Fighter"] = {}
Ships["Fighter"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, 0, -- 1
        w/2, -w/2, -- 2
        -w/2, -w/2, -- 3
        -w, 0, -- 4
        -w/2, w/2, -- 5
        w/2, w/2, -- 6
    }
    polygons[2] =  {
        w/2, -w/2, -- 7
        0, -w, -- 8
        -w - w/2, -w, -- 9
        -3*w/4, -w/4, -- 10
        -w/2, -w/2, -- 11
    }
    polygons[3] = {
        w/2, w/2, -- 12
        -w/2, w/2, -- 13
        -3*w/4, w/4, -- 14
        -w - w/2, w, -- 15
        0, w, -- 16
    }
    return polygons
end
Ships["Fighter"]["modifyPlayerStats"] = function(player)
    
end
Ships["Fighter"]["getDescription"] = function(player)
   return {"+ No strengths", "- No weaknesses"}
end

Ships["Brick"] = {}
Ships["Brick"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, -w/2, -- 1
        w, w/2, -- 2
        -w, w/2, -- 3
        -w, -w/2, -- 4
    }
    return polygons
end
--[[
    Bricks aren't very fast, but they are pretty sturdy. Plus, as a well-known staple in building houses, fellow resources will come to it's aid more often.
    
    This ship prioritizes staying alive so it can collect more resources so it can stay alive longer. Look towards passives that depend on collecting resources and boosting health!
]]--
Ships["Brick"]["modifyPlayerStats"] = function(player)
    player.max_boost = 80
    player.movement_speed_multiplier = 0.6
    player.turn_rate_multiplier = 0.6
    player.max_hp = 130
    player.resource_spawn_rate_multiplier = 1.5
    player.size_multiplier = 1.5
end
Ships["Brick"]["getDescription"] = function(player)
   return {"+ High health", "+ Spawns resources faster", "- Larger than usual", "- Not very agile"}
end

--[[
    Rockets are incredibly fast, but well known for only being able to fly in one direction. They're also well known for being weapons of mass destruction, so their
    attack power is similarly incredible!
    
    This ship is fast. Too fast for it's own good. Prioritize boost passives that will allow you to slow it down before it goes rocketing off into space! If you can control it,
    it is incredibly powerful offense wise.
]]--

Ships["Rocket"] = {}
Ships["Rocket"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, 0, -- 1
        w/2, w/2, -- 2
        -w/2, w/2, -- 3
        -w/0.65, w, -- 4
        -w, w/2, -- 5
        -w, -w/2, -- 6
        -w/0.65, -w, -- 7
        -w/2, -w/2, -- 8
        w/2, -w/2, -- 9
    }
    return polygons
end
Ships["Rocket"]["modifyPlayerStats"] = function(player)
    player.boost_effectiveness_multiplier = 2
    player.mvspd_multiplier = Stat(2)
    player.turn_rate_multiplier = 0.5
    player.pspd_multiplier = Stat(2)
    player.aspd_multiplier = Stat(2)
end
Ships["Rocket"]["getDescription"] = function(player)
   return {"+ Very fast", "+ Shoots very fast", "- Too fast for it's own good", "- Doesn't turn very well"}
end

--[[
    This ship invokes the image of a stealthy spy sneaking through the night and assassinating political figureheads. As such, it is quite mobile, but also like spys, also
    quite fragile once caught.
    
    This ship rewards skilled players who can dodge, duck and weave with it's high movmement capabilities. However, it is quite fragile.
]]--

Ships["Night"] = {}
Ships["Night"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, 0, -- 1
        -w/2, w, -- 2
        -w, w/1.5, -- 3
        -w/2, w/2, -- 4
        -w, 0, -- 5
        -w/2, -w/2, -- 6
        -w, -w/1.5, -- 7
        -w/2, -w --8
    }
    return polygons
end
Ships["Night"]["modifyPlayerStats"] = function(player)
    player.mvspd_multiplier = Stat(1.3)
    player.boost_recharge_rate = 1.5
    player.max_boost = 120
    player.turn_rate_multiplier = 0.85
    player.max_hp = 80
    player.size_multiplier = 0.9
    player.invulnerability_time_multiplier = 0.8
end
Ships["Night"]["getDescription"] = function(player)
   return {"+ Very agile", "+ Smaller than usual", "+ High boost", "- Low health", "- Less invincibility time"}
end

--[[
    Crystals are associated with a lot of superstition due to their out of this world beauty. With so many people believing in it, how can supernatural events not occur around it?
    Sadly, they're fragile and expensive.
    
    This ship prioritizes luck-based events, but has weak stats. Prioritize passives that depend on chance!
]]--

Ships["Crystal"] = {}
Ships["Crystal"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, 0, -- 1
        w/2, w/2, -- 2
        -w/2, w/2, -- 3
        -w, 0, -- 4
        -w/2, -w/2, -- 5
        w/2, -w/2 -- 6
    }
    return polygons
end
Ships["Crystal"]["modifyPlayerStats"] = function(player)
    player.luck_multiplier = Stat(1.5)
    player.max_hp = 80
    player.max_boost = 90
    player.projectile_size_multiplier = 0.9
    player.invulnerability_time_multiplier = 0.6
    player.ammo_consumption_multiplier = 1.3
end
Ships["Crystal"]["getDescription"] = function(player)
   return {"+ High luck", "- Low health and boost", "- Less invincibility time", "- Shots are smaller and consume more ammo"}
end

--[[
    This ship looks like a big robo with it's robo-like arms. Not much else to say here. As such, it comes with the latest technology, like an energy shield.
    You can also bet that it stores a lot of ammo. Sadly, science doesn't believe in luck, so no lucky events for you!
    
    It comes with an energy shield, and plenty of ammo to spare, but worse chance to proc luck-based passives.
    Prioritize passives that don't depend on luck.
]]--

Ships["Robo"] = {}
Ships["Robo"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w/2, -w/2, -- 1
        w/2, w/2, -- 2
        -w, w/2, -- 3
        -w, -w/2, -- 4
    }
    polygons[2] = {
        w, -w, -- 5
        w, -w/1.5, -- 6
        -w/2, -w/1.5, -- 7
        -w/2, -w/2, -- 8
        -w, -w/2, -- 9
        -w, -w -- 10
    }
    polygons[3] = {
        w, w, -- 11
        w, w/1.5, -- 12
        -w/2, w/1.5, -- 13
        -w/2, w/2, -- 14
        -w, w/2, -- 15
        -w, w -- 16
    }
    return polygons
end
Ships["Robo"]["modifyPlayerStats"] = function(player)
    player.energy_shield = true
    player.max_ammo = 130
    player.luck_multiplier = Stat(0.8)
end
Ships["Robo"]["getDescription"] = function(player)
   return {"Energy Shield: ", "    Takes 2x damage", "    Health regenerates", "    Halved invincibility time", "+ High ammo", "- Low luck"}
end


--[[
    Freedom is a word used by many to inspire masses of people. Imagine, crowds chanting, "Freedom, freedom, freedom!" In other words, this ship might have something to do with
    repetition and buffs... maybe. It's a stretch.
    
    This ship relies on buffing itself constantly with it's high cycle chance and high stat boost duration.
]]--

Ships["Freedom"] = {}
Ships["Freedom"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w/1.5, -w/2, -- 1
        w/1.5, w/2, -- 2
        w/3, w/2, -- 3
        w/3, w, -- 4
        -w/3, w, -- 5
        -w/3, w/2, -- 6
        -w, w/2, -- 7
        -w, -w/2, -- 8
        -w/3, -w/2, -- 9
        -w/3, -w, -- 10
        w/3, -w, -- 11
        w/3, -w/2 -- 12
    }
    return polygons
end
Ships["Freedom"]["modifyPlayerStats"] = function(player)
    player.cycle_speed_multiplier = Stat(1.5)
    player.stat_boost_duration_multiplier = 1.5
    player.boost_recharge_rate = 0.8
    player.aspd_multiplier = Stat(0.8)
    player.max_ammo = 90
end
Ships["Freedom"]["getDescription"] = function(player)
   return {"+ Faster cycle speed", "+ Buffs last longer", "- Boost recharges slower", "- Shoots slower", "- Low ammo"}
end

--[[
    It also looks like a fork, but who want to pilot a ship named that? The Stabbinator sounds much cooler. Of course, this sounds extremely violent, so this ship revolves around
    killing enemies!
]]--

Ships["Stabbinator"] = {}
Ships["Stabbinator"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        0, w, -- 1
        -w, w/3, -- 2
        0, 0, -- 3
        -w, -w/3, -- 4
        0, -w, -- 5
        w, 2*(-w/3),  -- 6
        w/2, -w/3,  -- 7
        w, 0,  -- 8
        w/2, w/3,  -- 9
        w, 2*(w/3),  -- 10
    }
    return polygons
end
Ships["Stabbinator"]["modifyPlayerStats"] = function(player)
    player.added_chance_to_all_on_kill_events = 10
    player.max_hp = 80
    player.max_boost= 80
    player.max_ammo = 80
    player.enemy_spawn_rate_multiplier = 1.2
    player.invulnerability_time_multiplier = 0.8
end
Ships["Stabbinator"]["getDescription"] = function(player)
   return {"+ 10% higher chance for On Kill effects to trigger", "- Low hp, boost and ammo", "- Enemies spawn faster", "- Less invincibility time"}
end