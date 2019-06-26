Stage = Object:extend()

--[[
    Exercise 49:
      To be honest, I'm not sure why this exercise is here, considering all we have to do is paste the exact same code that we get from abstracting our code into          
      "GameObject" and "Area". Perhaps it's to illustrate why abstracting those concepts saves us a lot of time and headache. Indeed, all this code would be way
      too annoying to re-write every time.
]]--

function Stage:new()
  self.timer = Timer()
  self.game_objects = {}
  local radius = 20
  self.timer:every(2, function() self:addGameObject('Circle', love.math.random() * window.width, love.math.random() * window.height, { radius = radius }) end)
end

function Stage:update(dt)
  self.timer:update(dt)
  for i = #self.game_objects, 1, -1 do
      local game_object = self.game_objects[i]
      game_object:update(dt)
      if game_object.dead then table.remove(self.game_objects, i) end
  end
end

function Stage:draw()
  for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end

function Stage:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end