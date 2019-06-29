Stage = Object:extend()

function Stage:new()
  self.area = Area(self)
  self.timer = Timer()

  self:generateCircles()
end

function Stage:update(dt)
  self.timer:update(dt)
  self.area:update(dt)
end

function Stage:draw()
  self.area:draw()
end

function Stage:generateCircles()
  self.timer:after(0.25, function(f)
    local x = love.math.random() * window.width;
    local y = love.math.random() * window.height;
    local radius = love.math.random() * 40
    self.area:addGameObject("Circle", x, y, {radius = radius})
    
    if (#self.area.game_objects ~= 10) then
      self.timer:after(0.25, f)
    else
      self:deleteCircles()
    end
  end)
end

function Stage:deleteCircles()
  self.timer:after({0.5, 1}, function(f)
      self.area.game_objects[love.math.random(#self.area.game_objects)].dead = true
      --[[
        Exercise 60:
          There's a gotcha here. Setting game_object.dead = true doesn't immediately remove it from the table - only on the next update. Thus, you have to stop at 1,
          not 0, otherwise you'll be accessing a nil index.
          
          That being said, I am consindering if it is worth it for a GameObject to have a "dead" property and not just immediately removing it. Is there any advantage
          for an already dead object to continue to be updated? Perhaps de-coupled logic in other systems which act upon dead objects need to continue to know
          about the dead object.
      ]]--
      if (#self.area.game_objects ~= 1) then
        self.timer:after({0.5, 1}, f)
      else
        self:generateCircles()
      end
  end)
end