require "objects/GameObject"

ShootEffect = GameObject:extend()

function ShootEffect:new(area, x, y , opts)
    ShootEffect.super.new(self, area, x, y, opts)
    self.w = 8
    self.timer:tween(0.1, self, {w = 0}, 'in-out-cubic', function() self.dead = true end)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self, dt)
    if self.player then 
        self.x = self.player.x + self.d*math.cos(self.player.r) 
    	self.y = self.player.y + self.d*math.sin(self.player.r) 
    end
end

function ShootEffect:draw()
    pushRotate(self.x, self.y, self.player.r + math.pi/4)
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
    love.graphics.pop()
end

--[[
    Exercise 81:
        In this case, no. You only have to be careful if the object can be accessed through some other reference. Since the ShootEffect will automatically be removed
        from the GameObject list in Area, it will eventually be garbage collected (since there is nothing else referencing it). Once it is garbage collected, the
        reference to the player will disappear, and the player can then be garbage collected like normal.
        
        But it might still be a good practice just to de-reference things just in-case.
]]--

function ShootEffect:destroy()
    ShootEffect.super.destroy(self)
end