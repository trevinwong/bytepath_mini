Circle = Object:extend()

function Circle:new(x, y, radius)
  self.x = x or 0
  self.y = y or 0
  self.radius = radius or 1
  self.creation_time = love.timer.getTime()
end

function Circle:update(dt)

end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end