require "objects/GameObject"

Waver = GameObject:extend()

function Waver:new(area, x, y, opts)
	Waver.super.new(self, area, x, y, opts)

	self.direction = opts.direction or table.random({-1, 1})
	self.x = opts.x or gw/2 + self.direction*(gw/2 + 48)
	self.y = opts.y or random(16, gh - 16)
	self.r = 0
	self.hp = 70

	self.w = 8
	self.collider = self.area.world:newPolygonCollider(self:generatePolygons())
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setCollisionClass('Enemy')
	self.collider:setFixedRotation(false)
	self.v = -self.direction*random(70, 90)
	self.collider:setLinearVelocity(self.v, 0)
	self:getWidthAndHeight()
	self.waviness = 2

	self.timer:every(1, function()
			self:shoot()
		end)
	self.timer:tween(0.25, self, {r = self.r + self.waviness*self.direction*math.pi/8}, 'linear', function()
			self.timer:tween(0.25, self, {r = self.r - self.waviness*self.direction*math.pi/4}, 'linear')
		end)
	self.timer:every(0.75, function()
			self.timer:tween(0.25, self, {r = self.r + self.waviness*self.direction*math.pi/4}, 'linear',  function()
					self.timer:tween(0.5, self, {r = self.r - self.waviness*self.direction*math.pi/4}, 'linear')
				end)
		end)
end

function Waver:update(dt)
	Waver.super.update(self, dt)
	self.collider:setAngle(self.r)
	self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Waver:draw()
	if self.hit_flash then
		love.graphics.setColor(default_color)
	else
		love.graphics.setColor(hp_color)
	end
	local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
	love.graphics.polygon('line', points)
	love.graphics.setColor(default_color)
end

function Waver:shoot()
	local d = 1.4*self.w
	self.area:addGameObject('EnemyProjectile', 
		self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r,  v = random(100, 120)})

	local back_r = self.r - math.pi
	self.area:addGameObject('EnemyProjectile', 
		self.x + d*math.cos(back_r), self.y + d*math.sin(back_r), {r = back_r,  v = random(100, 120)})
end

function Waver:generatePolygons()
	local polygons = {
		0, self.w/2,
		self.w, 0,
		0, -self.w/2,
		-self.w, 0
	}
	return polygons
end

function Waver:hit(damage)
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

function Waver:getWidthAndHeight()
	local topLeftX, topLeftY, bottomRightX, bottomRightY = self.collider:computeAABB(self.x, self.y, 0)
	local width = topLeftX - bottomRightX
	local height = topLeftY - bottomRightY
	return width, height
end

function Waver:die()
	if not self.dead then
		self.dead = true
		local width, height = self:getWidthAndHeight()
		self.area:addGameObject('EnemyDeathEffect', self.x, self.y, 
			{color = hp_color, w = 30, h = 30})
		current_room.score = current_room.score + 100
		current_room.player:onKill({self.x, self.y})
	end
end

function Waver:destroy()
	Waver.super.destroy(self)
end