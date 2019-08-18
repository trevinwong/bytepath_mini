Laser = GameObject:extend()

function Laser:new(area, x, y, opts)
    Laser.super.new(self, area, x, y, opts)
    self.middle_line_color = default_color
    self.middle_line_width = 10 * self.wm
    self.side_line_color = opts.side_line_color or hp_color
    self.side_line_width = 5 * self.wm
    self.side_offset = 6 * self.wm
    self.total_width = 2 * (self.side_offset + self.side_line_width/2)
    self.offset = self.total_width / 2
    
    local r_off1 = self.r - math.pi/2
    local r_off2 = self.r + math.pi/2
    
    --[[
        This approach is borrowed from the creator himself.
        My original approach was to create the vertices by calculating the slope perpendicular to the given line and offset the points that way.
        But this is a lot more intuitive and less code.
        
        The moral of the story is: if you're dealing with rotations in any way, look to use the angle that describes it.
        You can easily translate from coordinates to angles using the trigonometric functions. It's a simple lesson, but one I forget often.
    ]]--
    
    local x1n, y1n = self.x + self.offset*math.cos(r_off1), self.y + self.offset*math.sin(r_off1)
    local x2n, y2n = self.x + self.offset*math.cos(r_off2), self.y + self.offset*math.sin(r_off2)
    local x3n, y3n = self.x2 + self.offset*math.cos(r_off1), self.y2 + self.offset*math.sin(r_off1)
    local x4n, y4n = self.x2 + self.offset*math.cos(r_off2), self.y2 + self.offset*math.sin(r_off2)
    --[[
        A small tidbit: not sure if this is Windfield-specific or also a problem in Box2D, but using queryPolygonArea fails if the colliders you're testing
        against don't have any vertices. Previously, the enemy projectiles were using a circular collider, which I needed to change to a rectangular collider
        to make it work.
    ]]--
    local objects = self.area.world:queryPolygonArea({x1n, y1n, x2n, y2n, x3n, y3n, x4n, y4n}, {"Enemy", "EnemyProjectile"})
    for _, collider in ipairs(objects) do 
        local obj = collider:getObject()
        if obj:is(_G["EnemyProjectile"]) then
            obj:die()
        else
            obj:hit(1000) 
        end
    end
    
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
    local x2, y2 = self.x * 1024, self.y
    
    pushRotate(self.x, self.y, self.r) 

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
    love.graphics.pop()
end

function Laser:destroy()
    Laser.super.destroy(self)
end