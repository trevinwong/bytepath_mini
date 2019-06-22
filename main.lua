--[[
  Exercise 9:
    The value will be 2. The increment function receives an argument called "self", because we want to pass the instance of the object that we are calling the function on.
    Otherwise, we won't be able to modify it's members.
    
    This argument can indeed be named something else. But you would then need to consistently use and define this argument, as opposed to using Lua's colon operator,
    which implicitly defines and adds the argument "self" for you.
    
    In this case, "self" represents the variable "counter_table".
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