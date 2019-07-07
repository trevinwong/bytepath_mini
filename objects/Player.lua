require "objects/GameObject"

Player = GameObject:extend()

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
    self.timer:every(0.24, function()
        self:shoot()
    end)
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
    --[[
        Exercise 83:
            This requires a little bit of knowledge about how rotations work. See, the way rotations are performed is around the origin of the current space -
            for example, (0, 0) in world space.
            
            So if we want to rotate an object around a different point, we have to translate our space such that the point we want to rotate around is the new origin.
            That is exactly what pushRotate is doing.
            
            In this case, we want to rotate around the center of the line that we're drawing, so we pass in exactly that to pushRotate.
    ]]--
    local pt2_x = self.x + 2*self.w*math.cos(self.r)
    local pt2_y = self.y + 2*self.w*math.sin(self.r)
    pushRotate((self.x + pt2_x)/2, (self.y + pt2_y)/2, math.pi/2)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
    love.graphics.pop()

end

function Player:shoot()
    local d = 1.2*self.w
    self.area:addGameObject('ShootEffect', self.x + 1.2*self.w*math.cos(self.r), self.y + 1.2*self.w*math.sin(self.r), {player = self, d = d})
end