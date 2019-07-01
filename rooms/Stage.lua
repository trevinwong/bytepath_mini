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
  Exercise 72:
    We do pretty much exactly the same thing we did for Exercise 71.
]]--

  local pointA = {x = 300, y = 300}
  local angle = -math.pi/4
  local distance = 100
  local pointB = {x = (math.cos(angle) * 100) + pointA.x, y = (math.sin(angle) * 100) + pointA.y}
  local pointC = {x = (math.cos(math.pi/4) * 50) + pointB.x, y = (math.sin(math.pi/4) * 50) + pointB.y}
  love.graphics.setPointSize(5)
  love.graphics.points(pointA.x, pointA.y, pointB.x, pointB.y, pointC.x, pointC.y)
  love.graphics.print("A", pointA.x, pointA.y)
  love.graphics.print("B", pointB.x, pointB.y)
  love.graphics.print("C", pointC.x, pointC.y)
  love.graphics.line(pointA.x, pointA.y, pointB.x, pointB.y)
  love.graphics.line(pointB.x, pointB.y, pointC.x, pointC.y)
end