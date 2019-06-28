Area = Object:extend()

function Area:new(room)
  self.room = room
  self.game_objects = {}
end

function Area:update(dt)
  for i = #self.game_objects, 1, -1 do
      local game_object = self.game_objects[i]
      game_object:update(dt)
      if game_object.dead then table.remove(self.game_objects, i) end
  end
end

function Area:draw()
  for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end


--[[
  Exercise 51:
    Lua considers exactly two values to be false - the boolean value "false", and nil. If "opts" is not passed in, an attempt to access the argument will result
    in nil. Thus, the local variable "opts" will be assigned to an empty table. Essentially, what we're looking at here is an idiom used to set defaults
    for arguments not passed in.
]]--
function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end