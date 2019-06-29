Stage = Object:extend()

function Stage:new()
  self.area = Area(self)
  self.timer = Timer()
  
  self:generateRectangles()
  
  input:bind('d', function()
    self.area.game_objects[love.math.random(#self.area.game_objects)].dead = true
  end)
end

function Stage:update(dt)
  self.timer:update(dt)
  self.area:update(dt)
  if (#self.area.game_objects == 0) then self:generateRectangles() end
end

function Stage:draw()
  self.area:draw()
end

function Stage:generateRectangles()
  for i = 1, 10 do
    local x = love.math.random() * window.width;
    local y = love.math.random() * window.height;
    local width = love.math.random() * 40;
    local height = love.math.random() * 40;
    self.area:addGameObject("Rectangle", x, y, {width = width, height = height})
  end
end