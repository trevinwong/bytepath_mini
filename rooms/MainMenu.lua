MainMenu = Object:extend()

function MainMenu:new()
	self.timer = Timer()
	self.font = fonts.m5x7_16
	self.main_canvas = love.graphics.newCanvas(gw, gh)

	fade_in(1)
	local play_button_w, play_button_h  = self.font:getWidth("play") * 3, self.font:getHeight() + 3
	self.play_button = Button(gw/2 - play_button_w/2, gh/2 - play_button_h/2 - 25, {text = "play", w = play_button_w, h = play_button_h, center_justified = true, font = self.font, always_hot = true,
			click = function() gotoRoomPutOnStack("ChooseShip") end })
	
	local skills_button_w, skills_button_h  = self.font:getWidth("skills") * 3, self.font:getHeight() + 3
	self.skills_button = Button(gw/2 - skills_button_w/2, gh/2 - skills_button_h/2, {text = "skills", w = skills_button_w, h = skills_button_h, center_justified = true, font = self.font, always_hot = true,
			click = function() gotoRoomPutOnStack("SkillTree") end })

	local quit_button_w, quit_button_h = self.font:getWidth("quit") * 3, self.font:getHeight() + 3
	self.quit_button = Button(gw/2 - quit_button_w/2, gh/2 - quit_button_h/2 + 25, {text = "quit", w = quit_button_w, h = quit_button_h, center_justified = true, font = self.font, always_hot = true,
			click = function() love.event.quit() end })
end

function MainMenu:update(dt)
	if screen_alpha < 0.5 then return end
	self.timer:update(dt)
	self.play_button:update(dt)
	self.skills_button:update(dt)
	self.quit_button:update(dt)
end

function MainMenu:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	
	setColor(1, 1, 1, 1)
	self.play_button:draw()
	self.skills_button:draw()
	self.quit_button:draw()

	love.graphics.setCanvas()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode('alpha')

	love.graphics.setFont(self.font)
end

function MainMenu:finish()
end

function MainMenu:destroy()
end