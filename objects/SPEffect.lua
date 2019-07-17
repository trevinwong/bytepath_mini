require "objects/GameObject"

SPEffect = GameObject:extend()

function SPEffect:new(area, x, y, opts)
    SPEffect.super.new(self, area, x, y, opts)
    self.current_color = default_color
    
    self.sx, self.sy = 1, 1
    self.timer:tween(0.35, self, {sx = 1.8, sy = 1.8}, 'in-out-cubic')
    
    self.timer:after(0.2, function() 
        self.current_color = skill_point_color 
        self.timer:after(0.35, function()
            self.dead = true
        end)
    end)

    self.visible = true
    self.timer:after(0.2, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
    end)
end

function SPEffect:draw()
    if not self.visible then return end

    love.graphics.setColor(self.current_color)
    draft:rhombus(self.x, self.y, 1.34*self.w, 1.34*self.h, 'fill')
    draft:rhombus(self.x, self.y, self.sx*2*self.w, self.sy*2*self.h, 'line')
    love.graphics.setColor(default_color)
end