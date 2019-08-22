require "objects/GameObject"

Seeker = GameObject:extend()

function Seeker:new(area, x, y, opts)
	Seeker.super.new(self, area, x, y, opts)

	self.direction = opts.direction or table.random({-1, 1})
	self.x = opts.x or gw/2 + self.direction*(gw/2 + 48)
	self.y = opts.y or random(16, gh - 16)
	self.hp = 200

	self.w = 12
	self.r = 0
	self.collider = self.area.world:newPolygonCollider(self:generatePolygons())
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setCollisionClass('Enemy')
	self.collider:setFixedRotation(false)
	self.v = -self.direction*random(20, 40)
	self.collider:setLinearVelocity(self.v, 0)

	self.timer:every(random(3, 5), function()
			self.area:addGameObject('PreAttackEffect', 
				self.x + 1.4*self.w*math.cos(self.collider:getAngle() - math.pi), 
				self.y + 1.4*self.w*math.sin(self.collider:getAngle() - math.pi), 
				{shooter = self, color = hp_color, duration = 1, back = true})
			self.timer:after(1, function()
					self.area:addGameObject('EnemyProjectile', 
						self.x + 1.4*self.w*math.cos(self.collider:getAngle() - math.pi), 
						self.y + 1.4*self.w*math.sin(self.collider:getAngle() - math.pi), 
						{v = random(80, 100), s = 3.5, mine = true})
				end)
		end)
end

function Seeker:update(dt)
	Seeker.super.update(self, dt)
	local target = current_room.player
	if target then
		local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
		local to_target_heading = Vector(target.x - self.x, target.y - self.y):normalized()
		local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
		self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
		self.collider:setAngle(math.atan(final_heading.y/final_heading.x))
	else self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r)) end
end

function Seeker:draw()
	if self.hit_flash then
		love.graphics.setColor(default_color)
	else
		love.graphics.setColor(hp_color)
	end
	local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
	love.graphics.polygon('line', points)
	love.graphics.setColor(default_color)
end

function Seeker:generatePolygons()
	local w = self.w
	local polygons = {
		w, 0, -- 1
		w/2, w/2, -- 2
		-w/2, w/2, -- 3
		-w, 0, -- 4
		-w/2, -w/2, -- 5
		w/2, -w/2 -- 6
	}
	return polygons
end
function Seeker:hit(damage)
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

function Seeker:getWidthAndHeight()
	local topLeftX, topLeftY, bottomRightX, bottomRightY = self.collider:computeAABB(self.x, self.y, 0)
	local width = topLeftX - bottomRightX
	local height = topLeftY - bottomRightY
	return width, height
end

function Seeker:die()
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
	end
end

function Seeker:destroy()
	Seeker.super.destroy(self)
end