--[[
  Exercise 5:
    One problem we might run into with semi-fixed framerate is the fact that floats have limited precision. In other words, by splitting up our simulation into
    multiple time chunks of dt or less, we've already introduced some floating point error - when we add these chunks back up, we won't necessarily get the same
    result as if we were to simulate the whole big chunk!
  
    This is bad if we want exact reproducibility - which we might want for debugging and networking purposes, since our simulation might behave slightly differently
    from each run to the next. The only solution for this is to use a fixed frame rate, which brings us back to the start.

    So we need to decouple our simulation and rendering framerates. In other words, we advance our simulation by a fixed framerate, while also making sure that 
    it is keeping up with the renderer.
    
    As Gaffer on Games puts it, if our display framerate is 50fps, and our physics simulation is 100fps, we would have to take 2 physics steps per display update.
    If our display framerate is 200fps, and our physics simulation is 100fps, we would need to take 0.5 physics steps per display update - except we can only move in
    whole steps of dt, so we have to take 1 physics steps per 2 display updates.
    
    Of course, the whole thing gets way too complicated if our display and our physics framerates aren't nice multiples like these. So Gaffer on Games prefers to think 
    of it this way. The renderer produces time, and the simulation consumes in it discrete sized dt chunks.
    
    This is in fact the only way that this makes any sense to me - the renderer "accumulates" enough time by updating enough times, which then allows the simulation
    to proceed forwards by 1 step, thus getting the effect we want above of calculating how many physics steps we take per display update.
    
    Of course, be sure to note that we may have some unsimulated time left over after integrating - which is fine, since this is accumulated in the accumulator.
    This time is passed onto the next frame and is not thrown away, ensuring that our simulation does not fall behind by mistakenly throwing away time we should
    be simulating.
    
    One thing to be aware of though is that typically when rendering frames, we usually have some small amount of unsimulated time in the accumulator that is less than dt.
    This is of course reasonable to expect since there is no way that we would always get perfectly-sized chunks of dt to simulate. If this is the case however, this means
    that we are actually slightly behind when rendering our frames - we are simulating a state that is some value slightly less than dt behind.
    
    This causes temporal aliasing, which is a "subtle but visually unpleasant stuttering of the physics animation", as Gaffer on Games puts it. If we want to smooth this
    out, we can interpolate between the previous and current physics state based on how much time is left in the accumulator.
    
    Technically we'll be "1 frame behind" if we use this method (since we needed to see in the future to obtain our "next" frame) but this is fine since rendering
    is really just relative. As long as the frames shown on the screen are accurate with respect to eachother, no one will know that we technically have the full
    simulated state of our current frame to show.
--]]
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
  local accumulator = 0
	local dt = 0
  local fixed = 1/60
 
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
    accumulator = accumulator + dt
    
		-- Call update and draw
		if love.update then 
      while (accumulator - fixed > 0.0) do
        love.update(fixed)
        accumulator = accumulator - fixed
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