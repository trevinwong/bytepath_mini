require "objects/GameObject"
Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.s = opts.s or 2.5
    self.max_v = opts.max_v or 200
    self.v = opts.v or self.max_v
    self.color = attacks[self.attack].color
    self.damage = attacks[self.attack].damage or 100
    
    self:applyPspdMultiplier()
    self:applySizeMultiplier()
    
    if current_room.player.projectile_ninety_degree_change then
        self.timer:after(0.2 / current_room.player.angle_change_frequency_multiplier, function()
      	    self.ninety_degree_direction = table.random({-1, 1})
            self.r = self.r + self.ninety_degree_direction*math.pi/2
            self.timer:every('ninety_degree_first', 0.25 / current_room.player.angle_change_frequency_multiplier, function()
                self.r = self.r - self.ninety_degree_direction*math.pi/2
                self.timer:after('ninety_degree_second', 0.1 / current_room.player.angle_change_frequency_multiplier, function()
                    self.r = self.r - self.ninety_degree_direction*math.pi/2
                    self.ninety_degree_direction = -1*self.ninety_degree_direction
                end)
            end)
      	end)
    end
    
    if current_room.player.projectile_random_degree_change then
        self.timer:every(0.2 / current_room.player.angle_change_frequency_multiplier, function()
            self.r = self.r + random(-math.pi, math.pi)
      	end)
    end
    
    if current_room.player.wavy_projectiles then
        local direction = table.random({-1, 1}) * current_room.player.projectile_waviness_multiplier
        self.timer:tween(0.25, self, {r = self.r + direction*math.pi/8}, 'linear', function()
            self.timer:tween(0.25, self, {r = self.r - direction*math.pi/4}, 'linear')
        end)
        self.timer:every(0.75, function()
            self.timer:tween(0.25, self, {r = self.r + direction*math.pi/4}, 'linear',  function()
                self.timer:tween(0.5, self, {r = self.r - direction*math.pi/4}, 'linear')
            end)
        end)
    end

    if current_room.player.fast_slow then
        local initial_v = self.v
        self.timer:tween('fast_slow_first', 0.2/current_room.player.projectile_acceleration_multiplier, self, {v = 2*initial_v}, 'in-out-cubic', function()
            self.timer:tween('fast_slow_second', 0.3/current_room.player.projectile_deceleration_multiplier, self, {v = initial_v/2}, 'linear')
        end)
    end

    if current_room.player.slow_fast then
        local initial_v = self.v
        self.timer:tween('slow_fast_first', 0.2/current_rooom.player.projectile_deceleration_multiplier, self, {v = initial_v/2}, 'in-out-cubic', function()
            self.timer:tween('slow_fast_second', 0.3/current_room.player.projectile_acceleration_multiplier, self, {v = 2*initial_v}, 'linear')
        end)
    end

    
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setCollisionClass('Projectile')
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)
    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end
    
    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()
        if object then
            object:hit(self.damage)
            self:die()
            if object.hp <= 0 then current_room.player:onKill({object.x, object.y}) end
        end
        self:die()
    end
    
    if self.collider:enter('EnemyProjectile') then
        local collision_data = self.collider:getEnterCollisionData('EnemyProjectile')
        local object = collision_data.collider:getObject()
        if object then
            object:die()
            self:die()
        end
    end
    
    -- Homing
    if self.attack == 'Homing' then
        -- Acquire new target
        if not self.target then
            local targets = self.area:getAllGameObjectsThat(function(e)
                for _, enemy in ipairs(enemies) do
                    if e:is(_G[enemy]) and (distance(e.x, e.y, self.x, self.y) < 400) then
                        return true
                    end
                end
            end)
            self.target = table.remove(targets, love.math.random(1, #targets))
        end
        if self.target and self.target.dead then self.target = nil end

        -- Move towards target
        if self.target then
            local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
            local angle = math.atan2(self.target.y - self.y, self.target.x - self.x)
            local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
            local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
            self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
        end
        
        self.area:addGameObject('TrailParticle', self.x, self.y,
        {r = random(1, 3), d = random(0.15, 0.25), color = skill_point_color}) 
    else
        -- We can only set linear velocity once for some reason, so this case is for normal movement
        self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    end

end

function Projectile:draw()
    if self.attack == 'Homing' then
        pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angleTo()) 
        love.graphics.setColor(skill_point_color)
        draft:rhombus(self.x, self.y, 1*self.s, 1*self.s, 'fill')
        love.graphics.setColor(default_color)
        draft:rhombus(self.x, self.y, 0.5*self.s, 0.5*self.s, 'fill')
        love.graphics.pop()
        return
    end
    
    love.graphics.setColor(default_color)
    pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angleTo()) 
    love.graphics.setLineWidth(self.s - self.s/4)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - 2*self.s, self.y, self.x, self.y)
    love.graphics.setColor(default_color)
    love.graphics.line(self.x, self.y, self.x + 2*self.s, self.y)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end

function Projectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, 
    {color = hp_color, w = 3*self.s})
end

--[[
    The previous method of applying the Pspd stat on every tick worked for the "Pspd Boost" because we had a max velocity.
    However, this does not work for the "Pspd Inhibit", for reasons I should have seen coming, since it'll trend our velocity infinitely close to 0.
    Of course, the solution is to just apply Pspd once.
]]--
function Projectile:applyPspdMultiplier()
    if current_room and current_room.player then
        self.v = math.min(self.v, self.max_v) * current_room.player.pspd_multiplier.value
    end
end

function Projectile:applySizeMultiplier()
    if current_room and current_room.player then
        self.s = self.s * current_room.player.projectile_size_multiplier
    end
end