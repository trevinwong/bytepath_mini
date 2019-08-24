require "objects/GameObject"

Orbitter = GameObject:extend()

function Orbitter:new(area, x, y, opts)
    Orbitter.super.new(self, area, x, y, opts)

    self.direction = opts.direction or table.random({-1, 1})
    self.x = opts.x or gw/2 + self.direction*(gw/2 + 48)
    self.y = opts.y or random(16, gh - 16)
    self.hp = 450

    self.w = 10
    self.collider = self.area.world:newPolygonCollider(self:createIrregularPolygon(8))
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.v = -self.direction*random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(random(-100, 100))
    self:getWidthAndHeight()
	
	self:generateOrbittingProjectiles()
end

function Orbitter:draw()
    if self.hit_flash then
        love.graphics.setColor(default_color)
    else
        love.graphics.setColor(hp_color)
    end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
end

function Orbitter:createIrregularPolygon(size, point_amount)
    local point_amount = point_amount or 8
    local points = {}
    for i = 1, point_amount do
        local angle_interval = 2*math.pi/point_amount
        local distance = size + random(-size/4, size/4)
        local angle = (i-1)*angle_interval + random(-angle_interval/4, angle_interval/4)
        table.insert(points, distance*math.cos(angle))
        table.insert(points, distance*math.sin(angle))
    end
    return points
end

function Orbitter:hit(damage)
    local damage = damage or 100
    self.hp = self.hp - damage
    if (self.hp <= 0) then
        self:die()
    else
        self.hit_flash = true
        timer:after(0.2, function()
                self.hit_flash = false
            end)
    end
end

function Orbitter:getWidthAndHeight()
    local topLeftX, topLeftY, bottomRightX, bottomRightY = self.collider:computeAABB(self.x, self.y, 0)
    local width = topLeftX - bottomRightX
    local height = topLeftY - bottomRightY
    return width, height
end

function Orbitter:generateOrbittingProjectiles()
	self.orbittingProjectiles = {}
	for i = 1, random(5, 10) do
		table.insert(self.orbittingProjectiles, self.area:addGameObject('EnemyProjectile', self.x, self.y, {shield = true, v = random(80, 110), enemy = self}))
	end
end

function Orbitter:die()
    --[[
        It is possible for enemies to be overkilled by two sources of damage in the same tick, which would trigger death events twice
    ]]--
    if not self.dead then
        self.dead = true
        local width, height = self:getWidthAndHeight()
        self.area:addGameObject('EnemyDeathEffect', self.x, self.y, 
            {color = hp_color, w = 30, h = 30})
        current_room.score = current_room.score + 100
        current_room.player:onKill({self.x, self.y})
		
		for i = 1, #self.orbittingProjectiles do
			self.orbittingProjectiles[i]:homeTowardsPlayer()
		end
    end
end

function Orbitter:destroy()
	Orbitter.super.destroy(self)
end