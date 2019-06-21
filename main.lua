--[[
  Exercise 3:
    We return back to the original love.run() function which implements variable timestep.
    In other words, we simply simulate as much state as the time passed since the last frame. 
    
    There are some side-effects though: we are susceptible to extremely large changes of state if we are lagging really badly, which is not good, since our
    dt will be massive. This can cause physics simulations to blow up.
--]]
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end
 
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
 
			if love.draw then love.draw() end
 
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end
end

function love.load()
  --[[
  Exercise 1:
    Vsync is an option that caps your frame rate to your monitor's refresh rate, essentially by forcing the GPU to wait to draw the next frame to the screen
    until the monitor is ready to refresh.
    This can be useful if you are experiencing any weird looking screen tearing or artifacts on your screen.
    
    Why might this happen? Consider a case when your monitor is refreshing to display the next frame.
    If the game is too fast, it might have already begun drawing the frame after the next frame to the screen, causing you to see 
    part of the next frame, and part of the frame after that.
  ]]--
  love.window.setMode(640, 480, {vsync = false}) 
end

function love.update(dt)

end

function love.draw()

end