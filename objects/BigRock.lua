require "objects/Rock"

BigRock = Rock:extend()

function BigRock:new(area, x, y, opts)
	BigRock.super.new(self, area, x, y, opts)

	self.hp = 300
	self.w, self.h = 8, 8
	self.collider = self.area.world:newPolygonCollider(self:createIrregularPolygon(16))
	self.collider:setPosition(self.x, self.y)
	self.collider:setObject(self)
	self.collider:setCollisionClass('Enemy')
	self.collider:setFixedRotation(false)
	self.collider:setLinearVelocity(self.v, 0)
	self.collider:applyAngularImpulse(random(-100, 100))
	self:getWidthAndHeight()
end

function BigRock:draw()
	BigRock.super.draw(self)
end

function createIrregularPolygon(size, point_amount)
	return BigRock.super.createIrregularPolygon(self, size, point_amount)
end

function BigRock:hit(damage)
	BigRock.super.hit(self, damage)
end

function BigRock:getWidthAndHeight()
	return BigRock.super.getWidthAndHeight(self)
end

function BigRock:die()
	if not self.dead then
		self.dead = true
		local width, height = self:getWidthAndHeight()
		self.area:addGameObject('EnemyDeathEffect', self.x, self.y, 
			{color = hp_color, w = 30, h = 30})
		current_room.score = current_room.score + 100
		current_room.player:onKill({self.x, self.y})
		local r = math.pi/4
		for i = 1, 4 do
			self.area:addGameObject('Rock', 0, 0, {direction = self.direction, x = self.x + random(10, 13)*math.cos(r), y = self.y + random(10, 13)*math.sin(r)})			
			r = r + random(math.pi/4, math.pi/2)
		end
		playGameEnemyDie()
	end
end

function BigRock:destroy()
	BigRock.super.destroy(self)
end