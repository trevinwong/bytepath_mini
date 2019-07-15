require "objects/GameObject"

AmmoEffect = GameObject:extend()

function AmmoEffect:new(area, x, y, opts)
    AmmoEffect.super.new(self, area, x, y, opts)
    
    self.current_color = default_color
    self.timer:after(0.1, function()
        self.current_color = ammo_color
        self.timer:after(0.15, function()
            self.dead = true
        end)
    end)
end

function AmmoEffect:draw()
    love.graphics.setColor(self.current_color)
    draft:rhombus(self.x, self.y, self.w, self.h, 'fill')
end