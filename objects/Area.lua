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
    self.world = wf.newWorld(0, 0, true)
    
    --[[
      Exercise 67:
        Setting the physics world's y-gravity to 512 causes the Player object to fall, as expected.
        
        Note that two circles will be drawn if you do include the call to "world:draw()" - one for the Player game object, and one for the collider.
        You'll have to update the Player object to use the (x,y) coordinate of the collider if you want it to be drawn correctly according to it's collider.
    ]]--
    self.world:setGravity(0, 512)
end