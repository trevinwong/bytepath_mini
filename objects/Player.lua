require "objects/GameObject"

Player = GameObject:extend()

function Player:new(area, x, y, opts)
	Player.super.new(self, area, x, y, opts)

	-- Multipliers
	self.hp_multiplier = 1
	self.ammo_multiplier = 1
	self.boost_multiplier = 1
	self.hp_spawn_chance_multiplier = 1
	self.sp_spawn_chance_multiplier = 1
	self.boost_spawn_chance_multiplier = 1
	self.enemy_spawn_rate_multiplier = 1
	self.resource_spawn_rate_multiplier = 1
	self.attack_spawn_rate_multiplier = 1
	self.turn_rate_multiplier = 1
	self.boost_effectiveness_multiplier = 1
	self.projectile_size_multiplier = 1
	self.boost_recharge_rate_multiplier = 1
	self.invulnerability_time_multiplier = 1
	self.ammo_consumption_multiplier = 1
	self.size_multiplier = 1
	self.stat_boost_duration_multiplier = 1
	self.angle_change_frequency_multiplier = 1
	self.projectile_waviness_multiplier = 1
	self.projectile_acceleration_multiplier = 1
	self.projectile_deceleration_multiplier = 1
	self.projectile_duration_multiplier = 1
	self.area_multiplier = 1
	self.laser_width_multiplier = 1
	self.attack_spawn_chance_multipliers = {}

	for _, name in ipairs(attackNames) do
		self.attack_spawn_chance_multipliers[name .. "_spawn_chance_multiplier"] = 1
	end

	self.aspd_multiplier = Stat(1)
	self.mvspd_multiplier = Stat(1)
	self.pspd_multiplier = Stat(1)
	self.cycle_speed_multiplier = Stat(1)
	self.luck_multiplier = Stat(1)

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
	self.pspd_boost_on_cycle_chance = 0
	self.pspd_inhibit_on_cycle_chance = 0
	self.launch_homing_projectile_while_boosting_chance = 0
	self.drop_double_ammo_chance = 0
	self.attack_twice_chance = 0
	self.spawn_double_hp_chance = 0
	self.spawn_double_sp_chance = 0
	self.gain_double_sp_chance = 0
	self.shield_projectile_chance = 0
	self.split_projectiles_split_chance = 0

	-- Passives
	self.increased_cycle_speed_while_boosting = false
	self.invulnerability_while_boosting = false
	self.increased_luck_while_boosting = false
	self.projectile_ninety_degree_change = false
	self.projectile_random_degree_change = false
	self.wavy_projectiles = false
	self.fast_slow = false
	self.slow_fast = false
	self.additional_lightning_bolt = false
	self.increased_lightning_angle = false
	self.fixed_spin_attack_direction = false
	self.additional_bounce_projectiles = 0
	self.additional_homing_projectiles = 0
	self.additional_barrage_projectiles = 0

	self.start_with_attack_passives = {}

	for _, name in ipairs(attackNames) do
		self.start_with_attack_passives["start_with_" .. name] = false
	end

	-- Geometry
	self.x, self.y = x, y
	self.w, self.h = 12 * self.size_multiplier, 12 * self.size_multiplier

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
	local startingAttack = self:returnRandomStartingAttack()
	print(startingAttack)
	if startingAttack then self:setAttack(startingAttack) else self:setAttack("Neutral") end

	-- Test
	self.dont_move = false
	input:bind('f4', function() self.dont_move = true end)

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
					{parent = self, r = random(2, 4) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color}) 
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
					self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
					{parent = self, r = random(2, 4) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})
			elseif self.ship == "Brick" then
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r), 
					self.y - 0.9*self.w*math.sin(self.r), 
					{parent = self, r = random(4, 5) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})            
			elseif self.ship == "Rocket" then
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r), 
					self.y - 0.9*self.w*math.sin(self.r), 
					{parent = self, r = random(3, 4) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})            
			elseif self.ship == "Night" then
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r) + 0.4*self.w*math.cos(self.r - math.pi/2), 
					self.y - 0.9*self.w*math.sin(self.r) + 0.4*self.w*math.sin(self.r - math.pi/2), 
					{parent = self, r = random(2, 3) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})      
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r) + 0.4*self.w*math.cos(self.r + math.pi/2),  
					self.y - 0.9*self.w*math.sin(self.r) + 0.4*self.w*math.sin(self.r + math.pi/2), 
					{parent = self, r = random(2, 3) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})      
			elseif self.ship == "Crystal" then
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r), 
					self.y - 0.9*self.w*math.sin(self.r), 
					{parent = self, r = random(3, 5) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})               
			elseif self.ship == "Robo" then
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r) + 0.5*self.w*math.cos(self.r - math.pi/2), 
					self.y - 0.9*self.w*math.sin(self.r) + 0.5*self.w*math.sin(self.r - math.pi/2), 
					{parent = self, r = random(3, 4) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})      
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r) + 0.5*self.w*math.cos(self.r + math.pi/2),  
					self.y - 0.9*self.w*math.sin(self.r) + 0.5*self.w*math.sin(self.r + math.pi/2), 
					{parent = self, r = random(3, 4) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})             
			elseif self.ship == "Freedom" then
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
					self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
					{parent = self, r = random(2, 4) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color}) 
				self.area:addGameObject('TrailParticle', 
					self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
					self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
					{parent = self, r = random(2, 4) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})   
			elseif self.ship == "Stabbinator" then
				self.area:addGameObject('TrailParticle', 
					self.x - 0.4*self.w*math.cos(self.r), 
					self.y - 0.4*self.w*math.sin(self.r), 
					{parent = self, r = random(4, 6) * self.size_multiplier, d = random(0.15, 0.25), color = self.trail_color})      
			end
		end)

	-- Color
	self.color = default_color

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

	-- Passives

	-- Aspd
	if self.inside_haste_area then self.aspd_multiplier:increase(100) end
	if self.aspd_boosting then self.aspd_multiplier:increase(100) end
	self.aspd_multiplier:update(dt)

	-- Mvspd
	if self.mvspd_boosting then self.mvspd_multiplier:increase(50) end
	self.mvspd_multiplier:update(dt)

	-- Pspd
	if self.pspd_boosting then self.pspd_multiplier:increase(100) end
	if self.pspd_inhibiting then self.pspd_multiplier:decrease(100) end
	self.pspd_multiplier:update(dt)

	-- Cycle
	if self.cycle_boosting then self.cycle_speed_multiplier:increase(200) end
	self.cycle_speed_multiplier:update(dt)

	-- Luck
	if self.luck_boosting then 
		self.luck_multiplier:increase(200)
		self.luck_multiplier:update(dt)
		self:generateChances()
	end
	self.luck_multiplier:update(dt)

	-- Shoot
	self.shoot_timer = self.shoot_timer + dt
	if self.shoot_timer > self.shoot_cooldown/self.aspd_multiplier.value then
		self.shoot_timer = 0
		self:shoot()
		self:onShoot()
	end

	-- Boost/Movement
	self.boost = math.min(self.boost + 10*dt*self.boost_recharge_rate_multiplier, self.max_boost)
	self.boost_timer = self.boost_timer + dt
	if self.boost_timer > self.boost_cooldown then self.can_boost = true end

	self.max_v = self.base_max_v
	self.boosting = false

	if input:pressed('up') and self.boost > 1 and self.can_boost then self:onBoostStart() end
	if input:released('up') then self:onBoostEnd() end
	if input:down('up') and self.boost > 1 and self.can_boost then         
		self.boosting = true
		self.max_v = 1.5*self.base_max_v*self.boost_effectiveness_multiplier
		self.boost = self.boost - 50*dt
		if self.boost <= 1 then
			self.boosting = false
			self.can_boost = false
			self.boost_timer = 0
			self:onBoostEnd()
		end
	end
	if input:pressed('down') and self.boost > 1 and self.can_boost then self:onBoostStart() end
	if input:released('down') then self:onBoostEnd() end
	if input:down('down') and self.boost > 1 and self.can_boost then 
		self.boosting = true
		self.max_v = 0.5*self.base_max_v/self.boost_effectiveness_multiplier
		self.boost = self.boost - 50*dt
		if self.boost <= 1 then
			self.boosting = false
			self.can_boost = false
			self.boost_timer = 0
			self:onBoostEnd()
		end
	end
	self.trail_color = skill_point_color 
	if self.boosting then self.trail_color = boost_color end

	if input:down('left') then self.r = self.r - self.rv*self.turn_rate_multiplier*dt end
	if input:down('right') then self.r = self.r + self.rv*self.turn_rate_multiplier*dt end

	self.boost = math.min(self.boost + 10*dt, self.max_boost)
	self.v = math.min(self.v + self.a*dt, self.max_v) * self.mvspd_multiplier.value
	self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

	-- Cycle
	self.cycle_timer = self.cycle_timer + (dt * self.cycle_speed_multiplier.value)
	if self.cycle_timer >= self.cycle_cooldown then
		self:cycle()
		self.cycle_timer = 0
	end

	if self.dont_move then self.v = 0 end
end

function Player:draw()
	if self.invisible then return end

	pushRotate(self.x, self.y, self.r)
	love.graphics.setColor(self.color)
	for _, polygon in ipairs(self.polygons) do
		local points = M.map(polygon, function(v, k) 
				if k % 2 == 1 then 
					return (self.x + v + random(-1, 1))
				else 
					return (self.y + v + random(-1, 1))
				end 
			end)
		love.graphics.polygon('line', points)
	end
	love.graphics.pop()
end

function Player:shoot()
	local d = 1.2*self.w

	if self.attack == 'Laser' then
		self.area:addGameObject('LaserShootEffect', 
			self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {player = self, d = d, w = 25, fade_to_color = hp_color})
	else
		self.area:addGameObject('ShootEffect', 
			self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {player = self, d = d})
	end

	self.prev_ammo = self.ammo
	self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)

	local mods = {
		shield = self.chances.shield_projectile_chance:next()
	}

	if self.attack == 'Neutral' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))
	elseif self.attack == 'Double' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r + math.pi/12), 
			self.y + 1.5*d*math.sin(self.r + math.pi/12), 
			table.merge({r = self.r + math.pi/12, attack = self.attack}, mods))

		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r - math.pi/12),
			self.y + 1.5*d*math.sin(self.r - math.pi/12), 
			table.merge({r = self.r - math.pi/12, attack = self.attack}, mods))
	elseif self.attack == 'Triple' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r + math.pi/12), 
			self.y + 1.5*d*math.sin(self.r + math.pi/12), 
			table.merge({r = self.r + math.pi/12, attack = self.attack}, mods))

		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r - math.pi/12),
			self.y + 1.5*d*math.sin(self.r - math.pi/12), 
			table.merge({r = self.r - math.pi/12, attack = self.attack}, mods))       
	elseif self.attack == 'Rapid' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))
	elseif self.attack == 'Spread' then
		local t = love.math.random()
		local r = (t * (-math.pi/8)) + ((1-t) * (math.pi/8))
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r + r, attack = self.attack, color = table.random(all_colors)}, mods))
	elseif self.attack == 'Back' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

		local back_r = self.r - math.pi
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(back_r), self.y + 1.5*d*math.sin(back_r), table.merge({r = back_r, attack = self.attack}, mods))
	elseif self.attack == 'Side' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

		local side1_r = self.r - math.pi/2
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(side1_r), self.y + 1.5*d*math.sin(side1_r), table.merge({r = side1_r, attack = self.attack}, mods))

		local side2_r = self.r + math.pi/2
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(side2_r), self.y + 1.5*d*math.sin(side2_r), table.merge({r = side2_r, attack = self.attack}, mods))
	elseif self.attack == 'Homing' then
		local projectile = self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack, s = 4}, mods))
	elseif self.attack == 'Blast' then
		for i = 1, 12 do
			local random_angle = random(-math.pi/6, math.pi/6)
			self.area:addGameObject('Projectile', 
				self.x + 1.5*d*math.cos(self.r + random_angle), 
				self.y + 1.5*d*math.sin(self.r + random_angle), 
				table.merge({r = self.r + random_angle, attack = self.attack, 
						v = random(500, 600)}, mods))
		end
		camera:shake(4, 60, 0.4)
	elseif self.attack == 'Spin' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
			table.merge({r = self.r, attack = self.attack}, mods))
	elseif self.attack == 'Flame' then
		local random_angle = random(-math.pi/20, math.pi/20)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r + random_angle), self.y + 1.5*d*math.sin(self.r + random_angle), 
			table.merge({r = self.r + random_angle, attack = self.attack, v = random(250, 300), back_color = skill_point_color}, mods))
	elseif self.attack == 'Bounce' then
		local bounces = 4 + self.additional_bounce_projectiles
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
			table.merge({r = self.r, attack = self.attack, bounce = bounces, color = table.random(default_colors)}, mods))
	elseif self.attack == '2Split' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
			table.merge({r = self.r, attack = self.attack, s = 4}, mods))
	elseif self.attack == '4Split' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
			table.merge({r = self.r, attack = self.attack, s = 4}, mods))
	elseif self.attack == 'Lightning' then
		local x1, y1 = self.x + d*math.cos(self.r), self.y + d*math.sin(self.r)
		local cx, cy = x1 + 24*math.cos(self.r), y1 + 24*math.sin(self.r)
		if self.increased_lightning_angle then
			cx, cy = self.x, self.y
		end

		local nearby_enemies = self.area:getAllGameObjectsThat(function(e)
				for _, enemy in ipairs(enemies) do
					if e:is(_G[enemy]) and (distance(e.x, e.y, cx, cy) < 64 * self.area_multiplier) then
						return true
					end
				end
			end)

		table.sort(nearby_enemies, function(a, b) 
				return distance(a.x, a.y, cx, cy) < distance(b.x, b.y, cx, cy) 
			end)
		local closest_enemy = nearby_enemies[1]

		if closest_enemy then
			closest_enemy:hit()
			local x2, y2 = closest_enemy.x, closest_enemy.y
			self:spawnLightning(x1, y1, x2, y2, boost_color)

			if self.additional_lightning_bolt then
				local closest_enemy2 = nearby_enemies[2]
				if closest_enemy2 then
					closest_enemy2:hit()
					x2, y2 = closest_enemy2.x, closest_enemy2.y
					self:spawnLightning(self.x, self.y, x2, y2, hp_color)
					self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier) / 2
				end
			end
		else
			self.ammo = self.prev_ammo
		end
	elseif self.attack == 'Explode' then
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack, s = 5}, mods))
	elseif self.attack == 'Laser' then
		local x1, y1 = self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r) 
		local x2, y2 = self.x + 1024*math.cos(self.r), self.y + 1024*math.sin(self.r)
		self.area:addGameObject('Laser',
			x1, y1, {x2 = x2, y2 = y2, r = self.r, wm = self.laser_width_multiplier})
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
			self.chances[k] = chanceList(
				{true, math.ceil(v*self.luck_multiplier.value)}, 
				{false, 100-math.ceil(v*self.luck_multiplier.value)})
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
		self.timer:after(2 * self.invulnerability_time_multiplier, function()
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
	if self.chances.gain_double_sp_chance:next() then
		self:addSP(1)
		self.area:addGameObject('InfoText', self.x, self.y, {text = '+1 SP Gain!', color = skill_point_color, w = self.w, h = self.h})
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
		self:applyStatus(4, "mvspd_boosting")
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'MVSPD Boost!', color = boost_color, w = self.w, h = self.h})
	end
	if self.chances.pspd_boost_on_cycle_chance:next() then
		self:applyStatus(4, "pspd_boosting")
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'PSPD Boost!', color = skill_point_color, w = self.w, h = self.h})
	end
	if self.chances.pspd_inhibit_on_cycle_chance:next() then
		self:applyStatus(4, "pspd_inhibiting")
		self.timer:after(4, function() self.pspd_inhibiting = false end)
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'PSPD Inhibit!', color = skill_point_color, w = self.w, h = self.h})
	end

end

function Player:onKill(enemy_death_location)
	-- Enemies originally did not spawn Ammo upon death, so I added it.
	self.area:addGameObject('Ammo', unpack(enemy_death_location))
	if self.chances.drop_double_ammo_chance:next() then
		self.area:addGameObject('Ammo', unpack(enemy_death_location))
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'Double Ammo!', color = ammo_color, w = self.w, h = self.h})
	end
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

function Player:onShoot()
	if self.chances.attack_twice_chance:next() then
		self:shoot()
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'Double Attack!', w = self.w, h = self.h})
	end
end

function Player:onResourceSpawn(resource_name)
	if resource_name == 'HP' then
		if self.chances.spawn_double_hp_chance:next() then
			self.area:addGameObject('HP')
			self.area:addGameObject('InfoText', self.x, self.y, 
				{text = 'Double HP Spawn!', color = hp_color, w = self.w, h = self.h})
		end
	end
	if resource_name == 'SP' then
		if self.chances.spawn_double_sp_chance:next() then
			self.area:addGameObject('SP')
			self.area:addGameObject('InfoText', self.x, self.y, 
				{text = 'Double SP Spawn!', color = skill_point_color, w = self.w, h = self.h})
		end
	end
end

function Player:onBoostStart()
	self.timer:every('launch_homing_projectile_while_boosting_chance', 0.2, function()
			if self.chances.launch_homing_projectile_while_boosting_chance:next() then
				local d = 1.2*self.w
				self.area:addGameObject('Projectile', 
					self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), 
					{r = self.r, attack = 'Homing'})
				self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', w = self.w, h = self.h})
			end
		end)
	if self.increased_luck_while_boosting then 
		self.luck_boosting = true
	end
	if self.increased_cycle_speed_while_boosting then 
		self.cycle_boosting = true 
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'Cycle Boost!', w = self.w, h = self.h})
	end
	if self.invulnerability_while_boosting then 
		self.invincible = true 
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'Invincible!', w = self.w, h = self.h})
	end
end

function Player:onBoostEnd()
	self.timer:cancel('launch_homing_projectile_while_boosting_chance')
	if self.increased_cycle_speed_while_boosting then self.cycle_boosting = false end
	if self.invulnerability_while_boosting then self.invincible = false end
end

function Player:barrage()
	for i = 1, 8 + self.additional_barrage_projectiles do
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
	for i = 1, 1+self.additional_homing_projectiles do
		self.area:addGameObject('Projectile', 
			self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), 
			{r = self.r, attack = 'Homing'})
	end
end

function Player:spawnLightning(x1, y1, x2, y2, color)
	self.area:addGameObject('LightningLine', 0, 0, {start_point = Vector(x1, y1), end_point = Vector(x2, y2), color = color})
	for i = 1, love.math.random(4, 8) do 
		self.area:addGameObject('ExplodeParticle', x1, y1, 
			{color = table.random({default_color, boost_color})}) 
	end
	for i = 1, love.math.random(4, 8) do 
		self.area:addGameObject('ExplodeParticle', x2, y2, 
			{color = table.random({default_color, boost_color})}) 
	end
end

function Player:applyStatus(base_seconds, name)
	self[name] = true
	self.timer:after(base_seconds * self.stat_boost_duration_multiplier, function() 
			self[name] = false
		end)
end

function Player:returnRandomStartingAttack()
	local start_withs = {}
	for attackName, bool in pairs(self.start_with_attack_passives) do
		if bool then table.insert(start_withs, attackName) end
	end
	if #start_withs == 0 then return false else return string.sub(start_withs[love.math.random(1, #start_withs)], string.len("start_with_") + 1) end
end