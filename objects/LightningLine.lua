LightningLine = GameObject:extend()

function LightningLine:new(area, x, y, opts)
    LightningLine.super.new(self, area, x, y, opts)
    self.lines = self:generate({self.start_point, self.end_point}, 3)
    self.alpha = 1
    self.timer:tween(random(0.15, 0.2), self, {alpha = 0}, 'in-out-cubic', function()
        self.dead = true
    end)
end

function LightningLine:update(dt)
    LightningLine.super.update(self, dt)
end

-- Generates lines and populates the self.lines table with them
function LightningLine:generate(initial_segment, num_generations)
  -- Segments are of type hump.vector
    local segment_list = {initial_segment}
    local offset = 40
    
    for i = 1, num_generations do
      for j = #segment_list, 1, -1 do 
        local seg = segment_list[j];
        local midpoint = (seg[1] + seg[2])/2
        midpoint = midpoint + (love.math.random(-offset, offset) * midpoint:normalized():perpendicular())

        local halfSeg1 = {seg[1], midpoint}
        local halfSeg2 = {midpoint, seg[2]}
        table.insert(segment_list, halfSeg1)
        table.insert(segment_list, halfSeg2)

        table.remove(segment_list, j)
      end
      offset = offset / 2
    end
    
    return segment_list
end

function LightningLine:draw()
    for i, line in ipairs(self.lines) do 
        local r, g, b = unpack(boost_color)
        love.graphics.setColor(r, g, b, self.alpha)
        love.graphics.setLineWidth(2.5)
        love.graphics.line(line[1].x, line[1].y, line[2].x, line[2].y) 

        local r, g, b = unpack(default_color)
        love.graphics.setColor(r, g, b, self.alpha)
        love.graphics.setLineWidth(1.5)
        love.graphics.line(line[1].x, line[1].y, line[2].x, line[2].y) 
    end
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255, 255, 255, 255)
end

function LightningLine:destroy()
    LightningLine.super.destroy(self)
end