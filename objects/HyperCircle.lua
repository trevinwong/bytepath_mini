require "objects/Circle"

HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, line_width, outer_radius)
  HyperCircle.super.new(self, x, y, radius)
  self.line_width = line_width or 1
  self.outer_radius = outer_radius or 1
  self.creation_time = love.timer.getTime()
end

function HyperCircle:update(dt)

end

function HyperCircle:draw()
  love.graphics.circle('fill', self.x, self.y, self.outer_radius)
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle('fill', self.x, self.y, self.outer_radius - self.line_width)
  love.graphics.setColor(1, 1, 1)
  HyperCircle.super.draw(self, self.x, self.y, self.radius)
end