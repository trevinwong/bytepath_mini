Node = Object:extend()

function Node:new(id, x, y, cost, opts)
	local opts = opts or {}
	if opts then for k, v in pairs(opts) do self[k] = v end end
	self.id = id
	self.cost = cost
	self.selected = false
	self.bought = false
	self.x, self.y = x, y
	self.w = 16
	self.h = self.w
end

function Node:update(dt)
	if self.no_description then return end
	-- TO-DO: Is our hump.camera modified from the original? We have different syntax than the call
	local mx, my = camera:getMousePosition(sx*camera.scale, sy*camera.scale, 0, 0, sx*gw, sy*gh)
	if mx >= self.x - self.w/2 and mx <= self.x + self.w/2 and 
	my >= self.y - self.h/2 and my <= self.y + self.h/2 then 
		self.hot = true
	else self.hot = false end
	
	if self.hot and input:pressed('left_click') then
        if current_room:canNodeBeBought(self.id) then
            if not M.any(bought_node_indexes, self.id) then
				sp = sp - self.cost
				selected_sp = selected_sp + self.cost
				self.selected = true
                table.insert(selected_node_indexes, self.id)
            end
        end
    end

	if M.any(bought_node_indexes, self.id) then self.bought = true
	else self.bought = false end
end

function Node:draw()
    local r, g, b = unpack(default_color)
    love.graphics.setColor(background_color)
	draft:rhombus(self.x, self.y, self.w, self.h, 'fill')
    if self.bought or self.selected then love.graphics.setColor(r, g, b, 255/255)
    else love.graphics.setColor(r, g, b, 32/255) end
	draft:rhombus(self.x, self.y, self.w, self.h, 'line')	
    love.graphics.setColor(r, g, b, 255)
end