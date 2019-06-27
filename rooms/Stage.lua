Stage = Object:extend()

--[[
    Exercise 50:
      I believe "Exercise 1" refers to "Exercise 48". I had to do some wonky tweaking with hump.timer in-order to get random timers working, since I wasn't able
      to figure out how hump.timer was passing in the callback function as a parameter to the callback funciton (to simulate the behaviour of every with after),
      so I wasn't able to modify Chrono nicely.
      But one day I'll crack it.
      
      Sadly, this also means that I had to remove hump as a submodule since there was very likely no way that I was going to be able to push my changes (and have it
      get accepted) by the owner of the hump repo, which means we can no longer easily get the latest updates :(
      
      I also deleted a bunch of the other hump files as a result (although the vector class seems useful) as a result.
      
      Also, the tweaking is fragile and takes advantage of global functions which is likely not the best. I'll fix it later (aka never).
]]--

function Stage:new()
  self.timer = Timer()
  self.game_objects = {}
  local radius = 20
  self.timer:every({5, 4}, function() self:addGameObject('Circle', love.math.random() * window.width, love.math.random() * window.height, { radius = radius }) end)
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