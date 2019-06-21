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