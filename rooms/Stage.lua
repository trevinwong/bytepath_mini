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
    camera = Camera(gw/2, gh/2)
    camera.smoother = Camera.smooth.damped(5)
    self.old_sp = sp

    self.director = self.area:addGameObject('Director', 0, 0, {player = self.player})
    self.score = 0
    self.font = fonts.m5x7_16
    self.game_over_font = fonts.Squarewave_16

    local restart_button_w, restart_button_h  = self.game_over_font:getWidth("restart") * 1.3, self.game_over_font:getHeight() + 3
    self.restart_button = Button(gw/2 - restart_button_w/2 - 30, gh/2 + 2*self.game_over_font:getHeight(), {text = "restart", w = restart_button_w, h = restart_button_h, center_justified = true, font = self.game_over_font, always_hot = true,
            click = function() gotoRoom("Stage") end })

    local menu_button_w, menu_button_h  = restart_button_w, restart_button_h
    self.menu_button = Button(gw/2 - menu_button_w/2 + 30, gh/2 + 2*self.game_over_font:getHeight(), {text = "menu", w = menu_button_w, h = menu_button_h, center_justified = true, font = self.game_over_font, always_hot = true,
            click = function() gotoRoom("MainMenu") end })

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
            self.player:die()
        end)
    
    fadeVolume('music', 5, 0.5)
    fadeVolume('game', 5, 1.3)
    playRandomSong()
end

function Stage:update(dt)
    self.director:update(dt)
    camera:lockPosition(dt, gw/2, gh/2)
    self.timer:update(dt)
    self.area:update(dt)

    if self.game_over then
        self.restart_button:update(dt)
        self.menu_button:update(dt)
    end
end

function Stage:draw()
    love.graphics.setFont(self.font)

    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
    camera:detach()

    -- HP/ES

    if self.player.energy_shield then
        local r, g, b = unpack(default_color)
        local hp, max_hp = self.player.hp, self.player.max_hp
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2 - 52, gh - 16, 48*(hp/max_hp), 4)
        love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
        love.graphics.rectangle('line', gw/2 - 52, gh - 16, 48, 4)

        love.graphics.print('ES', gw/2 - 52 + 24, gh - 24, 0, 1, 1,
            math.floor(self.font:getWidth('ES')/2), math.floor(self.font:getHeight()/2))

        love.graphics.print(hp .. '/' .. max_hp, gw/2 - 52 + 24, gh - 6, 0, 1, 1,
            math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2), math.floor(self.font:getHeight()/2))
    else
        local r, g, b = unpack(hp_color)
        local hp, max_hp = math.floor(self.player.hp), math.floor(self.player.max_hp)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw/2 - 52, gh - 16, 48*(hp/max_hp), 4)
        love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
        love.graphics.rectangle('line', gw/2 - 52, gh - 16, 48, 4)

        love.graphics.print('HP', gw/2 - 52 + 24, gh - 24, 0, 1, 1,
            math.floor(self.font:getWidth('HP')/2), math.floor(self.font:getHeight()/2))

        love.graphics.print(hp .. '/' .. max_hp, gw/2 - 52 + 24, gh - 6, 0, 1, 1,
            math.floor(self.font:getWidth(hp .. '/' .. max_hp)/2), math.floor(self.font:getHeight()/2))
    end

    -- Ammo
    local r, g, b = unpack(ammo_color)
    local ammo, max_ammo = math.floor(self.player.ammo), math.floor(self.player.max_ammo)
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
    local boost, max_boost = math.floor(self.player.boost), math.floor(self.player.max_boost)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', gw/2 + 4, 16, 48*(boost/max_boost), 4)
    love.graphics.setColor(r - 32/255, g - 32/255, b - 32/255)
    love.graphics.rectangle('line', gw/2 + 4, 16, 48, 4)

    love.graphics.print('BOOST', gw/2 + 4 + 24, 8, 0, 1, 1,
        math.floor(self.font:getWidth('BOOST')/2), math.floor(self.font:getHeight()/2))

    love.graphics.print(boost .. '/' .. max_boost, gw/2 + 4 + 24, 26, 0, 1, 1,
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

    if self.game_over then 
        love.graphics.setFont(self.game_over_font)
        local score = "SCORE: " .. current_room.score
        local high_score = "HIGH SCORE: " .. GameData.high_score
        local difficulty = "DIFFICULTY REACHED: " .. current_room.director.difficulty
        local sp_gained = "SP GAINED: " .. self.old_sp - sp

        local initial_y = gh/2 - 3*self.game_over_font:getHeight()
        love.graphics.print(score, gw/2 - self.game_over_font:getWidth(score)/2, initial_y)
        love.graphics.print(high_score, gw/2 - self.game_over_font:getWidth(high_score)/2, initial_y + self.game_over_font:getHeight())
        love.graphics.print(difficulty, gw/2 - self.game_over_font:getWidth(difficulty)/2, initial_y + 2*self.game_over_font:getHeight())
        love.graphics.print(sp_gained, gw/2 - self.game_over_font:getWidth(sp_gained)/2, initial_y + 3*self.game_over_font:getHeight())
        
        self.restart_button:draw()
        self.menu_button:draw()
    end


    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')

end

function Stage:finish()
    self.director.dead = true -- Stop the director from spawning anything else. We'll let everything else tick as usual though when we display the death screen
    self.timer:after(1, function()
            if current_room.score > GameData.high_score then GameData.high_score = current_room.score end
            self.game_over = true
        end)
end

function Stage:destroy()
    self.area:destroy()
    self.player = nil
    self.area = nil
end