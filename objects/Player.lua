require "objects/GameObject"

Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.ship = "Robo"
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.r = 0
    self.rv = 1.66*math.pi
    self.v = 0
    self.base_max_v = 100
    self.max_v = self.base_max_v
    self.a = 100
    self.polygons = Ships[self.ship]["generatePolygons"](self.w)
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.timer:every(0.24, function()
        self:shoot()
    end)
    input:bind('f4', function() self:die() end)
    self.timer:every(5, function() self:tick() end)
    self.trail_color = skill_point_color 
    self.timer:every(0.01, function()
        if self.ship == "Fighter" then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
           self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
        elseif self.ship == "Brick" then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r), 
            self.y - 0.9*self.w*math.sin(self.r), 
            {parent = self, r = random(4, 5), d = random(0.15, 0.25), color = self.trail_color})            
        elseif self.ship == "Rocket" then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r), 
            self.y - 0.9*self.w*math.sin(self.r), 
            {parent = self, r = random(3, 4), d = random(0.15, 0.25), color = self.trail_color})            
        elseif self.ship == "Night" then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.4*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.4*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 3), d = random(0.15, 0.25), color = self.trail_color})      
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.4*self.w*math.cos(self.r + math.pi/2),  
            self.y - 0.9*self.w*math.sin(self.r) + 0.4*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 3), d = random(0.15, 0.25), color = self.trail_color})      
        elseif self.ship == "Crystal" then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r), 
            self.y - 0.9*self.w*math.sin(self.r), 
            {parent = self, r = random(3, 5), d = random(0.15, 0.25), color = self.trail_color})               
        elseif self.ship == "Robo" then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.5*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.5*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(3, 4), d = random(0.15, 0.25), color = self.trail_color})      
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.5*self.w*math.cos(self.r + math.pi/2),  
            self.y - 0.9*self.w*math.sin(self.r) + 0.5*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(3, 4), d = random(0.15, 0.25), color = self.trail_color})             
        elseif self.ship == "Freedom" then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
           self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})   
        elseif self.ship == "Stabbinator" then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.4*self.w*math.cos(self.r), 
            self.y - 0.4*self.w*math.sin(self.r), 
            {parent = self, r = random(4, 6), d = random(0.15, 0.25), color = self.trail_color})      
        end
    end)
end

function Player:update(dt)
    Player.super.update(self, dt)
    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end
    
    self.max_v = self.base_max_v
    self.boosting = false
    if input:down('up') then 
        self.boosting = true
        self.max_v = 1.5*self.base_max_v 
    end
    if input:down('down') then 
        self.boosting = true
        self.max_v = 0.5*self.base_max_v 
    end
    self.trail_color = skill_point_color 
    if self.boosting then self.trail_color = boost_color end
    
    if input:down('left') then self.r = self.r - self.rv*dt end
    if input:down('right') then self.r = self.r + self.rv*dt end
    

    self.v = math.min(self.v + self.a*dt, self.max_v)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Player:draw()
    pushRotate(self.x, self.y, self.r)
    love.graphics.setColor(default_color)
    for _, polygon in ipairs(self.polygons) do
        local points = M.map(polygon, function(v, k) 
        	if k % 2 == 1 then 
          		return self.x + v + random(-1, 1) 
        	else 
          		return self.y + v + random(-1, 1) 
        	end 
      	end)
        love.graphics.polygon('line', points)
    end
    love.graphics.pop()
end

function Player:shoot()
    local d = 1.2*self.w
    self.area:addGameObject('ShootEffect', self.x + 1.2*self.w*math.cos(self.r), self.y + 1.2*self.w*math.sin(self.r), {player = self, d = d})
    self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r})
end

function Player:die()
    self.dead = true 
    flash(0.075)
    camera:shake(6, 60, 0.4)
    slow(0.15, 1)

    for i = 1, love.math.random(8, 12) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y) 
  	end
end

function Player:tick()
    self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:destroy()
   Player.super.destroy(self)
end