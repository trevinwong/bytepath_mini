require "objects/GameObject"

Circle = GameObject:extend()

--[[
  Exercise 48:
    OOP is a bit tricky if you don't know how it actually works in Lua. The way it's implemented is through metatables and the __index metamethod, which is incredibly
    confusing if it's your first time.

    The important thing to remember here is that we're always operating on "self" - but what is "self"? In Java, we assume it to be the object that we're creating, but
    in Lua, this is actually the receiver of the operation. In new(), it'll be our new anonymous table.
    
    Hence, we can't actually call self.super() in new(), because super hasn't been assigned to our new anonymous table. Rather, it's assigned to our global object
    (which we refer to as our class). So we have to call "Circle.super".
    
    The other gotcha is that we have to use the period notation here and pass in "self" instead of the colon notation - if we call Circle.super:new(), we're actually
    passing in Circle.super as the "self" argument for new(), and we'll be assigning all the properties to our superclass' table. We have to make sure we're properly
    passing in our anonymous table.
    
    So the below is the proper way to call your superclass' method.
]]--

function Circle:new(area, x, y, opts)
  Circle.super.new(self, area, x, y, opts)
  --[[
    Exercise 48:
      Remember how, in Exercise 25, we couldn't simulate the "every" functionality using the "after" functionality for timers, thanks to our usage of Chrono?
      Well, it seems like the opposite has occured. hump.timer has no functionality for random delays, whereas Chrono does. The humanity.
      
      In the near future, I may look into fixing this for Chrono/EnhancedTimer. For now, we're using a fixed delay.
  ]]--
  self.timer:after(4, function() self.dead = true end)
end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end