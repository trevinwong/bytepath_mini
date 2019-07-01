io.stdout:setvbuf("no")
require('mobdebug').start() 
require 'utils'
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/EnhancedTimer/EnhancedTimer'
M = require 'libraries/Moses/moses'
Camera = require 'libraries/hump/camera'
wf = require 'libraries/windfield/windfield'

--[[
  Exercise 69:
    math.pi/2 * 180/pi = 90 degrees = between the bottom-left and bottom-right quadrant
    math.pi/4 * 180/pi = 45 degrees = the bottom-right quadrant 
    3*math.pi/4 * 180/pi = 135 degrees = the bottom-left quadrant
    -5*math.pi/6 * 180/pi = -150 degrees = the top-left quadrant
    0 * 180/pi = 0 degrees = between the top-right and the bottom-right quadrant
    11*math.pi/12 * 180/pi = 165 degrees = the bottom-left quadrant
    -math.pi/6 * 180/pi = -30 degrees = the top-right quadrant
    -math.pi/2 + math.pi/4  = -math.pi/4 * 180/pi = -45 degrees = the top-right quadrant
    3*math.pi/4 + math.pi/3 = 9*math.pi/12 + 4*math.pi/12 = 13*math.pi/12 * 180/pi = 195 degrees = the bottom-left quadrant
    math.pi * 180/pi = 180 degrees = between the top-left and the bottom-left quadrant
    
    All were calculated using pure brainpower.
    Remember that in LOVE angles are counted in a clockwise manner as opposed to standard math convention which is quite confusing.
]]--

function love.load()
  requireAllInFolder('objects')
  requireAllInFolder('rooms')
  love.graphics.setDefaultFilter('nearest')
  love.graphics.setLineStyle('rough')
  
  input = Input()
  camera = Camera()

  resize(3)
  input:bind('left', 'left')
  input:bind('right', 'right')

  current_room = Stage()
end

function love.update(dt)
  camera:update(dt)
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