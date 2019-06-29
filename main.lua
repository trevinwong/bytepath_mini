io.stdout:setvbuf("no")
require('mobdebug').start() 
require 'utils'
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/EnhancedTimer/EnhancedTimer'
M = require 'libraries/Moses/moses'

--[[
  Exercise 57:
    You can find the memory usage by doing collectgarbage("count"). It returns the total amount in kilobytes.
]]--

function love.load()
  requireAllInFolder('objects')
  requireAllInFolder('rooms')
  input = Input()
  current_room = nil  
    
  input:bind('1', function() gotoRoom('CircleRoom') end)
  input:bind('2', function() gotoRoom('RectangleRoom') end)
  input:bind('3', function() gotoRoom('PolygonRoom') end)
  input:bind('4', function() gotoRoom('Stage') end)
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