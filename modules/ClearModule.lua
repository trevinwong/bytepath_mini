ClearModule = Object:extend()

function ClearModule:new(console, y)
	self.console = console
	self.y = y

	self.console:addLine(0.02, 'Clear Save Data?')
	self.console:addLine(0.04, '    Yes')
	self.console:addLine(0.06, '    No')

	self.selection_index = 1
	self.selection_widths = {
		self.console.font:getWidth('Yes'), self.console.font:getWidth('No')
	}

	self.console.timer:after(0.02 + self.selection_index*0.02, function() 
			self.active = true 
		end)
end

function ClearModule:update(dt)
	if not self.active then return end
	if input:pressed('up') then
		self.selection_index = self.selection_index - 1
		if self.selection_index < 1 then self.selection_index = #self.selection_widths end
	end

	if input:pressed('down') then
		self.selection_index = self.selection_index + 1
		if self.selection_index > #self.selection_widths then self.selection_index = 1 end
	end

	if input:pressed('return') then
		if selection_index == 1 then
			-- Clear data here.
		end
		self.active = false
		self.console:addLine(0.02, '')
		self.console:addInputLine(0.04)
	end
end

function ClearModule:draw()
	if not self.active then return end
	local width = self.selection_widths[self.selection_index]
	local r, g, b = unpack(default_color)
	love.graphics.setColor(r, g, b, 96)
	local x_offset = self.console.font:getWidth('    ')
	love.graphics.rectangle('line', 8 + x_offset - 2, self.y + self.selection_index*12, 
		width + 4, self.console.font:getHeight())
	love.graphics.setColor(r, g, b, 255)
end