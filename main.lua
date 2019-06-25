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
    Exercise 47:
      The garbage collector works by occasionally collecting all dead objects - in other words, objects that are no longer accessible. It does this through a
      mark-and-sweep algorithm, which is as simple as it's name suggests. The first phase, "mark", simply marks all objects that are no longer accessible using
      an ordinary graph traversal algorithm. The second phase, "sweep", does the same thing, but simply reclaims the memory that the objects are occupying.
      
      As of Lua 5.1, the garbage collector is now incremental, that is, it now interleaves its collection time with the program execution. This is better since
      programs will now no longer freeze for a substantial amount of time due to the garbage collector.
      
      There are two parameters you can use to control the garbage collector in Lua, they are:
      
      1. The garbage-collector pause.
      
      This parameter controls how long the collector waits before starting a new cycle. Larger values make the collector less aggressive.
      
      2. The garbage-collector step multiplier.
      
      This parameter controls the relative speed of the collector relative to memory allocation. Larger values make the collector more aggressive.
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