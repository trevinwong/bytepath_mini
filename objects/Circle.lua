require "objects/GameObject"

Circle = GameObject:extend()

function Circle:new(area, x, y, opts)
  local opts = opts or {}
  if opts then for k, v in pairs(opts) do self[k] = v end end

  self.area = area
  self.x, self.y = x, y
  self.id = UUID()
  self.dead = false
  self.timer = Timer()
  self.timer:after(4, function() self.dead = true end)
end

function Circle:update(dt)
    if self.timer then self.timer:update(dt) end
end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end