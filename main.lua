io.stdout:setvbuf("no")
require('mobdebug').start() 
require 'utils'
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/EnhancedTimer/EnhancedTimer'
M = require 'libraries/Moses/moses'

--[[
  Exercise 65:
    There are two options when it comes to scaling into a resolution that your current resolution does not neatly multiply into.
    
    1. Scale to the target resolution using whatever ratio you get. This is usually a bad idea, since it'll lead to nasty pixel stretching that will make your game
    look bad. If your game is especially sensitive to being pixel perfect, this is even worse of an idea.
    
    2. Scale to the closest resolution that you neatly multiply into (underneath the target resolution, of course.) Then, fill the rest of the game area using
    a black background, or stretch the background of your game. This is what I did for Paper Cut.
]]--

function love.load()
  requireAllInFolder('objects')
  requireAllInFolder('rooms')
  input = Input()
  current_room = nil  
  
  resize(3)
  love.graphics.setDefaultFilter('nearest')
  love.graphics.setLineStyle('rough')
    
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

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end