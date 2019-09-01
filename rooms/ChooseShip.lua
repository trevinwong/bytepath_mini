ChooseShip = Object:extend()

function ChooseShip:new()
	self.timer = Timer()	
	self.font = fonts.m5x7_16
	self.main_canvas = love.graphics.newCanvas(gw, gh)

	self.w = 12
	self.half_w = gw/6
	self.box_x, self.box_y = gw/2, (self.half_w)
	local left_arrow_x, left_arrow_y = self.box_x - self.half_w - 12, self.box_y
	local right_arrow_x, right_arrow_y = self.box_x + self.half_w + 12, self.box_y

	self.available_ships = {"Fighter", "Brick", "Rocket", "Night", "Crystal", "Robo", "Freedom", "Stabbinator"}
	self.ships_locked_status = {Fighter = true, Brick = true, Rocket = true, Night = true, Crystal = true, Robo = true, Freedom = true, Stabbinator = true}
	self.selected_ship_index = 1
	self.selected_ship = self.available_ships[self.selected_ship_index]
	self.polygons = Ships[self.selected_ship]["generatePolygons"](self.w)
	self.go_button = Button(0, 0, {text = "GO!", w = self.font:getWidth("GO!") * 3, h = self.font:getHeight() + 3, center_justified = true, font = self.font, always_hot = true,
			click = function() GameData.last_selected_ship = self.selected_ship gotoRoom('Stage') end})
	local left_arrow_w, left_arrow_h = self.half_w/4, self.half_w/2
	self.left_arrow = Button(left_arrow_x - left_arrow_w, left_arrow_y - left_arrow_h/2, {w = left_arrow_w, h = left_arrow_h, 
			custom_draw = function() 
				pushTranslate(left_arrow_x, left_arrow_y)

				love.graphics.polygon('line', {0, -self.half_w/4, -self.half_w/4, 0, 0, self.half_w/4})
				love.graphics.pop()
			end,
			click = function()
				self.selected_ship_index = self.selected_ship_index - 1
				if self.selected_ship_index <= 0 then self.selected_ship_index = 1 end
				self:switchShip()
			end})
	local right_arrow_w, right_arrow_h = self.half_w/4, self.half_w/2
	self.right_arrow = Button(right_arrow_x + right_arrow_w, right_arrow_y - right_arrow_h/2, {w = right_arrow_w, h = right_arrow_h, 
			custom_draw = function() 
				pushTranslate(right_arrow_x, right_arrow_y)

				love.graphics.polygon('line', {0, -self.half_w/4, self.half_w/4, 0, 0, self.half_w/4})
				love.graphics.pop()
			end,
			click = function()
				self.selected_ship_index = self.selected_ship_index + 1
				if self.selected_ship_index > #self.available_ships then self.selected_ship_index = #self.available_ships end
				self:switchShip()
			end})
end

function ChooseShip:update(dt)
	self.timer:update(dt)
	self.go_button:update(dt)
	self.left_arrow:update(dt)
	self.right_arrow:update(dt)
end

function ChooseShip:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()

	-- Draw box
	local half_w = self.half_w
	local box_x, box_y = self.box_x, self.box_y
	pushTranslate(box_x, box_y)

	love.graphics.polygon('line', self:createCurvedRectangle(half_w))
	love.graphics.pop()

	-- Draw arrows
	self.left_arrow:draw()
	self.right_arrow:draw()

	-- Draw ship in box
	local ship_x, ship_y = box_x, box_y - 5
	pushRotate(ship_x, ship_y, -math.pi/2)
	for _, polygon in ipairs(self.polygons) do
		local points = M.map(polygon, function(v, k) 
				if k % 2 == 1 then 
					return (ship_x + v + random(-1, 1))
				else 
					return (ship_y + v + random(-1, 1))
				end 
			end)
		love.graphics.polygon('line', points)
	end
	love.graphics.pop()

	-- Draw title above
	love.graphics.print(self.selected_ship, box_x - self.font:getWidth(self.selected_ship)/2, box_y - self.w*2.5 - 6)

	-- Draw locked status below
	local ship_locked_status = self.ships_locked_status[self.selected_ship] and "LOCKED" or "UNLOCKED"
	love.graphics.print(ship_locked_status, box_x - self.font:getWidth(ship_locked_status)/2, box_y + self.w*2 - 7)

	-- Draw stats below box
	local ship_stats = Ships[self.selected_ship]["getDescription"]()
	local greatest_width = M.max(ship_stats, function(line) return self.font:getWidth(line) end)
	local ship_stats_block = ""
	for _, line in ipairs(ship_stats) do
		ship_stats_block = ship_stats_block .. "\n" .. line
	end
	love.graphics.print(ship_stats_block, box_x - greatest_width/2, box_y + half_w/2)

	-- Update go button placement
	local block_height = (#ship_stats + 1) * self.font:getHeight()
	self.go_button.x = box_x - self.go_button.w/2
	self.go_button.y = box_y + half_w/2 + block_height + 10
	self.go_button:draw()

	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode('alpha')
	love.graphics.setFont(self.font)
end

function ChooseShip:createCurvedRectangle(half_w)
	return {
		6*half_w/8, -half_w/2,
		7*half_w/8, -half_w/3,
		7*half_w/8, half_w/3,
		6*half_w/8, half_w/2,
		-6*half_w/8, half_w/2,
		-7*half_w/8, half_w/3,
		-7*half_w/8, -half_w/3,
		-6*half_w/8, -half_w/2
	}
end

function ChooseShip:switchShip()
	self.selected_ship = self.available_ships[self.selected_ship_index]
	self.polygons = Ships[self.selected_ship]["generatePolygons"](self.w)
end