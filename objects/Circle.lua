require "objects/GameObject"

Circle = GameObject:extend()

function Circle:new(area, x, y, opts)
  Circle.super.new(self, area, x, y, opts)
end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end

function Circle:__tostring()
  return ("Circle: x = %i, y = %i, r = %i"):format(self.x, self.y, self.radius)
end