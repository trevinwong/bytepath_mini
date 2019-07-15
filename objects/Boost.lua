require "objects/GameObject"

Boost = GameObject:extend()

function Boost:new(area, x, y, opts)
    Boost.super.new(self, area, x, y, opts)
    local direction = table.random({-1, 1})
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = random(48, gh - 48)

    self.w, self.h = 12, 12
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(false)
    self.v = -direction*random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(random(-24, 24))
end

function Boost:update(dt)
    Boost.super.update(self, dt)
    self.collider:setLinearVelocity(self.v, 0) 
end

function Boost:draw()
    love.graphics.setColor(boost_color)
    pushRotate(self.x, self.y, self.collider:getAngle())
    draft:rhombus(self.x, self.y, 1.5*self.w, 1.5*self.h, 'line')
    draft:rhombus(self.x, self.y, 0.5*self.w, 0.5*self.h, 'fill')
    love.graphics.pop()
    love.graphics.setColor(default_color)
end

function Boost:die()
    self.dead = true
    self.area:addGameObject('BoostEffect', self.x, self.y, 
    {color = Boost_color, w = self.w * 1.5, h = self.h * 1.5})
    self.area:addGameObject('InfoText', self.x, self.y, {text = '+BOOST', color = boost_color})
end

function Boost:destroy()
   Boost.super.destroy(self) 
end