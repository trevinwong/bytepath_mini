--[[
  Exercise 4:
    Since we know that large dt can blow up our game, we want to cap it to some maximum.
    This can give us the best of both worlds - allowing us to run at the correct speed on different machines while not being susceptible to blowing up.
    
    How should we do this? If our dt is bigger than our desired frame rate (i.e 1/60), we split it into chunks that are max as big as our desired frame rate,
    and simulate those chunks instead of simulating one huge chunk all at once.
    
    Here's the problem - we're now simulating multiple physics steps per display update. If our physics simulation is the most expensive part of rendering our frame,
    we will run into the "spiral of death" problem.
    
    What is this problem and how is it caused exactly? Well, the CPU only has a certain amount of time to simulate the physics before the next frame. What happens if we
    tell the CPU to simulate so many steps that it doesn't even have enough time to simulate all of them before the next frame? Thus the simulation falls behind.
    We run into the "spiral of death" here because the CPU has to simulate more frames to catch up, which causes it to fall further behind, causing it to
    simulate more frames, and so on.
    
    Some suggestions to avoid this: make sure your simulation runs very very fast, so it can handle temporary lag spikes where it needs to simulate a lot of frames,
    or, cap the number of simulation steps per frame. The simulation will appear to slow down (we haven't simulated enough state!) but at least it will not die.
--]]
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
  local cap = 1/60
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
		if love.update then 
      while (dt > 0.0) do
        local deltaTime = min(cap, dt)
        love.update(deltaTime)
        dt = dt - deltaTime
      end
    end -- will pass 0 if love.timer is disabled
 
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