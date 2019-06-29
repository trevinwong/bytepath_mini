require "objects/GameObject"

Rectangle = GameObject:extend()

function Rectangle:new(area, x, y, opts)
  Rectangle.super.new(self, area, x, y, opts)
end

function Rectangle:draw()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end