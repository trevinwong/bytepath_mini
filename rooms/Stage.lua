Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.area.world:addCollisionClass('Player')
    --[[
        Exercise 95:
            Simply just add it to the ignore list.
    ]]--
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    
    self.timer = Timer()
    self.player = self.area:addGameObject('Player', gw/2, gh/2)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    camera.smoother = Camera.smooth.damped(5)
    
    input:bind('p', function() 
        self.area:addGameObject('Ammo', random(0, gw), random(0, gh)) 
    end)
    input:bind('o', function() 
        self.area:addGameObject('Boost') 
    end)
end

function Stage:update(dt)
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
  love.graphics.setCanvas()

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
  self.area:destroy()
  self.area = nil
end