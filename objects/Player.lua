require "objects/GameObject"

Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
	
	-- Multipliers
    self.hp_multiplier = 1
	self.ammo_multiplier = 1
	self.boost_multiplier = 1
    self.aspd_multiplier = Stat(1)
	self.mvspd_multiplier = Stat(1)
	self.pspd_multiplier = Stat(1)
	
	-- Flats
    self.flat_hp = 0
	self.flat_ammo = 0
	self.flat_boost = 0
	self.ammo_gain = 0
	
	-- Chances
    self.launch_homing_projectile_on_ammo_pickup_chance = 0
	self.regain_hp_on_ammo_pickup_chance = 0
	self.regain_hp_on_sp_pickup_chance = 0
	self.spawn_haste_area_on_hp_pickup_chance = 0
	self.spawn_haste_area_on_sp_pickup_chance = 0
    self.spawn_sp_on_cycle_chance = 0
    self.barrage_on_kill_chance = 0
	self.spawn_hp_on_cycle_chance = 0
	self.regain_hp_on_cycle_chance = 0
	self.regain_full_ammo_on_cycle_chance = 0
	self.change_attack_on_cycle_chance = 0
	self.spawn_haste_area_on_cycle_chance = 0
	self.barrage_on_cycle_chance = 0
	self.launch_homing_projectile_on_cycle_chance = 0
	self.regain_ammo_on_kill_chance = 0
	self.launch_homing_projectile_on_kill_chance = 0
	self.regain_boost_on_kill_chance = 0
	self.spawn_boost_on_kill_chance = 0
	self.gain_aspd_boost_on_kill_chance = 0	
	self.mvspd_boost_on_cycle_chance = 0
	self.pspd_boost_on_cycle_chance = 100
	
    -- Geometry
    self.x, self.y = x, y
    self.w, self.h = 12, 12
    
    -- Ship
    self.ship = "Robo"
    self.polygons = Ships[self.ship]["generatePolygons"](self.w)
    
    -- Physics
    self.r = 0
    self.rv = 1.66*math.pi
    self.v = 0
    self.base_max_v = 100
    self.max_v = self.base_max_v
    self.a = 100
    
    -- Boost
    self.max_boost = 100
    self.boost = self.max_boost
    self.can_boost = true
    self.boost_timer = 0
    self.boost_cooldown = 2
    
    -- Health
    self.max_hp = 100
    self.hp = self.max_hp

    -- Ammo
    self.max_ammo = 100
    self.ammo = self.max_ammo
    
    -- SP
    sp = 0
    max_sp = 999

    -- Collision
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setCollisionClass('Player')
    self.collider:setObject(self)

    -- Attacks
    self.shoot_timer = 0
    self.shoot_cooldown = 0.24
    self:setAttack('Homing')

    -- Test
    input:bind('f4', function() self:die() end)
    
    -- Cycle
	self.cycle_cooldown = 5
	self.cycle_timer = 0
    
    -- Trail
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

    -- treeToPlayer(self)
    self:setStats()
    self:generateChances()
end

function Player:setStats()
    self.max_hp = (self.max_hp + self.flat_hp)*self.hp_multiplier	
	self.max_ammo = (self.max_ammo + self.flat_ammo)*self.ammo_multiplier
	self.max_boost = (self.max_boost + self.flat_boost)*self.boost_multiplier
    self.hp = self.max_hp
	self.ammo = self.max_ammo
	self.boost = self.max_boost
end

function Player:update(dt)
    Player.super.update(self, dt)
    
    -- Collision
    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end
    
    if self.collider:enter('Collectable') then
        local collision_data = self.collider:getEnterCollisionData('Collectable')
        local object = collision_data.collider:getObject()
        object:die()
        if object:is(Ammo) then
            self:addAmmo(5 + self.ammo_gain)
			self:onAmmoPickup()
		    current_room.score = current_room.score + 50
        elseif object:is(Boost) then
            self:addBoost(25)        
			current_room.score = current_room.score + 150
        elseif object:is(HP) then
            self:addHP(25)
			self:onHPPickup()
        elseif object:is(SP) then
            self:addSP(1)
			self:onSPPickup()
		    current_room.score = current_room.score + 250
        elseif object:is(Attack) then
            self:setAttack(object.attack)
		    current_room.score = current_room.score + 500
        end
    end
    
    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()
        self:hit(-30)
    end
	
	-- Aspd
	if self.inside_haste_area then self.aspd_multiplier:increase(100) end
    if self.aspd_boosting then self.aspd_multiplier:increase(100) end
    self.aspd_multiplier:update(dt)
	
	-- Mvspd
    if self.mvspd_boosting then self.mvspd_multiplier:increase(50) end
    self.mvspd_multiplier:update(dt)
	
	-- Pspd
    if self.pspd_boosting then self.pspd_multiplier:increase(100) end
    self.pspd_multiplier:update(dt)
	
    -- Shoot
    self.shoot_timer = self.shoot_timer + dt
    if self.shoot_timer > self.shoot_cooldown/self.aspd_multiplier.value then
        self.shoot_timer = 0
        self:shoot()
    end
    
    -- Boost/Movement
    self.boost = math.min(self.boost + 10*dt, self.max_boost)
    self.boost_timer = self.boost_timer + dt
    if self.boost_timer > self.boost_cooldown then self.can_boost = true end
    
    self.max_v = self.base_max_v
    self.boosting = false
    if input:down('up') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.max_v = 1.5*self.base_max_v 
        self.boost = self.boost - 50*dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    if input:down('down') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.max_v = 0.5*self.base_max_v 
        self.boost = self.boost - 50*dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    self.trail_color = skill_point_color 
    if self.boosting then self.trail_color = boost_color end
    
    if input:down('left') then self.r = self.r - self.rv*dt end
    if input:down('right') then self.r = self.r + self.rv*dt end
    
    self.boost = math.min(self.boost + 10*dt, self.max_boost)
    self.v = math.min(self.v + self.a*dt, self.max_v) * self.mvspd_multiplier.value
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
	
	-- Cycle
	self.cycle_timer = self.cycle_timer + dt
	if self.cycle_timer >= self.cycle_cooldown then
		self:cycle()
		self.cycle_timer = 0
	end
end

function Player:draw()
    if self.invisible then return end
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
    self.area:addGameObject('ShootEffect', 
    self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {player = self, d = d})
    self.ammo = self.ammo - attacks[self.attack].ammo

    if self.attack == 'Neutral' then
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})
    elseif self.attack == 'Double' then
        self.area:addGameObject('Projectile', 
    	self.x + 1.5*d*math.cos(self.r + math.pi/12), 
    	self.y + 1.5*d*math.sin(self.r + math.pi/12), 
    	{r = self.r + math.pi/12, attack = self.attack})
        
        self.area:addGameObject('Projectile', 
    	self.x + 1.5*d*math.cos(self.r - math.pi/12),
    	self.y + 1.5*d*math.sin(self.r - math.pi/12), 
    	{r = self.r - math.pi/12, attack = self.attack})
    elseif self.attack == 'Triple' then
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})
    
        self.area:addGameObject('Projectile', 
    	self.x + 1.5*d*math.cos(self.r + math.pi/12), 
    	self.y + 1.5*d*math.sin(self.r + math.pi/12), 
    	{r = self.r + math.pi/12, attack = self.attack})
        
        self.area:addGameObject('Projectile', 
    	self.x + 1.5*d*math.cos(self.r - math.pi/12),
    	self.y + 1.5*d*math.sin(self.r - math.pi/12), 
    	{r = self.r - math.pi/12, attack = self.attack})       
    elseif self.attack == 'Rapid' then
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})
    elseif self.attack == 'Spread' then
        local t = love.math.random()
        local r = (t * (-math.pi/8)) + ((1-t) * (math.pi/8))
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r + r, attack = self.attack})
        attacks[self.attack].color = table.random(all_colors)
    elseif self.attack == 'Back' then
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})
    
        local back_r = self.r - math.pi
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(back_r), self.y + 1.5*d*math.sin(back_r), {r = back_r, attack = self.attack})
    elseif self.attack == 'Side' then
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})
    
        local side1_r = self.r - math.pi/2
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(side1_r), self.y + 1.5*d*math.sin(side1_r), {r = side1_r, attack = self.attack})
    
        local side2_r = self.r + math.pi/2
        self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(side2_r), self.y + 1.5*d*math.sin(side2_r), {r = side2_r, attack = self.attack})
    elseif self.attack == 'Homing' then
		local projectile = self.area:addGameObject('Projectile', 
      	self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack, s = 8})
	end
    
    if self.ammo <= 0 then 
        self:setAttack('Neutral')
        self.ammo = self.max_ammo
    end
end

function Player:die()
    self.dead = true 
    flash(0.075)
    camera:shake(6, 60, 0.4)
    slow(0.15, 1)

    for i = 1, love.math.random(8, 12) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y) 
  	end
	
	current_room:finish()
end

function Player:cycle()
    self:onCycle()
    self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:destroy()
   Player.super.destroy(self)
end

function Player:addAmmo(amount)
    if amount > 0 then
        self.ammo = math.min(self.ammo + amount, self.max_ammo)
    else
        self.ammo = math.max(self.ammo + amount, 0)
    end
end

function Player:addBoost(amount)
    if amount > 0 then
        self.boost = math.min(self.boost + amount, self.max_boost)
    else
        self.boost = math.max(self.boost + amount, 0)
    end
end

function Player:addHP(amount)
    if amount > 0 then
        self.hp = math.min(self.hp + amount, self.max_hp)
    else
        self.hp = math.max(self.hp + amount, 0)
    end
	
    if self.hp <= 0 then
        self:die()
    end
end

function Player:addSP(amount)
    if amount > 0 then
        sp = math.min(sp + amount, max_sp)
    else
        sp = math.max(sp + amount, 0)
    end    
end

function Player:setAttack(attack)
    self.attack = attack
    self.shoot_cooldown = attacks[attack].cooldown
    self.ammo = self.max_ammo
end

function Player:generateChances()
    self.chances = {}
    for k, v in pairs(self) do
        if k:find('_chance') and type(v) == 'number' then
      	    self.chances[k] = chanceList({true, math.ceil(v)}, {false, 100-math.ceil(v)})
      	end
    end
end

function Player:hit(damage)
    if self.invincible then return end
    local damage = damage or 10
    for i = 1, love.math.random(4, 8) do 
    	self.area:addGameObject('ExplodeParticle', self.x, self.y) 
    end
    self:addHP(damage)
    
    if damage <= -30 then
        self.invincible = true
        self.invisible = true
        self.timer:after(2, function()
                self.invincible = false
                self.invisible = false
            end)
        flash(0.05)
        camera:shake(6, 60, 0.2)
        slow(0.25, 0.5)
        self.timer:after(0.04, function(f)
                if self.invincible then
                    self.invisible = not self.invisible
                    self.timer:after(0.05, f)
                end
            end)
        self.timer:every(0.04, function(f)
                if self.invincible then
                    self.invisible = not self.invisible
                end
            end,
        18)
    else 
        flash(0.03)
        camera:shake(6, 60, 0.1)
        slow(0.75, 0.25) 
    end
end

function Player:onAmmoPickup()
    if self.chances.launch_homing_projectile_on_ammo_pickup_chance:next() then
        self:launchHomingProjectile()
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', w = self.w, h = self.h})
    end
	if self.chances.regain_hp_on_ammo_pickup_chance:next() then
		self:addHP(25)
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', w = self.w, h = self.h})
	end
end

function Player:onSPPickup()
	if self.chances.regain_hp_on_sp_pickup_chance:next() then
		self:addHP(25)
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', w = self.w, h = self.h})
	end
	if self.chances.spawn_haste_area_on_sp_pickup_chance:next() then
		self.area:addGameObject('HasteArea', self.x, self.y)
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', w = self.w, h = self.h})
	end
end

function Player:onHPPickup()
	if self.chances.spawn_haste_area_on_hp_pickup_chance:next() then
		self.area:addGameObject('HasteArea', self.x, self.y)
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', w = self.w, h = self.h})
	end
end

function Player:onCycle()
    if self.chances.spawn_sp_on_cycle_chance:next() then
        self.area:addGameObject('SP')
        self.area:addGameObject('InfoText', self.x, self.y, 
      	{text = 'SP Spawn!', color = skill_point_color, w = self.w, h = self.h})
    end
    if self.chances.spawn_hp_on_cycle_chance:next() then
        self.area:addGameObject('HP')
        self.area:addGameObject('InfoText', self.x, self.y, 
      	{text = 'HP Spawn!', color = hp_color, w = self.w, h = self.h})
    end
	if self.chances.regain_hp_on_cycle_chance:next() then
		self:addHP(25)
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', w = self.w, h = self.h})
	end
	if self.chances.regain_full_ammo_on_cycle_chance:next() then
		self.ammo = self.max_ammo
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'MAX Ammo Regain!', w = self.w, h = self.h})
	end
	if self.chances.change_attack_on_cycle_chance:next() then
		self:setAttack(selectRandomKey(attacks))
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'Change Attack!', w = self.w, h = self.h})
	end
	if self.chances.spawn_haste_area_on_cycle_chance:next() then
		self.area:addGameObject('HasteArea', self.x, self.y)
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', w = self.w, h = self.h})
	end
	if self.chances.barrage_on_cycle_chance:next() then
		self:barrage()
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Barrage!!!', w = self.w, h = self.h})
	end
    if self.chances.launch_homing_projectile_on_cycle_chance:next() then
        self:launchHomingProjectile()
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', w = self.w, h = self.h})
    end
    if self.chances.mvspd_boost_on_cycle_chance:next() then
        self.mvspd_boosting = true
        self.timer:after(4, function() self.mvspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, 
      	{text = 'MVSPD Boost!', color = boost_color, w = self.w, h = self.h})
    end
    if self.chances.pspd_boost_on_cycle_chance:next() then
        self.pspd_boosting = true
        self.timer:after(4, function() self.pspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, 
      	{text = 'PSPD Boost!', color = skill_point_color, w = self.w, h = self.h})
    end
end

function Player:onKill()
    if self.chances.barrage_on_kill_chance:next() then
		self:barrage()
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Barrage!!!', w = self.w, h = self.h})
    end
	if self.chances.regain_ammo_on_kill_chance:next() then
		self:addAmmo(20)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Regain Ammo!', w = self.w, h = self.h})
	end
	if self.chances.launch_homing_projectile_on_kill_chance:next() then
		self:launchHomingProjectile()
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', w = self.w, h = self.h})
	end
	if self.chances.regain_boost_on_kill_chance:next() then
		self:addBoost(40)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Regain Boost !', w = self.w, h = self.h})
	end
	if self.chances.spawn_boost_on_kill_chance:next() then
		self.area:addGameObject('Boost')
		self.area:addGameObject('InfoText', self.x, self.y, 
		{text = 'Boost Spawn!', color = boost_color, w = self.w, h = self.h})
	end
    if self.chances.gain_aspd_boost_on_kill_chance:next() then
        self.aspd_boosting = true
        self.timer:after(4, function() self.aspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, 
      	{text = 'ASPD Boost!', color = ammo_color, w = self.w, h = self.h})
    end
end

function Player:barrage()
	for i = 1, 8 do
		self.timer:after((i-1)*0.05, function()
			local random_angle = random(-math.pi/8, math.pi/8)
			local d = 2.2*self.w
			self.area:addGameObject('Projectile', 
			self.x + d*math.cos(self.r + random_angle), 
			self.y + d*math.sin(self.r + random_angle), 
			{r = self.r + random_angle, attack = self.attack})
		end)
	end
end

function Player:launchHomingProjectile()
	local d = 1.2*self.w
	self.area:addGameObject('Projectile', 
	self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), 
	{r = self.r, attack = 'Homing'})
end