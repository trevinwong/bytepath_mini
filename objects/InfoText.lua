require "objects/GameObject"

InfoText = GameObject:extend()

function InfoText:new(area, x, y, opts)
    InfoText.super.new(self, area, x, y, opts)
    self.font = fonts["m5x7_16"]
    
    self.x = self.x + -self.w + (love.math.random() * (2 * self.w))
    self.y = self.y + -self.h + (love.math.random() * (2 * self.h))

    self.background_colors = {}
    self.foreground_colors = {}
    self.depth = 80
    self.characters = {}
    for i = 1, #self.text do table.insert(self.characters, self.text:utf8sub(i, i)) end
    self.visible = true
    self.timer:after(0.70, function()
        self.timer:every(0.035, function()
            local random_characters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ'
            for i, character in ipairs(self.characters) do
                if love.math.random(1, 20) <= 1 then
                    local r = love.math.random(1, #random_characters)
                    self.characters[i] = random_characters:utf8sub(r, r)
                else
                    self.characters[i] = character
                end
                if love.math.random(1, 10) <= 1 then
                    self.background_colors[i] = table.random(all_colors)
                else
                    self.background_colors[i] = nil
                end
              
                if love.math.random(1, 10) <= 2 then
                    self.foreground_colors[i] = table.random(all_colors)
                else
                    self.background_colors[i] = nil
                end
            end
        end)
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
    end)
    self.timer:after(1.10, function() self.dead = true end)
end

function InfoText:update(dt)
    InfoText.super.update(self, dt)
end

function InfoText:draw()
    love.graphics.setFont(self.font)
    for i = 1, #self.characters do
        local width = 0
        if i > 1 then
            for j = 1, i-1 do
                width = width + self.font:getWidth(self.characters[j])
            end
        end

    	if self.background_colors[i] then
      	    love.graphics.setColor(self.background_colors[i])
      	    love.graphics.rectangle('fill', self.x + width, self.y - self.font:getHeight()/2,
      	    self.font:getWidth(self.characters[i]), self.font:getHeight())
      	end
    	love.graphics.setColor(self.foreground_colors[i] or self.color or default_color)
    	love.graphics.print(self.characters[i], self.x + width, self.y, 
      	0, 1, 1, 0, self.font:getHeight()/2)
    end
    love.graphics.setColor(default_color)
end

function InfoText:die()
    self.dead = true
    self.area:addGameObject('InfoTextEffect', self.x, self.y, 
    {color = InfoText_color, w = self.w * 1.5, h = self.h * 1.5})
    self.area:addGameObject('InfoText', self.x, self.y, {text = '+InfoText', color = InfoText_color})
end

function InfoText:destroy()
   InfoText.super.destroy(self) 
end