Stage = Object:extend()

function Stage:new()
  self.area = Area(self)
  self.timer = Timer()
  local radius = 20
  self.timer:every({1, 2}, function() self.area:addGameObject('Circle', love.math.random() * window.width, love.math.random() * window.height, { radius = radius }) end)
  
  input:bind('g', function()
      local circles = self.area:getGameObjects(function(game_object) if (game_object:is(Circle)) then return true end end)
      M.each(circles, print)
    end
  )
end

function Stage:update(dt)
  self.timer:update(dt)
  self.area:update(dt)
end

function Stage:draw()
  self.area:draw()
end