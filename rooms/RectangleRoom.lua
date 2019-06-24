RectangleRoom = Object:extend()

function RectangleRoom:new()

end

function RectangleRoom:update(dt)
  
end

function RectangleRoom:draw()
  love.graphics.rectangle('fill', window.width / 2, window.height / 2, 40, 40)
end