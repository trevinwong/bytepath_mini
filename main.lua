--[[
  Exercise 13:
    Sadly, there is no guarantee. The official LOVE2D documentation for "getDirectoryItems" states that the items in the folder are returned in no order.
    Meaning, we could process "SomeClass" before "ParentClass".
    
    What we could do is include the proper requires for all the class' dependencies in the file itself. Unfortunately, this is a little redundant, since 
    we would have to do this for every single class, as opposed to just writing out our requires in the proper order in main.
    
    Another idea is to construct a dependency graph to ensure that we are loading the right files beforehand, but that may be something a little farther in the future
    for me to look into.
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