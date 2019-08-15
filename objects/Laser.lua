Laser = GameObject:extend()

function Laser:new(area, x, y, opts)
    Laser.super.new(self, area, x, y, opts)
    self.middle_line_color = default_color
    self.middle_line_width = 10
    self.side_line_color = opts.side_line_color or hp_color
    self.side_line_width = 5
    self.side_offset = 6
    
    self.s = 60
    camera:shake(self.s/24, 60, (self.s/48)*0.4)
    self.timer:tween(0.25, self, {middle_line_width = 0, side_line_width = 0, side_offset = 12}, 'in-out-cubic', function()
        self.dead = true
    end)
end

function Laser:update(dt)
    Laser.super.update(self, dt)
end


function Laser:draw()
    local x1, y1 = self.x, self.y
    local x2, y2 = self.end_point[1], self.end_point[2]
    
    -- Left line
    love.graphics.setColor(self.side_line_color)
    love.graphics.setLineWidth(self.side_line_width)
    love.graphics.line(x1, y1 - self.side_offset, x2, y2 - self.side_offset)
    
    -- Right line
    love.graphics.setColor(self.side_line_color)
    love.graphics.setLineWidth(self.side_line_width)
    love.graphics.line(x1, y1 + self.side_offset, x2, y2 + self.side_offset)
    
    -- Middle line
    love.graphics.setColor(self.middle_line_color)
    love.graphics.setLineWidth(self.middle_line_width)
    love.graphics.line(x1, y1, x2, y2)
    
    love.graphics.setLineWidth(1)
end

function Laser:destroy()
    Laser.super.destroy(self)
end