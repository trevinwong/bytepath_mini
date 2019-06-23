io.stdout:setvbuf("no")
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'

function love.load()
  requireAllInFolder('objects')
    --[[
    Exercise 16:
      I don't have a keypad on my laptop so I used mouse1 instead.
  ]]--
  input = Input()
  input:bind('mouse1', 'add')
  sum = 0
end

function love.update(dt)
  if input:down('add', 0.25) then 
    sum = sum + 1
    print(sum)
  end
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