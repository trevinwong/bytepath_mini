GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
  local opts = opts or {}
  if opts then for k, v in pairs(opts) do self[k] = v end end

  self.area = area
  self.x, self.y = x, y
  self.id = UUID()
  self.dead = false
  self.creation_time = love.timer.getTime()
  self.depth = 50
  self.timer = Timer()
end

function GameObject:update(dt)
  if self.timer then self.timer:update(dt) end
  if self.collider then self.x, self.y = self.collider:getPosition() end
end

function GameObject:draw()

end

function GameObject:destroy()
    self.timer:destroy()
    if self.collider then self.collider:destroy() end
    self.collider = nil
end