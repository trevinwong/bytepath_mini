Area = Object:extend()

function Area:new(room)
  self.room = room
  self.game_objects = {}
end

function Area:update(dt)
  if self.world then self.world:update(dt) end
  for i = #self.game_objects, 1, -1 do
      local game_object = self.game_objects[i]
      game_object:update(dt)
      if game_object.dead then 
        game_object:destroy()
        table.remove(self.game_objects, i) 
      end
  end
end

function Area:draw()
  --if self.world then self.world:draw() end -- For debugging
    table.sort(self.game_objects, function(a, b) 
        if a.depth == b.depth then return a.creation_time < b.creation_time
        else return a.depth < b.depth end
    end)

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
        if (game_object:is(_G[class])) then
          table.insert(gameObjectsToReturn, game_object)
          break
        end
      end
    end
  end
  return gameObjectsToReturn
end

function Area:getClosestGameObject(x, y, radius, targetClasses)
  local closestDist = math.huge
  local closestGameObject = nil
  for _, game_object in ipairs(self.game_objects) do
    local distToGameObject = math.sqrt(math.pow(x - game_object.x, 2) + math.pow(y - game_object.y, 2))
    if (distToGameObject <= radius) then
      for _, class in ipairs(targetClasses) do
        if (game_object:is(_G[class])) then
          if (distToGameObject < closestDist) then
            closestDist = distToGameObject
            closestGameObject = game_object
            break
          end
        end
      end
    end
  end
  return closestGameObject
end

function Area:addPhysicsWorld()
  self.world = wf.newWorld(0, 0, true)
end

function Area:destroy()
  for i = #self.game_objects, 1, -1 do
      local game_object = self.game_objects[i]
      game_object:destroy()
      table.remove(self.game_objects, i)
  end
  self.game_objects = {}

  if self.world then
      self.world:destroy()
      self.world = nil
  end
end

--[[
    Exercise 101:
        I usually don't cheap out on an exercise, but I personally believe this exercise is neither A) helpful to the project or B) helpful to my learning.
        The naive solution is to create a big bounding box of all your objects and then place your object outside of that. Obviously, this is a very flawed solution.
        
        I'm sure there are better solutions, but I don't really feel like banging my head against the wall to come up with a complex solution that won't be used at all.
        Overlapping text is obviously quite normal in games and even necessary at times to know which object the text is referring to.
]]--

function Area:getAllGameObjectsThat(filter)
    local out = {}
    for _, game_object in pairs(self.game_objects) do
        if filter(game_object) then
            table.insert(out, game_object)
        end
    end
    return out
end