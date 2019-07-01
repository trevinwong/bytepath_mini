Player = GameObject:extend()

--[[
  Exercise 70:
    Technically, for this game, the acceleration property doesn't need to exist. The player never stops moving and is always moving at max velocity.
    
    The player's update function would look almost exactly the same, but instead:
    1. We would remove the line with the update to velocity.
    2. We would use the player's max velocity to set the linear velocity of our collider.
    
    There aren't really any benefits other than the player having to accelerate to max velocity at the beginning of the game.
    Perhaps it would come into play if somehow the player's velocity was slowed down.
]]--

function Player:new(area, x, y, opts)
  Player.super.new(self, area, x, y, opts)
  self.x, self.y = x, y
  self.w, self.h = 12, 12
  self.r = -math.pi/2
  self.rv = 1.66*math.pi
  self.v = 0
  self.max_v = 100
  self.a = 100
  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)
end

function Player:update(dt)
  Player.super.update(self, dt)
  if input:down('left') then self.r = self.r - self.rv*dt end
  if input:down('right') then self.r = self.r + self.rv*dt end

  self.v = math.min(self.v + self.a*dt, self.max_v)
  self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Player:draw()
  love.graphics.circle('line', self.x, self.y, self.w)
  love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end