io.stdout:setvbuf("no")
require('mobdebug').start() 
require 'utils'
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/EnhancedTimer/EnhancedTimer'
M = require 'libraries/Moses/moses'
Camera = require 'libraries/hump/camera'
wf = require 'libraries/windfield/windfield'

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

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end