Node = Object:extend()

function Node:new(id, x, y, cost, opts)
	local opts = opts or {}
	if opts then for k, v in pairs(opts) do self[k] = v end end
	self.font = fonts.Anonymous_8
	self.id = id
	self.cost = cost
	self.selected = false
	self.bought = false
	local r, g, b = unpack(default_color)
	self.color = {r, g, b, 32/255}
	self.types = tree[self.id].types
	self.colors = {}
	for _, t in ipairs(self.types) do table.insert(self.colors, types[t][2]) end
	local text = ''
	for _, t in ipairs(self.types) do text = text .. types[t][1] end
	self.tw = self.font:getWidth(text)
	local text = {}
	for _, t in ipairs(self.types) do table.insert(text, types[t][2]); table.insert(text, types[t][1]) end
	self.text = love.graphics.newText(self.font, text)
	self.x, self.y = x, y
	self.w = 16
	self.h = self.w
end

function Node:update(dt)
	local cx, cy = camera:getCameraCoords(self.x, self.y, 0, 0, gw, gh)
	if cx < -40 or cx > gw + 40 then return end
	if cy < -40 or cy > gh + 40 then return end

	if M.any(bought_node_indexes, self.id) then self.bought = true else self.bought = false end

	local r, g, b = unpack(default_color)
	if self.bought or self.selected then self.color = {r, g, b, 255/255}
	else self.color = {r, g, b, 32/255} end

	if self.no_description then return end
	-- TO-DO: Is our hump.camera modified from the original? We have different syntax than the call
	local mx, my = camera:getMousePosition(sx*camera.scale, sy*camera.scale, 0, 0, sx*gw, sy*gh)
	if self.size == 1 then
		if mx >= self.x - 8 and mx <= self.x + 8 and my >= self.y - 8 and my <= self.y + 8 then self.hot = true
		else self.hot = false end
	elseif self.size == 2 then
		if mx >= self.x - 16 and mx <= self.x + 16 and my >= self.y - 16 and my <= self.y + 16 then self.hot = true
		else self.hot = false end
	elseif self.size == 3 then
		if mx >= self.x - 24 and mx <= self.x + 24 and my >= self.y - 24 and my <= self.y + 24 then self.hot = true
		else self.hot = false end
	end

	if self.hot and input:pressed('left_click') then
		if current_room:canNodeBeBought(self.id) then
			if not M.any(bought_node_indexes, self.id) and not M.any(selected_node_indexes, self.id) then
				playMenuClick()
				sp = sp - cost[tree[self.id].size]
				selected_sp = selected_sp + cost[tree[self.id].size]
				self.selected = true
				table.insert(selected_node_indexes, self.id)
			end
		end
	end


end

function Node:draw()
	local cx, cy = camera:getCameraCoords(self.x, self.y, 0, 0, gw, gh)
	if cx < -40 or cx > gw + 40 then return end
	if cy < -40 or cy > gh + 40 then return end

	if self.size == 1 then
		love.graphics.setColor(background_color)
		love.graphics.rectangle('fill', self.x - 8, self.y - 8, 16, 16)
		love.graphics.setLineWidth(1/camera.scale)
		love.graphics.setColor(self.color)
		love.graphics.rectangle('line', self.x - 8, self.y - 8, 16, 16)
		local r, g, b = unpack(default_color)
		love.graphics.setColor(r, g, b, 48)
		if self.can_be_bought then love.graphics.rectangle('line', self.x - 6, self.y - 6, 12, 12) end
		love.graphics.setColor(r, g, b, 255)
		love.graphics.setLineWidth(1)
		love.graphics.draw(self.text, math.floor(self.x - self.tw/2), math.floor(self.y), 0, 1, 1, 0, math.floor(self.font:getHeight()/2))
		-- love.graphics.print(self.id, self.x + 8, self.y - 16)
	elseif self.size == 2 then
		love.graphics.setColor(background_color)
		love.graphics.rectangle('fill', self.x - 16, self.y - 16, 32, 32)
		love.graphics.setColor(self.color)
		love.graphics.setLineWidth(2/camera.scale)
		love.graphics.rectangle('line', self.x - 16, self.y - 16, 32, 32)
		love.graphics.setLineWidth(1/camera.scale)
		local r, g, b = unpack(default_color)
		love.graphics.setColor(r, g, b, 48)
		if self.can_be_bought then love.graphics.rectangle('line', self.x - 12, self.y - 12, 25, 25) end
		love.graphics.setColor(r, g, b, 255)
		love.graphics.setLineWidth(1)
		love.graphics.draw(self.text, math.floor(self.x - self.tw/2), math.floor(self.y), 0, 1, 1, 0, math.floor(self.font:getHeight()/2))
		-- love.graphics.print(self.id, self.x + 16, self.y - 16)
	elseif self.size == 3 then
		love.graphics.setColor(background_color)
		love.graphics.rectangle('fill', self.x - 24, self.y - 24, 48, 48)
		love.graphics.setColor(self.color)
		love.graphics.setLineWidth(2.5/camera.scale)
		love.graphics.rectangle('line', self.x - 24, self.y - 24, 48, 48)
		love.graphics.setLineWidth(1/camera.scale)
		love.graphics.setColor(default_color)
		local r, g, b = unpack(default_color)
		love.graphics.setColor(r, g, b, 48)
		if self.can_be_bought then love.graphics.rectangle('line', self.x - 20, self.y - 20, 41, 41) end
		love.graphics.setColor(r, g, b, 255)
		love.graphics.setLineWidth(1)
		love.graphics.draw(self.text, math.floor(self.x - self.tw/2), math.floor(self.y), 0, 1, 1, 0, math.floor(self.font:getHeight()/2))
		-- love.graphics.print(self.id, self.x + 24, self.y - 16)
	end
	love.graphics.setColor(255, 255, 255, 255)
end