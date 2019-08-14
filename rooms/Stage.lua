Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('Enemy', {ignores = {'Enemy', 'Collectable'}})
    self.area.world:addCollisionClass('EnemyProjectile', 
    {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})

    self.timer = Timer()
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    camera.smoother = Camera.smooth.damped(5)
    
    self.director = self.area:addGameObject('Director', 0, 0, {player = self.player})
    self.score = 0
    self.font = fonts.m5x7_16
    
    input:bind('p', function() 
        self.area:addGameObject('Ammo', random(0, gw), random(0, gh)) 
    end)
    input:bind('o', function() 
        self.area:addGameObject('Boost') 
    end)
    input:bind('i', function() 
        self.area:addGameObject('HP') 
    end)
    input:bind('u', function() 
        self.area:addGameObject('SP') 
    end)
    input:bind('y', function() 
        self.area:addGameObject('Attack', 0, 0, {attack = "Triple"})
    end)
    input:bind('t', function()
        self.area:addGameObject('Rock')    
    end)
    input:bind('r', function()
        self.area:addGameObject('Shooter')
    end)
    input:bind('e', function()
        self.score = self.score * 10
    end)
    input:bind('q', function()
        self.area:addGameObject('Explosion', self.player.x, self.player.y)
    end)
end

function Stage:update(dt)
    self.director:update(dt)
    camera:lockPosition(dt, gw/2, gh/2)
    self.timer:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
      self.area:draw()
    camera:detach()
    
    -- HP
    local r, g, b = unpack(hp_color)
    local hp, max_hp = self.player.hp, self.player.max_hp
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2 - 52, gh - 16, 48*(hp/max_hp), 4)
    love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
    love.graphics.rectangle('line', gw/2 - 52, gh - 16, 48, 4)
    
    love.graphics.print('HP', gw/2 - 52 + 24, gh - 24, 0, 1, 1,
    math.floor(self.font:getWidth('HP')/2), math.floor(self.font:getHeight()/2))
    
    love.graphics.print(hp .. '/' .. max_hp, gw/2 - 52 + 24, gh - 6, 0, 1, 1,
    math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2), math.floor(self.font:getHeight()/2))

    -- Ammo
    local r, g, b = unpack(ammo_color)
    local ammo, max_ammo = self.player.ammo, self.player.max_ammo
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2 - 52, 16, 48*(ammo/max_ammo), 4)
    love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
    love.graphics.rectangle('line', gw/2 - 52, 16, 48, 4)
    
    love.graphics.print('AMMO', gw/2 - 52 + 24, 8, 0, 1, 1,
    math.floor(self.font:getWidth('AMMO')/2), math.floor(self.font:getHeight()/2))
    
    love.graphics.print(ammo .. '/' .. max_ammo, gw/2 - 52 + 24, 26, 0, 1, 1,
    math.floor(self.font:getWidth(ammo .. '/' .. max_ammo)/2), math.floor(self.font:getHeight()/2))
    
    -- Boost
    local r, g, b = unpack(boost_color)
    local boost, max_boost = self.player.boost, self.player.max_boost
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2 + 4, 16, 48*(boost/max_boost), 4)
    love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
    love.graphics.rectangle('line', gw/2 + 4, 16, 48, 4)
    
    love.graphics.print('BOOST', gw/2 + 4 + 24, 8, 0, 1, 1,
    math.floor(self.font:getWidth('BOOST')/2), math.floor(self.font:getHeight()/2))
    
    love.graphics.print(math.floor(boost) .. '/' .. max_boost, gw/2 + 4 + 24, 26, 0, 1, 1,
    math.floor(self.font:getWidth(math.floor(boost) .. '/' .. max_boost)/2), math.floor(self.font:getHeight()/2))

    -- Cycle
    local r, g, b = unpack(default_color)
    local cycle_timer, cycle_cooldown = self.player.cycle_timer, self.player.cycle_cooldown
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2 + 4, gh - 16, 48*(cycle_timer/cycle_cooldown), 4)
    love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
    love.graphics.rectangle('line', gw/2 + 4, gh - 16, 48, 4)
    
    love.graphics.print('CYCLE', gw/2 + 4 + 24, gh - 24, 0, 1, 1,
    math.floor(self.font:getWidth('CYCLE')/2), math.floor(self.font:getHeight()/2))
    
    -- Score
    love.graphics.setColor(default_color)
    love.graphics.print(self.score, gw - 40, 10, 0, 1, 1,
    math.floor(self.font:getWidth(self.score)/1.5), self.font:getHeight()/2)
    love.graphics.setColor(255, 255, 255)
    
    -- SP
    love.graphics.setColor(skill_point_color)
    love.graphics.print(sp .. "SP", 20, 10, 0, 1, 1,
    0, self.font:getHeight()/2)
    love.graphics.setColor(255, 255, 255)
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')

    love.graphics.setFont(self.font)


end

function Stage:finish()
    timer:after(1, function()
        gotoRoom('Stage')
    end)
end

function Stage:destroy()
  self.area:destroy()
  self.player = nil
  self.area = nil
end