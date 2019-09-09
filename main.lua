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
ripple = require('libraries/ripple/ripple')
bitser = require('libraries/bitser/bitser')
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
    requireAllInFolder('modules')
    fonts = {}
    loadFontsInFolderAsSize('resources/fonts', 16)
    loadFontsInFolderAsSize('resources/fonts', 8)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    sound()
    scaleResolution()

    input = Input()
    camera = Camera()
    timer = Timer()

    loadGameData()
    time = 0
    slow_amount = 1
    screen_alpha = 1
    flash_frames = nil
    room_stack = {} -- highest index is the "top" of the stack

    --resize(3)
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('mouse1', 'left_click')
    input:bind('wheelup', 'zoom_in')
    input:bind('wheeldown', 'zoom_out')
    input:bind('return', 'return')
    input:bind('backspace', 'backspace')

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
            gotoRoom("SkillTree")
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
            slow_amount = 0
        end
    )

    -- SP
    max_sp = 999
    max_nodes = 200

    -- Canvas
    main_canvas = love.graphics.newCanvas(gw, gh)

    local x, y, w, h = 40, gh - 20, 20, 50
    back_button = Button(x - h/2, y - w/2, {w = h, h = w, custom_draw = function()
                pushRotate(x, y, -math.pi/2)
                draft:triangleIsosceles(x, y, w, h, 'fill')
                love.graphics.pop()
            end,
            click = function()
                current_room:onBack()
                popRoomStack()
                playMenuBack()
            end
        })
    slow_amount = 0.2
    gotoRoom("Stage")
end

--love.frame = 0
function love.update(dt)
 --   soundUpdate(dt)
--      love.frame = love.frame + 1
--  if love.frame%100 == 0 then
--    love.report = love.profiler.report('time', 20)
--    love.profiler.reset()
--  end
    time = time + dt
    timer:update(dt*slow_amount)
    camera:update(dt*slow_amount)
    if flash_seconds then 
        flash_seconds = flash_seconds - dt
        if flash_seconds < 0 then flash_seconds = nil end
    end
    if current_room then current_room:update(dt*slow_amount) end
    if #room_stack > 1 then back_button:update() end
end

function love.draw()
    if current_room then current_room:draw() end

    if #room_stack > 1 then
        love.graphics.setCanvas(main_canvas)
        back_button:draw()
        love.graphics.setCanvas()

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setBlendMode('alpha', 'premultiplied')
        love.graphics.draw(main_canvas, 0, 0, 0, sx, sy)
        love.graphics.setBlendMode('alpha')

    end

    if flash_seconds then
        love.graphics.setColor(background_color)
        love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
        love.graphics.setColor(255, 255, 255)
    end
    
    love.graphics.translate(xTranslationRequiredToCenter, yTranslationRequiredToCenter)
--      love.graphics.print(love.report or "Please wait...")
end

function gotoRoom(room_type, ...)
    if current_room and current_room.destroy then current_room:destroy() end
    local new_room = _G[room_type](...)
    room_stack = {}
    table.insert(room_stack, new_room)
    current_room = new_room
end

function gotoRoomPutOnStack(room_type, ...)
    -- if current_room and current_room.destroy then current_room:destroy() end
    local new_room = _G[room_type](...)
    table.insert(room_stack, new_room)
    current_room = new_room
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

function love.textinput(t)
    if current_room.textinput then current_room:textinput(t) end
end

function popRoomStack()
    if #room_stack > 1 then
        table.remove(room_stack) 
        current_room = room_stack[#room_stack]
    end
end

function scaleResolution()
    -- our orig resolution is gw, gh aka 480, 270
    -- our desired resolution is getWidth() and getHeight()
    local desiredWidth = love.graphics.getWidth()
    local desiredHeight = love.graphics.getHeight()

    if desiredWidth < desiredHeight then
        -- width is less, scale up to width
        scaleRatio = desiredWidth / gw
    else
        -- height is less than or equal, scale up to height
        scaleRatio = desiredHeight / gh
    end
    
    scaleRatio = math.floor(scaleRatio) -- floor the result b/c we don't want any pixel stretching
    local scaledWidth, scaledHeight = scaleRatio * gw, scaleRatio * gh
    local widthDiff, heightDiff = desiredWidth - scaledWidth, desiredHeight - scaledHeight
    xTranslationRequiredToCenter, yTranslationRequiredToCenter = widthDiff/2, heightDiff/2 -- translate the entire screen by half the difference so we have equal diff on both sides
    resize(scaleRatio)
end