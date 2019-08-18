require "objects/GameObject"

Explosion = GameObject:extend()

function Explosion:new(area, x, y, opts)
    Explosion.super.new(self, area, x, y, opts)

    self.color = default_color
	self.explosion_color = opts.color or hp_color
    self.s = (opts.s or random(40, 45)) * current_room.player.area_multiplier
	

    self.timer:tween(0.1, self, {s = self.s * 1.5}, 
    'in-out-cubic', function() 
		camera:shake(self.s/24, 60, (self.s/48)*0.4)
		for i = 1, love.math.random(12, 14) do 
			self.area:addGameObject('ExplodeParticle', self.x, self.y, {color = self.explosion_color, v = random(300, 350), s = random(4, 5)}) 
		end
		self.timer:tween(opts.d or 0.2, self, {s = 0}, 
		'in-out-cubic', function() 
			self.dead = true
		end)
	end)
	self.timer:after(0.1, function()
		self.color = self.explosion_color
	end)

	local enemies_in_radius = self.area:getAllGameObjectsThat(function(e)
		for _, enemy in ipairs(enemies) do
			if e:is(_G[enemy]) and (distance(e.x, e.y, self.x, self.y) < self.s) then
				return true
			end
		end
	end)

	for _, e in ipairs(enemies_in_radius) do
		e:hit(200)
	end
end

function Explosion:update(dt)
    Explosion.super.update(self, dt)
end

function Explosion:draw()
	love.graphics.setColor(self.color)
    draft:rectangle(self.x, self.y, self.s, self.s, 'fill')
end