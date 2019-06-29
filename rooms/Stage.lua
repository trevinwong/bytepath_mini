Stage = Object:extend()

function Stage:new()
  self.area = Area(self)
  self.timer = Timer()

  self:generateCircles()
  print(self.area:getClosestGameObject(window.width / 2, window.height / 2, 200, {"Circle"}))
end

function Stage:update(dt)
  self.timer:update(dt)
  self.area:update(dt)
end

function Stage:draw()
  self.area:draw()
  love.graphics.circle('line', window.width / 2, window.height / 2, 200)
end

function Stage:generateCircles()
  for i = 1, 10 do
    local x = love.math.random() * window.width;
    local y = love.math.random() * window.height;
    local radius = love.math.random() * 40
    self.area:addGameObject("Circle", x, y, {radius = 1})
  end
end