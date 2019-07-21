require "objects/GameObject"

Attack = GameObject:extend()

function Attack:new(area, x, y, opts)
    Attack.super.new(self, area, x, y, opts)
    local direction = table.random({-1, 1})
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = random(48, gh - 48)
    self.color = attacks[self.attack].color
    self.abbreviation = attacks[self.attack].abbreviation
    self.font = fonts["m5x7_16"]

    self.w, self.h = 24, 24
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(false)
    self.v = -direction*random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
end

function Attack:update(dt)
    Attack.super.update(self, dt)
    self.collider:setLinearVelocity(self.v, 0) 
end

function Attack:draw()
    love.graphics.setColor(self.color)
    draft:rhombus(self.x, self.y, 1.5*self.w, 1.5*self.h, 'line')
    love.graphics.setColor(default_color)
    draft:rhombus(self.x, self.y, 1.2*self.w, 1.2*self.h, 'line')
    love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)
    local width, height = self:getWidthAndHeightOfText(self.abbreviation)
    love.graphics.print(self.abbreviation, self.x - width / 2, self.y - height / 2)
end

function Attack:die()
    self.dead = true
    self.area:addGameObject('AttackEffect', self.x, self.y, 
    {color = self.color, w = self.w * 1.2, h = self.h * 1.2})
    self.area:addGameObject('InfoText', self.x, self.y, {text = self.attack, color = default_color, w = self.w, h = self.h})
end

function Attack:destroy()
   Attack.super.destroy(self) 
end

function Attack:getWidthAndHeightOfText(text)
    local width = 0
    for i = 1, #text do
        local c = text:sub(i,i)
        width = width + self.font:getWidth(text:sub(i, i))
    end
    local height = 0
    for j = 1, #text do
        height = math.max(height, self.font:getHeight(text:sub(j, j)))
    end
    return width, height
end