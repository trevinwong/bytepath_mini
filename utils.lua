-- Misc
function UUID()
    local fn = function(x)
        local r = love.math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function random(min, max)
    local min, max = min or 0, max or 1
    return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end


-- Memory leak checking

function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
            f(t)
	    seen[t] = true
	    for k,v in pairs(t) do
	        if type(v) == "table" then
		    count_table(v)
	        elseif type(v) == "userdata" then
		    f(v)
	        end
	end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function (o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
            for k,v in pairs(_G) do
	        global_type_table[v] = k
	    end
	global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end

-- Graphics transformations

function pushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x, -y)
end

function pushRotateScale(x, y, r, sx, sy)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or sx or 1)
    love.graphics.translate(-x, -y)
end

-- Gameplay

function slow(amount, duration)
    slow_amount = amount
    timer:tween('slow', duration, _G, {slow_amount = 1}, 'in-out-cubic')
end

--[[
    Exercise 91:
        I think seconds are better. The problem with frames is that it's frame-rate dependent which means your effects are going to have unpredictable results.
        If you have a very fast machine, your effect could last very little, while if you have a very slow machine, your effect could last for a very long time.
        
        For seconds, if you have a very fast machine, your effect is still going to last the same amount of time you intend it to last for, say, 0.5 seconds.
        The only situation that isn't that good is having a very slow machine - your effect will last a much shorter time than you expect since the dt will likely
        be massive. But by then the user is probably expecting a big shift in the simulation of your state anyways, so I don't think it's that unexpected to see
        everything zoom by.
        
        Plus, seconds are more intuitive to use.
]]--
function flash(seconds)
    flash_seconds = seconds
end