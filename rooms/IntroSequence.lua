IntroSequence = Object:extend()

function IntroSequence:new()
	self.timer = Timer()
	self.font = fonts.m5x7_16
	self.main_canvas = love.graphics.newCanvas(gw, gh)

	self.first_part = true
	
	self.base_initializing_text = "root@your_phone: ~$ initializing BYTEPATH mini . . ."
	self.initializing_text = CinematicInfoText(gw/2 - self.font:getWidth(self.base_initializing_text)/2, gh/2 - self.font:getHeight()/2, {text = self.base_initializing_text, print_character_by_character = true})

	fade_in(0.5)
	self.timer:after(1, function() fade_out(1) end)
	self.timer:after(2, function() self.first_part = false fade_in(1) end)
end

function IntroSequence:update(dt)
	self.timer:update(dt)
	if not self.first_part then self.initializing_text:update(dt) end
	if self.initializing_text.dead then self:finish() end
end

function IntroSequence:draw()
	if self.initializing_text.dead then return end
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()

	if self.first_part then
		setColor(1, 1, 1, 1)
		local first_part_txt = "original game by adnzzzzZ"
		love.graphics.print(first_part_txt, gw/2 - self.font:getWidth(first_part_txt)/2, gh/2 - self.font:getHeight()/2)
	else
		setColor(1, 1, 1, 1)
		self.initializing_text:draw()
	end

	love.graphics.setCanvas()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode('alpha')

	love.graphics.setFont(self.font)
end

function IntroSequence:finish()
	self.timer:after(1, function()
			gotoRoom('SkillTree')
		end)
end

function IntroSequence:destroy()
end