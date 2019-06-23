io.stdout:setvbuf("no")
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'

function love.load()
  requireAllInFolder('objects')
  --[[
    Exercise 18-20: 
      I have no gamepad, sorry.
  ]]--
  input = Input()
end

function love.update(dt)
  
end

function love.draw()
  local c = Circle(400, 300, 50)
  c:draw()
  local h = HyperCircle(400, 300, 50, 10, 120)
  h:draw()
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