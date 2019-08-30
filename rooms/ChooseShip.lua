ChooseShip = Object:extend()

--[[
	TO-DO:
		- Draw an empty box in the middle. DONE!
		- Draw a ship in the middle. DONE!
		- Draw arrows on the side.
		- Draw title of the current ship
		- Draw status of ship (unlocked or locked)
		- Draw stats
		- Clicking left or right arrow changes your current ship (circular array)
		- Clicking go starts the game with ur current ship
]]--

function ChooseShip:new()
	self.timer = Timer()	
	self.font = fonts.m5x7_16
	self.main_canvas = love.graphics.newCanvas(gw, gh)
	
	self.w = 12
	self.ship = "Fighter"
	self.polygons = Ships[self.ship]["generatePolygons"](self.w)
end

function ChooseShip:update(dt)
	self.timer:update(dt)

end

function ChooseShip:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()

	-- Draw box
	local half_w = gw/6
	local box_x, box_y = gw/2, (half_w)
	pushTranslate(box_x, box_y)

	love.graphics.polygon('line', self:createCurvedRectangle(half_w))
	love.graphics.pop()
	
	-- Draw ship in box
	local ship_x, ship_y = box_x + self.w/2, box_y
	pushTranslate(ship_x, ship_y)
	pushRotate(ship_x, ship_y, 0)
	for _, polygon in ipairs(self.polygons) do
		local points = M.map(polygon, function(v, k) 
				if k % 2 == 1 then 
					return (v + random(-1, 1))
				else 
					return (v + random(-1, 1))
				end 
			end)
		love.graphics.polygon('line', points)
	end
	love.graphics.pop()
	love.graphics.pop()


	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode('alpha')
	love.graphics.setFont(self.font)
end

function ChooseShip:createCurvedRectangle(half_w)
	return {
		7*half_w/8, -half_w/2,
		half_w, -half_w/3,
		half_w, half_w/3,
		7*half_w/8, half_w/2,
		-7*half_w/8, half_w/2,
		-half_w, half_w/3,
		-half_w, -half_w/3,
		-7*half_w/8, -half_w/2
	}
end