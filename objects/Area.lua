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
      if game_object.dead then table.remove(self.game_objects, i) end
  end
end

function Area:draw()
  --if self.world then self.world:draw() end -- For debugging
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
    --[[
      Exercise 68:
        The third option determines whether or not bodies can sleep.
        
        Setting a body to sleep means excluding it from expensive physics calculations that would be needed if the body were awake. Of course, the body can't be
        fully excluded, as awake bodies need it's information to collide with it. However, it still saves some computing time.
        
        By setting it to true, you get better performance.
        By setting it to false, you get more (technically, but maybe not practically speaking) accurate results.
    ]]--
    self.world = wf.newWorld(0, 0, true)
end