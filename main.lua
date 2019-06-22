--[[
  Exercise 14:
    This is a little hacky, but you could assign the corresponding key in the global table. For example, if we would set _G[Circle] = require(objects/Circle.lua).
    You would get the name through a substring.
]]--
Object = require 'libraries/classic/classic'

function love.load()
  requireAllInFolder('objects')
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