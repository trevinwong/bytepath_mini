CinematicInfoText = Object:extend()

function CinematicInfoText:new(x, y, opts)
	local opts = opts or {}
	if opts then for k, v in pairs(opts) do self[k] = v end end
	self.timer = Timer()
	self.x = x
	self.y = y
	self.font = fonts["m5x7_16"]
	self.on_character = 1
	self.print_duration = 0.5 or opts.print_duration

	self.background_colors = {}
	self.foreground_colors = {}
	self.depth = 80
	self.characters = {}
	for i = 1, #self.text do table.insert(self.characters, self.text:utf8sub(i, i)) end
	self.visible = true
	
	local time_per_character = self.print_duration / #self.characters
	if self.print_character_by_character then
		self.timer:after(time_per_character, function(f)
				self.on_character = self.on_character + 1
				if self.on_character < #self.characters then self.timer:after(time_per_character, f) else
					self:garbleText()
					self.print_character_by_character = false
				end
			end)
	end
end

function CinematicInfoText:update(dt)
	self.timer:update(dt)
end

function CinematicInfoText:draw()
	if self.print_character_by_character then self:drawCharacterByCharacter() return end
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
		if i <= 19 then 
			love.graphics.setColor(self.foreground_colors[i] or skill_point_color)
		else 
			love.graphics.setColor(self.foreground_colors[i] or default_color)
		end
		love.graphics.print(self.characters[i], self.x + width, self.y)
	end
	love.graphics.setColor(default_color)
end

function CinematicInfoText:drawCharacterByCharacter()
	love.graphics.setColor(default_color)
	for i = 1, self.on_character do
		local width = 0
		if i > 1 then
			for j = 1, i-1 do
				width = width + self.font:getWidth(self.characters[j])
			end
		end
		if i <= 19 then 
			love.graphics.setColor(skill_point_color)
		else 
			love.graphics.setColor(default_color)
		end
		love.graphics.print(self.characters[i], self.x + width, self.y)
	end
end

function CinematicInfoText:garbleText()
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
	self.timer:after(1.10, function() self:destroy() end)
end

function CinematicInfoText:destroy()
    self.timer:destroy()
	self.dead = true
end