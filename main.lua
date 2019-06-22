--[[
  Exercise 11:
    No. Functions are first-class values in Lua, meaning they can be passed around and assigned just like regular data types for variables.
    If a class has a method with the name of "someMethod", we're essentially just assigning a function to the key "someMethod".
    We can't have an attribute with the same name since we would just be overriding whatever is assigned to the key "someMethod", in this case, the function.
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