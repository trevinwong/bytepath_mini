require "objects/GameObject"

Shooter = GameObject:extend()

function Shooter:new(area, x, y, opts)
    Shooter.super.new(self, area, x, y, opts)

	--[[
		Exercise 115:
			Direction is a little bit confusing. It makes sense in that it's the direction that the enemy is coming from, but we also use the same attribute
			to define where the enemy should be facing, which would be the opposite direction.
			
			Still, I think it becomes apparent enough after a little bit of thought, so I think the current set-up is fine.
	]]--

    local direction = table.random({-1, 1})
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = random(16, gh - 16)
    self.hp = 100

    self.w, self.h = 12, 6
    self.collider = self.area.world:newPolygonCollider(
    {self.w, 0, -self.w/2, self.h, -self.w, 0, -self.w/2, -self.h})

    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
	-- You'll need to switch the angles, as the tutorial says you should rotate 0 rad when your direction is 1.
	-- Since direction == 1 means you are spawning from the right, and you are moving left, you should really be rotating pi rad to face left.
    self.collider:setAngle(direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.v = -direction*random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self:getWidthAndHeight()
	
	self.timer:every(random(3, 5), function()
        self.area:addGameObject('PreAttackEffect', 
        self.x + 1.4*self.w*math.cos(self.collider:getAngle()), 
        self.y + 1.4*self.w*math.sin(self.collider:getAngle()), 
        {shooter = self, color = hp_color, duration = 1})
        self.timer:after(1, function()
			self.area:addGameObject('EnemyProjectile', 
            self.x + 1.4*self.w*math.cos(self.collider:getAngle()), 
            self.y + 1.4*self.w*math.sin(self.collider:getAngle()), 
            {r = math.atan2(current_room.player.y - self.y, current_room.player.x - self.x), v = random(80, 100), s = 3.5})
        end)
    end)
end

function Shooter:draw()
    if self.hit_flash then
        love.graphics.setColor(default_color)
    else
        love.graphics.setColor(hp_color)
    end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
end

function Shooter:hit(damage)
    local damage = damage or 100
    self.hp = self.hp + damage
    if (self.hp <= 0) then
        self:die()
    else
        self.hit_flash = true
        timer:after(0.2, function()
                self.hit_flash = false
            end)
    end
end

function Shooter:getWidthAndHeight()
    local topLeftX, topLeftY, bottomRightX, bottomRightY = self.collider:computeAABB(self.x, self.y, 0)
    local width = topLeftX - bottomRightX
    local height = topLeftY - bottomRightY
    return width, height
end

function Shooter:die()
   self.dead = true
   local width, height = self:getWidthAndHeight()
   self.area:addGameObject('EnemyDeathEffect', self.x, self.y, 
    {color = hp_color, w = 30, h = 30})
end