Console = Object:extend()

function Console:new()
	self.timer = Timer()	
	self.lines = {}
	self.line_y = gh - 36
	self.font = fonts.m5x7_16
	-- Spawning a new camera avoids the weird shift as the camera is looking towards that location.
	camera = Camera(gw/2, gh/2)
	camera:lookAt(gw/2, gh/2)
	camera.smoother = Camera.smooth.damped(5)
	self.bottom_of_screen = gh
	self.main_canvas = love.graphics.newCanvas(gw, gh)
	self.base_input_text = {'[', skill_point_color, 'root', default_color, ']arch~ '}
	-- Note for this section: you'll need to set self.input_text to an empty table or it'll complain
	self.input_text = {}
	self.input_text_string = ""
	self.modules = {}
	self:addLine(0, {'test', boost_color, ' test'})
	input:bind('a', function() self:addLine(0, {'test', boost_color, ' test'}) end)
end

function Console:update(dt)
	self.timer:update(dt)
	for _, module in ipairs(self.modules) do  module:update(dt) end
	if self.inputting then
		-- Note for this section: you'll have to bind "return" and "backspace" accordingly or boipushy will complain about not being able to find mappings
		if input:pressed('return') then
			self.inputting = false
			if input_text == 'resolution' then
				table.insert(self.modules, ResolutionModule(self, self.line_y))
			end

			print(input_text)

			self.input_text = {}
		end
		-- Note for this section: the author seems to have renamed pressRepeat to down, instead
		if input:down('backspace', 0.02, 0.2) then 
			table.remove(self.input_text, #self.input_text) 
			self:updateText()
		end
	end
	self.cursor_visible = true
	self.timer:every('cursor', 0.5, function() 
			self.cursor_visible = not self.cursor_visible 
		end)
end

function Console:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach(0, 0, gw, gh)

	for _, line in ipairs(self.lines) do love.graphics.draw(line.text, line.x, line.y) end
	if self.inputting and self.cursor_visible then
		local r, g, b = unpack(default_color)
		love.graphics.setColor(r, g, b, 96)
		local input_text = ''
		for _, character in ipairs(self.input_text) do input_text = input_text .. character end
		local x = 8 + self.font:getWidth('[root]arch~ ' .. input_text)
		love.graphics.rectangle('fill', x, self.lines[#self.lines].y,
			self.font:getWidth('w'), self.font:getHeight())
		love.graphics.setColor(r, g, b, 255)
	end
	for _, module in ipairs(self.modules) do module:draw() end
	camera:detach()

	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode('alpha')
	love.graphics.setFont(self.font)
end

function Console:addLine(delay, text)
	self.timer:after(delay, function() 
			table.insert(self.lines, {x = 8, y = self.line_y, 
					text = love.graphics.newText(self.font, text)}) 
			self.line_y = self.line_y + 12
			if self.line_y + 12 > gh then camera:lookAt(camera.x, camera.y + 12) end 
		end)
end

function Console:textinput(t)
	if self.inputting then
		table.insert(self.input_text, t)
		self:updateText()
	end
end

function Console:updateText()
	local base_input_text = table.copy(self.base_input_text)
	input_text = ''
	for _, character in ipairs(self.input_text) do input_text = input_text .. character end
	table.insert(base_input_text, input_text)
	self.lines[#self.lines].text:set(base_input_text)
end

function Console:addInputLine(delay)
	self.timer:after(delay, function()
			table.insert(self.lines, {x = 8, y = self.line_y, 
					text = love.graphics.newText(self.font, self.base_input_text)})
			self.line_y = self.line_y + 12
			self.inputting = true
		end)
end