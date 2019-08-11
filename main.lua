io.stdout:setvbuf("no")
-- Beware, enabling mobdebug will kill the performance of your game.
--require('mobdebug').start() 

Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/EnhancedTimer/EnhancedTimer'
M = require 'libraries/Moses/moses'
Camera = require 'libraries/hump/camera'
Vector = require 'libraries/hump/vector'
wf = require 'libraries/windfield/windfield'
Draft = require('libraries/draft/draft')
draft = Draft('line')
require 'utils'
require 'globals'
require 'libraries/utf8'

function love.load()
    
    
--  love.profiler = require('libraries/profile') 
--  love.profiler.hookall("Lua")
--  love.profiler.start()
  
    requireAllInFolder('data')
    requireAllInFolder('objects')
    requireAllInFolder('rooms')
    fonts = {}
    loadFontsInFolderAsSize('resources/fonts', 16)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    input = Input()
    camera = Camera()
    timer = Timer()

    slow_amount = 1
    flash_frames = nil
    resize(3)
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('up', 'up')
    input:bind('down', 'down')
    
    input:bind('f1', function()
        print("Before collection: " .. collectgarbage("count")/1024)
        
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)

    input:bind('f2', function()
            gotoRoom("Stage")
    end)

    input:bind('f3', function()
             current_room:destroy()
            current_room = nil
        end
    )
    
    --[[
        Useful time manipulation functions that I picked up during my time at Skybox :)
    ]]--
    input:bind('1', function()
            slow_amount = 1
        end
    )
    input:bind('2', function()
            slow_amount = 0.5
        end
    )
    input:bind('3', function()
            slow_amount = 0.1
        end
    )
    input:bind('4', function()
            slow_amount = 0.05
        end
    )
    input:bind('5', function()
            slow_amount = 2
        end
    )
    input:bind('6', function()
            slow_amount = 5
        end
    )
    
    current_room = Stage()
end

--love.frame = 0
function love.update(dt)
--      love.frame = love.frame + 1
--  if love.frame%100 == 0 then
--    love.report = love.profiler.report('time', 20)
--    love.profiler.reset()
--  end
  
    timer:update(dt*slow_amount)
    camera:update(dt*slow_amount)
    if flash_seconds then 
        flash_seconds = flash_seconds - dt
        if flash_seconds < 0 then flash_seconds = nil end
    end
    if current_room then current_room:update(dt*slow_amount) end
end

function love.draw()
    if current_room then current_room:draw() end

    if flash_seconds then
        love.graphics.setColor(background_color)
        love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
        love.graphics.setColor(255, 255, 255)
    end
--      love.graphics.print(love.report or "Please wait...")
end

function gotoRoom(room_type, ...)
    if current_room and current_room.destroy then current_room:destroy() end
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

function loadFontsInFolderAsSize(folder, size)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        local info = love.filesystem.getInfo(file)
        if info.type == 'file' then
            local name = item:sub(0, item:len() - 4) .. "_" .. size
            fonts[name] = love.graphics.newFont(file, size)
            --[[
                Don't forget to set the filter of your fonts to use nearest, otherwise, you'll get blurry text.
            ]]--
            fonts[name]:setFilter('nearest', 'nearest')
        end
    end
end

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end