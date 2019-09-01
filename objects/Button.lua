Button = Object:extend()

function Button:new(x, y, opts)
	local opts = opts or {}
	if opts then for k, v in pairs(opts) do self[k] = v end end
	self.x, self.y = x, y
end

function Button:update()
	-- Note: love.mouse.getPosition() gets the actual world/transformed position of the mouse (while we're still calculating our coordinates based on our original resolution)
	local mx, my = love.mouse.getPosition()
	mx = mx / sx
	my = my / sy
	if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
		self.hot = true
	else
		self.hot = false
	end
	
	if self.hot and input:pressed('left_click') then
		self.click(self.click_args)
	end
end

function Button:draw()
	if self.custom_draw then self.custom_draw() return end
	setColor(0, 0, 0, 1)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	if self.hot or self.always_hot then
		setColor(1, 1, 1, 1)
		love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
	end
	if self.text then
		setColor(1, 1, 1, 1)
		if self.center_justified then
			love.graphics.print(self.text, self.x + self.w/2 - self.font:getWidth(self.text)/2, self.y + self.h/2 - self.font:getHeight(self.text)/1.6)
		end
	end

	setColor(1, 1, 1, 1)
end