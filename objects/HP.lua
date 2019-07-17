require "objects/GameObject"

HP = GameObject:extend()

function HP:new(area, x, y, opts)
    HP.super.new(self, area, x, y, opts)
    local direction = table.random({-1, 1})
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = random(48, gh - 48)

    self.r = 12
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.r, self.r)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(false)
    self.v = -direction*random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
end

function HP:update(dt)
    HP.super.update(self, dt)
    self.collider:setLinearVelocity(self.v, 0) 
end

function HP:draw()
    love.graphics.setColor(hp_color)
    draft:rectangle(self.x, self.y, self.r, self.r / 2, 'fill')
    draft:rectangle(self.x, self.y, self.r / 2, self.r, 'fill')
    love.graphics.setColor(default_color)
    love.graphics.circle('line', self.x, self.y, self.r)
end

function HP:die()
    self.dead = true
    self.area:addGameObject('HPEffect', self.x, self.y, 
    {color = hp_color, r = 1.3*self.r })
    for i = 1, love.math.random(4, 8) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = hp_color}) 
    end 
    self.area:addGameObject('InfoText', self.x, self.y, {text = '+HP', color = hp_color, w = self.r, h = self.r})
end

function HP:destroy()
   HP.super.destroy(self) 
end