io.stdout:setvbuf("no")
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/EnhancedTimer/EnhancedTimer'
M = require 'libraries/Moses/moses'

function love.load()
  requireAllInFolder('objects')
  requireAllInFolder('rooms')
  input = Input()
  timer = Timer()
  current_room = nil  
  
  --[[
    Exercise 46:
      Paper Cut has a few "rooms", which I called states:
        - Main Menu
        - Shop
        - Achievements
        - Difficulty Select
        - Instructions
        - Game
        - Game Over
      Player data was saved through a global Player construct. In retrospect, it might have been better to simply overlay these rooms on top of eachother like a stack
      so as to avoid re-creating them needlessly (for example, pushing the "Shop" state on top of the "Main Menu" state) but I think the states were low-cost enough
      that it didn't matter.
  ]]--
  input:bind('1', function() gotoRoom('CircleRoom') end)
  input:bind('2', function() gotoRoom('RectangleRoom') end)
  input:bind('3', function() gotoRoom('PolygonRoom') end)
end

function love.update(dt)
  if current_room then current_room:update(dt) end
end

function love.draw()
  if current_room then current_room:draw() end
end

function gotoRoom(room_type, ...)
  current_room = _G[room_type](...)
end

function requireAllInFolder(folder)
  local object_files = {}
  recursiveEnumerate(folder, object_files)
  requireFiles(object_files)
end

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        local info = love.filesystem.getInfo(file)
        if info.type == 'file' then
            table.insert(file_list, file)
        elseif info.type == 'directory' then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local fileNoDotLua = file:sub(1, -5)
        require(fileNoDotLua)
    end
end