Stage = Object:extend()

function Stage:new()
  self.area = Area(self)
  self.area:addPhysicsWorld()
  self.timer = Timer()
  self.player = self.area:addGameObject('Player', gw/2, gh/2)
  self.main_canvas = love.graphics.newCanvas(gw, gh)
  input:bind('f3', function() self.player.dead = true end)
end

function Stage:update(dt)
  camera.smoother = Camera.smooth.damped(5)
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
  
--[[
  Exercise 71:
    Sadly, love.graphics.setPointStyle() was deprecated after version 10.0, so I couldn't perfectly replicate the image.
    
    The logic behind this is pretty simple: the angle gives us the direction of where our line should point. If we want to "translate" this into x and y, we use
    cos and sin. Since they only give us the direction, we need to multiply it by the actual length of our line. Finally, we shift our point of origin to
    pointA by adding the coordinates of pointA.
]]--

  local pointA = {x = 300, y = 300}
  local angle = -math.pi/4
  local distance = 100
  local pointB = {x = (math.cos(angle) * 100) + pointA.x, y = (math.sin(angle) * 100) + pointA.y}
  love.graphics.setPointSize(5)
  love.graphics.points(pointA.x, pointA.y, pointB.x, pointB.y)
  love.graphics.print("A", pointA.x, pointA.y)
  love.graphics.print("B", pointB.x, pointB.y)
  love.graphics.line(pointA.x, pointA.y, pointB.x, pointB.y)
end