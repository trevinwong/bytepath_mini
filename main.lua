io.stdout:setvbuf("no")
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/chrono/Timer'

function love.load()
  requireAllInFolder('objects')
  input = Input()
  timer = Timer()
  
  circle = {radius = 24}
  timer:every(4, function()
      timer:tween(2, circle, {radius = 96}, 'in-out-cubic', function()
          timer:tween(2, circle, {radius = 24}, 'in-out-cubic')
      end)
  end)
end

function love.update(dt)
  timer:update(dt)
end

function love.draw()
  love.graphics.circle('fill', 400, 300, circle.radius)
end

function requireAllInFolder(folder)
  local object_files = {}
  recursiveEnumerate('objects', object_files)
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