Stage = Object:extend()

function Stage:new()
  self.area = Area(self)
  self.timer = Timer()
  local radius = 20
  self.timer:every(2, function() self.area:addGameObject('Circle', love.math.random() * window.width, love.math.random() * window.height, { radius = radius }) end)
end

function Stage:update(dt)
  self.timer:update(dt)
  self.area:update(dt)
end

function Stage:draw()
  self.area:draw()
end