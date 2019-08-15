require "objects/GameObject"

ShootEffect = GameObject:extend()

function ShootEffect:new(area, x, y , opts)
    ShootEffect.super.new(self, area, x, y, opts)
    self.w = opts.w or 8
    self.depth = 25
    self.color = default_color
    self.fade_to_color = opts.fade_to_color or default_color
    self.timer:tween(0.1, self, {w = 0}, 'in-out-cubic', function() self.dead = true end)
    self.timer:after(0.05, function()
        self.color = self.fade_to_color
    end)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self, dt)
    if self.player then 
        self.x = self.player.x + self.d*math.cos(self.player.r) 
    	self.y = self.player.y + self.d*math.sin(self.player.r) 
    end
end

function ShootEffect:draw()
    love.graphics.setColor(self.color)
    pushRotate(self.x, self.y, self.player.r + math.pi/4)
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
    love.graphics.pop()
end

function ShootEffect:destroy()
    ShootEffect.super.destroy(self)
end