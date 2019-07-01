Player = GameObject:extend()

function Player:new(area, x, y, opts)
  Player.super.new(self, area, x, y, opts)
  self.x, self.y = x, y
  self.w, self.h = 12, 12
  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)
end

function Player:update(dt)
  Player.super.update(self, dt)
end

function Player:draw()
  love.graphics.circle('line', self.collider:getX(), self.collider:getY(), self.w)
end