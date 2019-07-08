require "objects/GameObject"

Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.r = -math.pi/6
    self.rv = 1.66*math.pi
    self.v = 0
    self.max_v = 100
    self.a = 100
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.timer:every(0.24, function()
        self:shoot()
    end)
end

function Player:update(dt)
    Player.super.update(self, dt)
    if input:down('left') then self.r = self.r - self.rv*dt end
    if input:down('right') then self.r = self.r + self.rv*dt end

    self.v = math.min(self.v + self.a*dt, self.max_v)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end

function Player:shoot()
    --[[
        Exercise 88:
            This one was fairly difficult, to be honest. It requires a bit of math. Basically, the effect we want is to have two other projectiles spawn beside our main
            projectile, 8 pixels apart.
            
            Notice that these projectiles all sit on a perpendicular line. We can calculate the slope of this perpendicular line by taking advantage of the
            fact that (slope * perpendicular_slope) = -1.
            
            First, though, we'll have to take care of two special cases: vertical and horizontal lines.
            If we have a vertical line, we can simply set our offset_x to be 8, and not touch our offset_y, since the perpendicular line will be horizontal.
            If we have a horizontal line, we can simply set our offset_y to be 8, and not touch our offset_x, since the perpendicular line will be vertical.
            
            For the other cases, we'll need to calculate the slope.
            To calculate the slope, we can simply use the two points we know, which is our player origin and the point where the projectile spawns.
            We can then find the perpendicular_slope from that.
            
            Next comes the slightly tricky part. Basically, we have two unknowns, which is the x and y of our point that we want to spawn our extra projectile at.
            And, we also want to enforce the consraint that the distance between our main projectile and our side projectiles is 8.
            
            We can do that by observing that our point follows this equation by enforcing our constraint: x^2 + y^2 = 8^2
            And we can also observe that our point's y can be calculated like so: y = m * x, where m = our perpendicular slope.
            
            If we do a little algebra, we eventually end up with x = sqrt(8^2/(m^2 + 1)), which is what you see below.
            We can then plug this back into our second equation and calculate our y.
    ]]--
    
    local d = 1.2*self.w
    self.area:addGameObject('ShootEffect', self.x + 1.2*self.w*math.cos(self.r), self.y + 1.2*self.w*math.sin(self.r), {player = self, d = d})
    local pt1 = {x = self.x, y = self.y}
    local pt2 = {x = self.x + 1.5*d*math.cos(self.r), y = self.y + 1.5*d*math.sin(self.r)}
    local dist = 8
    if (pt1.x == pt2.x) then
        -- vertical line
        offset_x = dist
    elseif (pt1.y == pt2.y) then
        -- horizontal line
        offset_y = dist
    else
        local slope = (pt2.y - pt1.y) / (pt2.x - pt1.x)
        local perpendicular_slope = -1 / slope
        offset_x = math.sqrt(math.pow(dist, 2)/(math.pow(perpendicular_slope, 2) + 1))
        offset_y = perpendicular_slope * offset_x
    end
    
    
    self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r})
    self.area:addGameObject('Projectile', pt2.x + offset_x, pt2.y + offset_y, {r = self.r})
    self.area:addGameObject('Projectile', pt2.x - offset_x, pt2.y - offset_y, {r = self.r})
end