CircleRoom = Object:extend()

function CircleRoom:new()
  local radius = 40
  self.circle = Circle((window.width / 2), (window.height / 2), radius) 
end

function CircleRoom:update(dt)
  
end

function CircleRoom:draw()
  self.circle:draw()
end