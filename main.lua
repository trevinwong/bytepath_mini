io.stdout:setvbuf("no")
Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'

function love.load()
  requireAllInFolder('objects')
    --[[
    Exercise 17:
      Multiple keys can indeed be bound to the same action. The whole point of actions is to act as an alias for these inputs - so we don't have to care where
      the input is coming from.
      
      Multiple actions can indeed be bound to the same key. I imagine how this is done is that each action registered to the key simply gets a "yes, I'm being triggered"
      input.
  ]]--
  input = Input()
  input:bind('mouse1', 'add')
  input:bind('mouse1', 'cry')
  input:bind('mouse2', 'add')
  sum = 0
end

function love.update(dt)
  if input:down('add', 0.25) then 
    sum = sum + 1
    print(sum)
  end
  if input:pressed('cry') then print('cry') end
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