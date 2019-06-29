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

function Area:getGameObjects(func)
  local gameObjectsToReturn = {}
  for _, game_object in ipairs(self.game_objects) do
    if (func(game_object)) then
      table.insert(gameObjectsToReturn, game_object)
    end
  end
  return gameObjectsToReturn
end

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:queryCircleArea(x, y, radius, targetClasses)
  local gameObjectsToReturn = {}
  for _, game_object in ipairs(self.game_objects) do
    local distToGameObject = math.sqrt(math.pow(x - game_object.x, 2) + math.pow(y - game_object.y, 2))
    if (distToGameObject <= radius) then
      for _, class in ipairs(targetClasses) do
        --[[
          Exercise 61:
            Remember that :is takes an actual table as an argument, not a string. Thus we need to access the global class table itself and pass that in, which we can do
            by simply indexing using the strings in targetClasses.
            
            The implementation of :is may depend on the actual OOP library you use, however.
            I find it's helpful to actually take a look into the library code itself and see what's actually happening underneath the hood.
        ]]--
        if (game_object:is(_G[class])) then
          table.insert(gameObjectsToReturn, game_object)
          break
        end
      end
    end
  end
  return gameObjectsToReturn
end