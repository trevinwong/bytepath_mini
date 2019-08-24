require "objects/GameObject"
EnemyProjectile = GameObject:extend()

function EnemyProjectile:new(area, x, y, opts)
	EnemyProjectile.super.new(self, area, x, y, opts)

	self.s = opts.s or 2.5
	self.v = opts.v or 200
	self.damage = 10
	self.r = opts.r or 0

	if self.mine then
		self.rv = table.random({random(-12*math.pi, -10*math.pi), 
				random(10*math.pi, 12*math.pi)})
		self.timer:after(random(8, 12), function()
				self.area:addGameObject('Explosion', self.x, self.y, {color = hp_color})
			end)
	end

	if self.shield then
		self.orbit_distance = random(32, 40)
		self.orbit_speed = table.random({random(1, 5), random(-1, -5)})
		self.orbit_offset = random(0, 2*math.pi)
	end

	self.collider = self.area.world:newRectangleCollider(self.x, self.y, 4 * self.s, self.s)
	self.collider:setCollisionClass('EnemyProjectile')
	self.collider:setObject(self)
	self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
	self.previous_x, self.previous_y = self.collider:getPosition()
end

function EnemyProjectile:update(dt)
	EnemyProjectile.super.update(self, dt)

	if not self.shield then
		if self.x < 0 then self:die() end
		if self.y < 0 then self:die() end
		if self.x > gw then self:die() end
		if self.y > gh then self:die() end
	end

	if self.mine then
		self.r = self.r + self.rv*dt
	end

	if self.shield then
		local enemy = self.enemy

		if enemy then
			self.collider:setPosition(
				enemy.x + self.orbit_distance*math.cos(self.orbit_speed*time + self.orbit_offset),
				enemy.y + self.orbit_distance*math.sin(self.orbit_speed*time + self.orbit_offset))

			local x, y = self.collider:getPosition()
			local dx, dy = x - self.previous_x, y - self.previous_y
			self.r = Vector(dx, dy):angleTo()
		end
	end

	if self.collider:enter('Player') then
		local collision_data = self.collider:getEnterCollisionData('Player')
		local object = collision_data.collider:getObject()
		object:hit(-self.damage)
		self:die()
	end

	if self.home then
		local target = current_room.player
		if target then
			local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
			local to_target_heading = Vector(target.x - self.x, target.y - self.y):normalized()
			local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
			self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
		end
	else
		self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
	end

	self.previous_x, self.previous_y = self.collider:getPosition()
end

function EnemyProjectile:draw()
	love.graphics.setColor(hp_color)

	pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angleTo()) 
	love.graphics.setLineWidth(self.s - self.s/4)
	love.graphics.line(self.x - 2*self.s, self.y, self.x, self.y)
	love.graphics.line(self.x, self.y, self.x + 2*self.s, self.y)
	love.graphics.setLineWidth(1)
	love.graphics.pop()
	love.graphics.setColor(default_color)
end

function EnemyProjectile:die()
	self.dead = true
	self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, 
		{color = hp_color, w = 3*self.s})
end

function EnemyProjectile:homeTowardsPlayer()
	if not self.dead then
		self.home = true
		self.shield = false
		self.timer:after(2, function()
				self:die()
			end)
	end
end