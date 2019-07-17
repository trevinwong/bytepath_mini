require "objects/GameObject"

HPEffect = GameObject:extend()

function HPEffect:new(area, x, y, opts)
    HPEffect.super.new(self, area, x, y, opts)
    self.current_color = default_color
    
    self.sx, self.sy = 1, 1
    self.timer:tween(0.35, self, {sx = 1.5, sy = 1.5}, 'in-out-cubic')
    
    self.timer:after(0.2, function() 
        self.current_color = hp_color 
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

function HPEffect:draw()
    if not self.visible then return end
    
    love.graphics.setColor(self.current_color)
    draft:rectangle(self.x, self.y, self.r, self.r / 2, 'fill')
    draft:rectangle(self.x, self.y, self.r / 2, self.r, 'fill')
    love.graphics.setColor(default_color)
    love.graphics.circle('line', self.x, self.y, self.sx * self.r)
end