io.stdout:setvbuf("no")
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/EnhancedTimer/EnhancedTimer'

function love.load()
  requireAllInFolder('objects')
  input = Input()
  timer = Timer()
  
  --[[
    Exercise 27:
      This is a neat little exercise that takes advantage of the fact that all global variables are put in a global table.
      Why does this work? The "tween" function looks in the source table and attempts to tween all values that match in the target table.
      
      In this case, we simply pass the global table as the source table. "a" matches in the target table, so it tweens "a".
  ]]--
  a = 10
  timer:tween(1, _G, {a = 20}, 'linear')
end

function love.update(dt)
  timer:update(dt)
  print(a)
end

function love.draw()
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