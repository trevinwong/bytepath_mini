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
	self.projectile_angle_change_frequency_multiplier = 1
	self.projectile_waviness_multiplier = 1
	self.projectile_acceleration_multiplier = 1
	self.projectile_deceleration_multiplier = 1
	self.projectile_duration_multiplier = 1
	self.item_spawn_rate_multiplier = 1
	self.area_multiplier = 1
	self.laser_width_multiplier = 1
	self.energy_shield_recharge_amount_multiplier = 1
	self.energy_shield_recharge_cooldown_multiplier = 1
	self.lightning_trigger_distance_multiplier = 1

	self.aspd_multiplier = Stat(1)
	self.mvspd_multiplier = Stat(1)
	self.pspd_multiplier = Stat(1)
	self.cycle_multiplier = Stat(1)
	self.luck_multiplier = Stat(1)

	-- Flats
	self.flat_hp = 0
	self.flat_ammo = 0
	self.flat_boost = 0
	self.ammo_gain = 0

	-- Chances
	self.launch_homing_projectile_on_item_pickup_chance = 0
	self.regain_hp_on_item_pickup_chance = 0
	self.regain_hp_on_sp_pickup_chance = 0
	self.spawn_haste_area_on_hp_pickup_chance = 0
	self.spawn_haste_area_on_sp_pickup_chance = 0
	self.spawn_haste_area_on_item_pickup_chance = 0
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
	self.gain_mvspd_boost_on_cycle_chance = 0
	self.gain_pspd_boost_on_cycle_chance = 0
	self.gain_pspd_inhibit_on_cycle_chance = 0
	self.launch_homing_projectile_while_boosting_chance = 0
	self.drop_double_ammo_chance = 0
	self.attack_twice_chance = 0
	self.spawn_double_hp_chance = 0
	self.spawn_double_sp_chance = 0
	self.gain_double_sp_chance = 0
	self.shield_projectile_chance = 0
	self.split_projectiles_split_chance = 0
	self.drop_mines_chance = 0
	self.self_explode_on_cycle_chance = 0
	self.double_spawn_chance = 0 
	self.triple_spawn_chance = 0 
	self.rapid_spawn_chance = 0 
	self.spread_spawn_chance = 0 
	self.back_spawn_chance = 0 
	self.side_spawn_chance = 0 
	self.homing_spawn_chance = 0 
	self.blast_spawn_chance = 0 
	self.spin_spawn_chance = 0 
	self.lightning_spawn_chance = 0
	self.flame_spawn_chance = 0 
	self.twosplit_spawn_chance = 0
	self.foursplit_spawn_chance = 0
	self.explode_spawn_chance = 0
	self.laser_spawn_chance = 0 
	self.bounce_spawn_chance = 0
	self.attack_from_sides_chance = 0
	self.attack_from_back_chance = 0
	self.additional_lightning_bolt = 0

	-- Passives
	self.increased_cycle_speed_while_boosting = false
	self.invulnerability_while_boosting = false
	self.increased_luck_while_boosting = false
	self.projectile_ninety_degree_change = false
	self.projectile_random_degree_change = false
	self.wavy_projectiles = false
	self.fast_slow = false
	self.slow_fast = false
	self.increased_lightning_angle = false
	self.fixed_spin_direction = false
	self.additional_bounce = 0
	self.additional_homing_projectile = 0
	self.additional_barrage_projectile = 0
	self.added_chance_to_all_on_kill_events = 0
	self.barrage_nova = false
	self.projectiles_explode_on_expiration = false
	self.projectiles_explosions = false
	self.energy_shield = false
	self.change_attack_periodically = false
	self.gain_sp_on_death = false
	self.convert_hp_to_sp_if_hp_full = false
	self.mvspd_to_aspd = false
	self.no_boost = false
	self.half_ammo = false
	self.half_hp = false
	self.deals_damage_while_invulnerable = false
	self.refill_ammo_if_hp_full = false
	self.refill_boost_if_hp_full = false
	self.only_spawn_boost = false
	self.only_spawn_attack = false
	self.no_ammo_drop = false
	self.infinite_ammo = false
	self.lesser_increased_self_explosion_size = false
	self.greater_increased_self_explosion_size = false

	for _, name in ipairs(attackNames) do
		self["start_with_" .. name:lower()] = false
	end

	-- Conversions
	self.ammo_to_aspd = 0  
	self.mvspd_to_aspd = 0
	self.mvspd_to_hp = 0
	self.mvspd_to_pspd = 0

	-- Mines
	self.timer:every(0.5, function() 
			if self.chances.drop_mines_chance:next() then
				local d = 1.2*self.w
				self.area:addGameObject('Projectile', self.x - 1.5*d*math.cos(self.r), self.y - 1.5*d*math.sin(self.r), {r = self.r, mine = true, attack = "Neutral"})
			end
		end)

	-- Geometry
	self.x, self.y = x, y
	self.w, self.h = 12 * self.size_multiplier, 12 * self.size_multiplier

	-- Ship
	self.ship = GameData.last_selected_ship 
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

	-- ES
	self.energy_shield_recharge_cooldown = 2
	self.energy_shield_recharge_amount = 1

	-- Ammo
	self.max_ammo = 100
	self.ammo = self.max_ammo

	-- Item
	self.permanent_buffs = {
		['stat_buffs'] = {
			['flat_hp'] = {chanceList({10, 10}, {25, 4}, {50, 1}), 'HP'},
			['flat_ammo'] = {chanceList({10, 10}, {25, 4}, {50, 1}), 'Ammo'},
			['flat_boost'] = {chanceList({10, 10}, {25, 4}, {50, 1}), 'Boost'},
			['ammo_gain'] = {chanceList({0.5, 10}, {1, 4}, {1.5, 1}), 'Ammo Gain'},
			['hp_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'HP'},
			['ammo_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'Ammo'},
			['mvspd_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'MVPSD'},
			['pspd_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'PSPD'},
			['cycle_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'Cycle Speed'},
			['luck_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'Luck'},
			['turn_rate_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'Turn Rate'},
			['projectile_size_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Projectile Size'},
			['invulnerability_time_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Invulnerability Time'},
			['stat_boost_duration_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Stat Boost Duration'},
			['ammo_consumption_multiplier'] = {chanceList({-0.1, 10}, {-0.2, 4}, {-0.3, 1}), 'Ammo Consumption'},
			['projectile_waviness_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Projectile Waviness'},
			['projectile_duration_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Projectile Duration'},
			['projectile_angle_change_frequency_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Projectile Angle Change Frequency'},
			['projectile_acceleration_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Projectile Acceleration'},
			['projectile_deceleration_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Projectile Deceleration'},
			['area_multiplier'] = {chanceList({0.1, 10}, {0.25, 4}, {0.5, 1}), 'Area'},
			['energy_shield_recharge_amount_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'Energy Shield Recharge Amount'},
			['energy_shield_recharge_cooldown_multiplier'] = {chanceList({0.1, 10}, {0.2, 4}, {0.3, 1}), 'Energy Shield Recharge Cooldown'},
			['barrage_on_cycle_chance'] = {chanceList({2, 10}, {4, 4}, {8, 1}), 'Barrage on Cycle Chance'},
			['launch_homing_projectile_on_cycle_chance'] = {chanceList({2, 10}, {4, 4}, {8, 1}), 'Launch Homing Projectile on Cycle Chance'},
			['launch_homing_projectile_on_kill_chance'] = {chanceList({1, 10}, {2, 4}, {4, 1}), 'Launch Homing Projectile on Kill Chance'},
			['change_attack_on_cycle_chance'] = {chanceList({10, 10}, {25, 4}, {50, 1}), 'Change Attack on Cycle Chance'},
			['barrage_on_kill_chance'] = {chanceList({2, 10}, {4, 4}, {8, 1}), 'Barrage on Kill Chance'},
			['shield_projectile_chance'] = {chanceList({10, 10}, {25, 4}, {50, 1}), 'Shield Projectile Chance'},
			['added_chance_to_all_on_kill_events'] = {chanceList({1, 10}, {2, 4}, {3, 1}), 'Added Chance to All "On Kill" Events'},
			['drop_mines_chance'] = {chanceList({2, 10}, {4, 4}, {8, 1}), 'Drop Mines Chance'},
			['self_explode_on_cycle_chance'] = {chanceList({8, 10}, {16, 4}, {24, 1}), 'Self Explode on Cycle Chance'},
			['attack_twice_chance'] = {chanceList({10, 10}, {20, 4}, {30, 1}), 'Attack Twice Chance'},
			['attack_from_sides_chance'] = {chanceList({10, 10}, {15, 4}, {20, 1}), 'Attack from Sides Chance'},
			['attack_from_back_chance'] = {chanceList({10, 10}, {15, 4}, {20, 1}), 'Attack from Back Chance'},
			['additional_barrage_projectile'] = {chanceList({1, 10}, {2, 4}, {3, 1}), 'Additional Barrage Projectile'},
			['additional_homing_projectile'] = {chanceList({1, 10}, {2, 1}), 'Additional Homing Projectile'},
			['additional_lightning_bolt'] = {chanceList({1, 10}, {2, 1}), 'Additional Lightning Bolt'},
			['additional_bounce'] = {chanceList({1, 10}, {2, 4}, {4, 1}), 'Additional Bounce'},
		},

		['modifier_buffs'] = {
			['projectile_ninety_degree_change'] = {true, 'Projectile 90 Degree Change'},
			['projectile_random_degree_change'] = {true, 'Projectile Random Degree Change'},
			['increased_cycle_speed_while_boosting'] = {true, 'Increased Cycle Speed While Boosting'},
			['fast_slow'] = {true, 'Fast -> Slow Projectiles'},
			['slow_fast'] = {true, 'Slow -> Fast Projectiles'},
			['barrage_nova'] = {true, 'Barrage Nova'},
			['projectiles_explode_on_expiration'] = {true, 'Projectiles Explode on Expiration'},
			['projectiles_explosions'] = {true, 'Explosions Create Projectiles Instead'},
			['change_attack_periodically'] = {true, 'Change Attack Every 10 Seconds'},
			['deals_damage_while_invulnerable'] = {true, 'Deals Damage While Invulnerable'}
		},

		['attack_change'] = {
			['attack_change'] = {true, 'Attack Change'}
		},
	}
	self.item_type_chance_list = chanceList({'stat_buffs', 30}, {'modifier_buffs', 10}, {'attack_change', 8})

	-- Mouse
	self.distanceTillNoBoost = 65
	self.noBoostZoneThickness = 55

	-- Collision
	self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
	self.collider:setCollisionClass('Player')
	self.collider:setObject(self)

	-- Shoot/Attacks
	self.shoot_timer = 0
	self.shoot_cooldown = 0.24
	if self.change_attack_periodically then
		self.timer:every(10, function()
				self:setAttack(selectRandomKey(attacks))
			end)
	end

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

	-- Stats
	Ships[self.ship]["modifyPlayerStats"](self)
	self:treeToPlayer()
	self:setStats()
	self:generateChances()

	-- Assign attack afterwards
	local startingAttack = self:returnRandomStartingAttack()
	if startingAttack then self:setAttack(startingAttack) else self:setAttack("Neutral") end
end

function Player:treeToPlayer()
	local approved_list = {
		'increased_cycle_speed_while_boosting', 'invulnerability_while_boosting', 'increased_luck_while_boosting', 'projectile_ninety_degree_change', 'projectile_random_degree_change', 'wavy_projectiles', 
		'fast_slow', 'slow_fast', 'energy_shield', 'barrage_nova', 'projectiles_explode_on_expiration', 'lesser_increased_self_explosion_size', 'greater_increased_self_explosion_size', 
		'projectiles_explosions', 'change_attack_periodically', 'gain_sp_on_death', 'convert_hp_to_sp_if_hp_full', 'no_boost', 'half_ammo', 'half_hp', 'deals_damage_while_invulnerable', 
		'refill_ammo_if_hp_full', 'refill_boost_if_hp_full', 'only_spawn_boost', 'only_spawn_attack', 'no_ammo_drop', 'infinite_ammo', 'fixed_spin_direction', 'start_with_double', 'start_with_triple', 
		'start_with_rapid', 'start_with_spread', 'start_with_back', 'start_with_side', 'start_with_homing', 'start_with_blast', 'start_with_spin', 'start_with_lightning', 'start_with_flame', 
		'start_with_2split', 'start_with_4split', 'start_with_explode', 'start_with_laser', 'start_with_bounce', 'additional_lightning_bolt'
	}

	local all_attributes = {}
	local positives = {}
	local negatives = {}
	for _, index in ipairs(GameData.bought_node_indexes) do
		if tree[index] then
			local stats = tree[index].stats
			for i = 1, #stats, 3 do
				local attribute, value = stats[i+1], stats[i+2]
				if not self[attribute] and not M.any(approved_list, attribute) then error('No attribute "' .. attribute .. '"') end
				if not positives[attribute] then positives[attribute] = 0 end
				if not negatives[attribute] then negatives[attribute] = 0 end
				if type(self[attribute]) == 'number' then
					if value > 0 then positives[attribute] = positives[attribute] + value
					else negatives[attribute] = negatives[attribute] + value end
					self[attribute] = self[attribute] + value
				elseif type(self[attribute]) == 'boolean' then
					self[attribute] = value
				elseif self[attribute]:is(Stat) then
					if value > 0 then positives[attribute] = positives[attribute] + value
					else negatives[attribute] = negatives[attribute] + value end
					local v = self[attribute].value
					self[attribute] = Stat(v + value)
				end
				if not M.any(all_attributes, attribute) then table.insert(all_attributes, attribute) end
			end
		end
	end

--	for _, attribute in ipairs(all_attributes) do
--		if type(self[attribute]) == 'number' or type(self[attribute]) == 'boolean' then
--			print(attribute, self[attribute], positives[attribute], negatives[attribute])
--		else print(attribute, self[attribute].value, positives[attribute], negatives[attribute]) end
--	end
end

function Player:setStats()
	if self.mvspd_to_hp > 0 and self.mvspd_multiplier.value < 1 then
		self.flat_hp = self.flat_hp + self.mvspd_multiplier.value*self.mvspd_to_hp
	end

	self.max_hp = (self.max_hp + self.flat_hp)*self.hp_multiplier	
	self.max_ammo = (self.max_ammo + self.flat_ammo)*self.ammo_multiplier
	self.max_boost = (self.max_boost + self.flat_boost)*self.boost_multiplier

	if self.no_boost then self.max_boost = 0 end
	if self.half_ammo then self.max_ammo = self.max_ammo / 2 end
	if self.half_hp then self.max_hp = self.max_hp / 2 end

	self.hp = self.max_hp
	self.ammo = self.max_ammo
	self.boost = self.max_boost

	if self.energy_shield then
		self.invulnerability_time_multiplier = self.invulnerability_time_multiplier/2
	end
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
			playGameAmmo()
			self:addAmmo(5 + self.ammo_gain)
			self:onAmmoPickup()
			current_room.score = current_room.score + 50
		elseif object:is(Boost) then
			playGameItem()
			self:addBoost(25)        
			current_room.score = current_room.score + 150
		elseif object:is(HP) then
			playGameItem()
			self:addHP(25)
			self:onHPPickup()
		elseif object:is(SP) then
			playGameItem()
			self:addSP(1)
			self:onSPPickup()
			current_room.score = current_room.score + 250
		elseif object:is(Attack) then
			playGameItem()
			self:setAttack(object.attack)
			current_room.score = current_room.score + 500
		elseif object:is(Item) then
			playGameItem()
			self:onItemPickup()

			local buff_type = self.item_type_chance_list:next()
			local buff = selectRandomKey(self.permanent_buffs[buff_type])
			if buff_type == 'attack_change' then
				self:setAttack(table.random(attackNames))
				self.area:addGameObject('InfoText', self.x, self.y, {text = 'Attack Change!', w = self.w, h = self.h})

			elseif type(self.permanent_buffs[buff_type][buff][1]) == 'table' then
				print(buff)
				local n = self.permanent_buffs[buff_type][buff][1]:next()
				if buff == 'aspd_multiplier' or buff == 'mvspd_multiplier' or buff == 'pspd_multiplier' or buff == 'cycle_multiplier' or buff == 'luck_multiplier' then self[buff] = Stat(self[buff].value + n)
				elseif buff == 'hp_multiplier' then self.max_hp = self.max_hp*(1+n)
				elseif buff == 'ammo_multiplier' then self.max_ammo = self.max_ammo*(1+n)
				elseif buff == 'boost_multiplier' then self.max_boost = self.max_boost*(1+n)
				elseif buff == 'flat_hp' then self.max_hp = self.max_hp + n
				elseif buff == 'flat_ammo' then self.max_ammo = self.max_ammo + n
				elseif buff == 'flat_boost' then self.max_boost = self.max_boost + n
				else self[buff] = self[buff] + n end
				if self.projectile_waviness_multiplier > 1 then self.wavy_projectiles = true end
				if self.pspd_multiplier.value < 0 then self.pspd_multiplier.base = 0 end
				self:generateChances()
				local text = ''
				if n < 1 then text = text .. '+' .. n*100 .. '% ' .. self.permanent_buffs[buff_type][buff][2] .. '!'
				else 
					if self.permanent_buffs[buff_type][buff][2]:find('Chance') then text = text .. '+' .. n .. '% ' .. self.permanent_buffs[buff_type][buff][2] .. '!'
					else text = text .. '+' .. n .. ' ' .. self.permanent_buffs[buff_type][buff][2] .. '!' end
				end
				self.area:addGameObject('InfoText', object.x, object.y, {text = text, w = self.w, h = self.h})

			elseif type(self.permanent_buffs[buff_type][buff][1]) == 'boolean' then
				self[buff] = true
				local text = self.permanent_buffs[buff_type][buff][2] .. '!'
				self:generateChances()
				self.area:addGameObject('InfoText', object.x, object.y, {text = text, w = self.w, h = self.h})
			end
		end
	end

	if self.collider:enter('Enemy') then
		local collision_data = self.collider:getEnterCollisionData('Enemy')
		local object = collision_data.collider:getObject()

		if self.invincible and self.deals_damage_while_invulnerable then 
			-- Normally this means that the object would get shredded to pieces since this is on every tick, but since the player usually ends up pushing away the enemy, it feels balanced
			if object then object:hit(30) end 
		end
		self:hit(-30)
	end

	-- Passives

	-- Aspd
	if self.ammo_to_aspd > 0 then self.aspd_multiplier:increase((self.ammo_to_aspd/100)*(self.max_ammo - 100)) end
	if self.mvspd_to_aspd > 0 and self.mvspd_multiplier.value > 1 then self.aspd_multiplier:increase((self.mvspd_to_aspd)*(self.mvspd_multiplier.value) - 100) end
	if self.inside_haste_area then self.aspd_multiplier:increase(100) end
	if self.aspd_boosting then self.aspd_multiplier:increase(100) end
	self.aspd_multiplier:update(dt)

	-- Mvspd
	if self.mvspd_boosting then self.mvspd_multiplier:increase(50) end
	self.mvspd_multiplier:update(dt)

	-- Pspd
	if self.mvspd_to_pspd > 0 and self.mvspd_multiplier.value > 1 then self.pspd_multiplier:increase((self.mvspd_to_pspd)*(self.mvspd_multiplier.value) - 100) end
	if self.pspd_boosting then self.pspd_multiplier:increase(100) end
	if self.pspd_inhibiting then self.pspd_multiplier:decrease(100) end
	self.pspd_multiplier:update(dt)

	-- Cycle
	if self.cycle_boosting then self.cycle_multiplier:increase(200) end
	self.cycle_multiplier:update(dt)

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

	self:updateClickMovement(dt)

	if input:pressed('up') and self.boost > 1 and self.can_boost then self:onBoostStart() end
	if input:released('up') then self:onBoostEnd() end
	if input:down('up') and self.boost > 1 and self.can_boost then         
		self:speedUp(dt)
	end
	if input:pressed('down') and self.boost > 1 and self.can_boost then self:onBoostStart() end
	if input:released('down') then self:onBoostEnd() end
	if input:down('down') and self.boost > 1 and self.can_boost then 
		self:slowDown(dt)
	end
	self.trail_color = skill_point_color 
	if self.boosting then self.trail_color = boost_color end

	if input:down('left') then self.r = self.r - self.rv*self.turn_rate_multiplier*dt end
	if input:down('right') then self.r = self.r + self.rv*self.turn_rate_multiplier*dt end

	self.boost = math.min(self.boost + 10*dt, self.max_boost)
	self.v = math.min(self.v + self.a*dt, self.max_v) * self.mvspd_multiplier.value
	self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

	-- Cycle
	self.cycle_timer = self.cycle_timer + (dt * self.cycle_multiplier.value)
	if self.cycle_timer >= self.cycle_cooldown then
		self:cycle()
		self.cycle_timer = 0
	end

	if self.dont_move then self.v = 0 end
end

function Player:draw()
	if self.invisible then return end
--	love.graphics.setColor(1, 1, 1)
--	love.graphics.circle('fill', self.x, self.y, self.distanceTillNoBoost + self.noBoostZoneThickness/2)
--	love.graphics.setColor(0, 0, 0)
--	love.graphics.circle('fill', self.x, self.y, self.distanceTillNoBoost - self.noBoostZoneThickness/2)

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

	local mods = {
		shield = self.chances.shield_projectile_chance:next(),
	}

	if self.attack == 'Neutral' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))
	elseif self.attack == 'Double' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r + math.pi/12), 
			self.y + 1.5*d*math.sin(self.r + math.pi/12), 
			table.merge({r = self.r + math.pi/12, attack = self.attack}, mods))

		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r - math.pi/12),
			self.y + 1.5*d*math.sin(self.r - math.pi/12), 
			table.merge({r = self.r - math.pi/12, attack = self.attack}, mods))
	elseif self.attack == 'Triple' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
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
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))
	elseif self.attack == 'Spread' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		local t = love.math.random()
		local r = (t * (-math.pi/8)) + ((1-t) * (math.pi/8))
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r + r, attack = self.attack, color = table.random(all_colors)}, mods))
	elseif self.attack == 'Back' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

		local back_r = self.r - math.pi
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(back_r), self.y + 1.5*d*math.sin(back_r), table.merge({r = back_r, attack = self.attack}, mods))
	elseif self.attack == 'Side' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

		local side1_r = self.r - math.pi/2
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(side1_r), self.y + 1.5*d*math.sin(side1_r), table.merge({r = side1_r, attack = self.attack}, mods))

		local side2_r = self.r + math.pi/2
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(side2_r), self.y + 1.5*d*math.sin(side2_r), table.merge({r = side2_r, attack = self.attack}, mods))
	elseif self.attack == 'Homing' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		local projectile = self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack, s = 4}, mods))
	elseif self.attack == 'Blast' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		playGameShoot2()
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
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
			table.merge({r = self.r, attack = self.attack}, mods))
	elseif self.attack == 'Flame' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		playGameFlame()
		local random_angle = random(-math.pi/20, math.pi/20)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r + random_angle), self.y + 1.5*d*math.sin(self.r + random_angle), 
			table.merge({r = self.r + random_angle, attack = self.attack, v = random(250, 300), back_color = skill_point_color}, mods))
	elseif self.attack == 'Bounce' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		local bounces = 4 + self.additional_bounce
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
			table.merge({r = self.r, attack = self.attack, bounce = bounces, color = table.random(default_colors)}, mods))
	elseif self.attack == '2Split' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
			table.merge({r = self.r, attack = self.attack, s = 4}, mods))
	elseif self.attack == '4Split' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
			table.merge({r = self.r, attack = self.attack, s = 4}, mods))
	elseif self.attack == 'Lightning' then
		local x1, y1 = self.x + d*math.cos(self.r), self.y + d*math.sin(self.r)
		local cx, cy = x1 + 24*math.cos(self.r), y1 + 24*math.sin(self.r)
		local enemy_amount_to_attack = 1 + self.additional_lightning_bolt
		if self.increased_lightning_angle then
			cx, cy = self.x, self.y
		end

		local nearby_enemies = self.area:getAllGameObjectsThat(function(e)
				for _, enemy in ipairs(enemies) do
					if self.lightning_targets_projectiles then
						if (e:is(_G[enemy]) or e:is(EnemyProjectile)) and (distance(e.x, e.y, cx, cy) < 64*self.lightning_trigger_distance_multiplier) then
							return true
						end
					else
						if e:is(_G[enemy]) and (distance(e.x, e.y, cx, cy) < 64*self.lightning_trigger_distance_multiplier) then
							return true
						end
					end
				end
			end)

		table.sort(nearby_enemies, function(a, b) 
				return distance(a.x, a.y, cx, cy) < distance(b.x, b.y, cx, cy) 
			end)

		local closest_enemies = M.first(nearby_enemies, enemy_amount_to_attack)

		-- Attack closest enemies
		for i, closest_enemy in ipairs(closest_enemies) do
			self.timer:after((i-1)*0.05, function()
					if closest_enemy then
						playGameLightning()
						if not closest_enemy:is(EnemyProjectile) then self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier end
						closest_enemy:hit()
						local x2, y2 = closest_enemy.x, closest_enemy.y
						self:spawnLightning(x1, y1, x2, y2, boost_color)
					end
				end)
		end
	elseif self.attack == 'Explode' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		self.area:addGameObject('Projectile', 
			self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack, s = 5}, mods))
	elseif self.attack == 'Laser' then
		self.ammo = self.ammo - (attacks[self.attack].ammo * self.ammo_consumption_multiplier)
		playGameLaser()
		local x1, y1 = self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r) 
		local x2, y2 = self.x + 1024*math.cos(self.r), self.y + 1024*math.sin(self.r)
		self.area:addGameObject('Laser',
			x1, y1, {x2 = x2, y2 = y2, r = self.r, wm = self.laser_width_multiplier})
	end

	if self.infinite_ammo then self.ammo = self.max_ammo end

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

	if self.gain_sp_on_death then 
		self:addSP(20) 
		self.area:addGameObject('InfoText', self.x, self.y, {text = '+20SP', w = self.w, h = self.h, color = skill_point_color})
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
		GameData.sp = math.min(GameData.sp + amount, max_sp)
	else
		GameData.sp = math.max(GameData.sp + amount, 0)
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
			if k:find('_on_kill') and v > 0 then
				self.chances[k] = chanceList(
					{true, math.ceil(v+self.added_chance_to_all_on_kill_events)}, 
					{false, 100-math.ceil(v+self.added_chance_to_all_on_kill_events)})
			else
				self.chances[k] = chanceList({true, math.ceil(v)}, {false, 100-math.ceil(v)})
			end
		end
	end
end

function Player:hit(damage)
	if self.invincible then return end
	local damage = damage or 10

	if self.energy_shield then
		damage = damage*2
		--[[
		Something the author forgot to add: the 'es_amount' timer doesn't actually get cancelled until the timer call gets run, which doesn't make much sense
		as it means there isn't actually a period of time in which the energy shield isn't regenerating. As you can imagine this is a little too good so it's important to add
		the line to cancel the 'es_amount' timer.
		]]--
		self.timer:cancel('es_amount')
		self.timer:after('es_cooldown', self.energy_shield_recharge_cooldown * self.energy_shield_recharge_cooldown_multiplier, function()
				self.timer:every('es_amount', 0.25, function()
						self:addHP(self.energy_shield_recharge_amount * self.energy_shield_recharge_amount_multiplier)
					end)
			end)
	end

	for i = 1, love.math.random(4, 8) do 
		self.area:addGameObject('ExplodeParticle', self.x, self.y) 
	end
	self:addHP(damage)

	if damage <= -30 then
		playGameHurt()
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
		playGameHurtSmall()
		flash(0.03)
		camera:shake(6, 60, 0.1)
		slow(0.75, 0.25) 
	end
end

function Player:onAmmoPickup()

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
	if self.hp == self.max_hp then 
		if self.convert_hp_to_sp_if_hp_full then
			self:addSP(3) 
			self.area:addGameObject('InfoText', self.x, self.y, {text = '+3SP', w = self.w, h = self.h, color = skill_point_color})
		end
		if self.refill_ammo_if_hp_full then 
			self.ammo = self.max_ammo 
			self.area:addGameObject('InfoText', self.x, self.y, {text = 'MAX Ammo!', w = self.w, h = self.h, color = ammo_color})
		end
		if self.refill_boost_if_hp_full then
			self.boost = self.max_boost
			self.area:addGameObject('InfoText', self.x, self.y, {text = 'MAX Boost!', w = self.w, h = self.h, color = boost_color})
		end
	end
end

function Player:onItemPickup()
	if self.chances.launch_homing_projectile_on_item_pickup_chance:next() then
		self:launchHomingProjectile()
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', w = self.w, h = self.h})
	end
	if self.chances.regain_hp_on_item_pickup_chance:next() then
		self:addHP(25)
		self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', w = self.w, h = self.h})
	end
	if self.chances.spawn_haste_area_on_item_pickup_chance:next() then
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
	if self.chances.gain_mvspd_boost_on_cycle_chance:next() then
		self:applyStatus(4, "mvspd_boosting")
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'MVSPD Boost!', color = boost_color, w = self.w, h = self.h})
	end
	if self.chances.gain_pspd_boost_on_cycle_chance:next() then
		self:applyStatus(4, "pspd_boosting")
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'PSPD Boost!', color = skill_point_color, w = self.w, h = self.h})
	end
	if self.chances.gain_pspd_inhibit_on_cycle_chance:next() then
		self:applyStatus(4, "pspd_inhibiting")
		if self.timer then self.timer:after(4, function() self.pspd_inhibiting = false end) end
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'PSPD Inhibit!', color = skill_point_color, w = self.w, h = self.h})
	end
	if self.chances.self_explode_on_cycle_chance:next() then
		-- This isn't totally like the author's explosion (his is a square), but I figured a circle would work just as good (and it's easier to implement)
		local min_d, max_d, num_explosions, s
		if self.lesser_increased_self_explosion_size and not self.greater_increased_self_explosion_size then
			min_d = 2.8 * self.w
			max_d = 3.3 * self.w
			num_explosions = 15
			s = random(40, 45)
		elseif self.lesser_increased_self_explosion_size and self.greater_increased_self_explosion_size then
			min_d = 3*self.w
			max_d = 3.5*self.w
			num_explosions = 20
			s = random(45, 50)
		elseif not self.lesser_increased_self_explosion_size and not self.greater_increased_self_explosion_size then
			min_d = 2.5*self.w
			max_d = 3*self.w
			num_explosions = 12
			s = random(35, 40)
		end
		-- If user has greater increased self explosion size, but not lesser, program will crash.
		-- Check if it is possible to get greater without lesser.
		local min_time = 0.1	
		local max_time = 0.3
		local r = 0
		local r_offset = 2*math.pi / num_explosions

		local list_of_r = {}
		for i = 1, num_explosions do
			table.insert(list_of_r, r)
			r = r + r_offset
		end
		for i = 1, num_explosions do
			local time = random(min_time, max_time)
			local d = random(min_d, max_d)
			if self.timer then self.timer:after(time, function()
					self.area:addGameObject('Explosion', self.x + 1.5*d*math.cos(list_of_r[i]), self.y + 1.5*d*math.sin(list_of_r[i]), {s = s})
				end)
		end
	end
end
end

function Player:onKill(enemy_death_location)
	-- Enemies originally did not spawn Ammo upon death, so I added it.
	if not self.no_ammo_drop then self.area:addGameObject('Ammo', unpack(enemy_death_location)) end
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
		if self.timer then self.timer:after(4, function() self.aspd_boosting = false end) end
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'ASPD Boost!', color = ammo_color, w = self.w, h = self.h})
	end
end

function Player:onShoot()
	local d = 1.2*self.w
	if self.chances.attack_twice_chance:next() then
		self:shoot()
		self.area:addGameObject('InfoText', self.x, self.y, 
			{text = 'Double Attack!', w = self.w, h = self.h})
	end
	if self.chances.attack_from_sides_chance:next() then
		self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi/2), self.y + 1.5*d*math.sin(self.r - math.pi/2), {r = self.r - math.pi/2, attack = self.attack})
		self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi/2), self.y + 1.5*d*math.sin(self.r + math.pi/2), {r = self.r + math.pi/2, attack = self.attack})
	end
	if self.chances.attack_from_back_chance:next() then
		self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi), self.y + 1.5*d*math.sin(self.r - math.pi), {r = self.r - math.pi, attack = self.attack})
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
	for i = 1, 8 + self.additional_barrage_projectile do
		if self.timer then self.timer:after((i-1)*0.05, function()
				local random_angle = random(-math.pi/8, math.pi/8)
				if self.barrage_nova then random_angle = random(-math.pi * 2, math.pi * 2) end
				local d = 2.2*self.w
				self.area:addGameObject('Projectile', 
					self.x + d*math.cos(self.r + random_angle), 
					self.y + d*math.sin(self.r + random_angle), 
					{r = self.r + random_angle, attack = "Neutral"})
			end)
	end
end
end

function Player:launchHomingProjectile()
	local d = 1.2*self.w
	for i = 1, 1+self.additional_homing_projectile do
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
	if self.timer then self.timer:after(base_seconds * self.stat_boost_duration_multiplier, function() 
			self[name] = false
		end)
end
end

function Player:returnRandomStartingAttack()
	local start_withs = {}

	for k, bool in pairs(self) do
		if k:find('start_with_') then
			if bool then table.insert(start_withs, k) end
		end
	end

	if #start_withs == 0 then return false else return lowercaseToProper[string.sub(start_withs[love.math.random(1, #start_withs)], string.len("start_with_") + 1)] end
end

function Player:slowDown(dt)
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

function Player:speedUp(dt)
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

function Player:updateClickMovement(dt)
	if input:pressed('left_click') then
		local temp_x, temp_y = camera:getMousePosition(sx, sy, self.x*sx + xTranslationRequiredToCenter, self.y*sy + yTranslationRequiredToCenter, sx*gw, sy*gh)
		local mouse_vector = Vector(temp_x, -temp_y)

		if mouse_vector:len() <= self.distanceTillNoBoost - self.noBoostZoneThickness/2 and self.boost > 1 and self.can_boost then 
			self:onBoostStart() 
			self.movementMode = "slowDown"
		elseif mouse_vector:len() >= self.distanceTillNoBoost + self.noBoostZoneThickness/2 and self.boost > 1 and self.can_boost then 
			self:onBoostStart() 
			self.movementMode = "speedUp"
		else
			self.movementMode = "neutral"
		end

		self.last_mouse_vector = mouse_vector
		self.previous_x, self.previous_y = camera:getMousePosition(sx, sy, xTranslationRequiredToCenter, yTranslationRequiredToCenter, sx*gw, sy*gh)
	end

	if input:down('left_click') then
		-- Step 1: Make ship vector, remember game's cartesian coordinate system is mirrored on the x-axis so we need to flip it to get to a regular coordinate system
		local ship_vector = Vector(math.cos(self.r), math.sin(self.r))
		ship_vector.y = -ship_vector.y
		-- Step 2: Take orthogonal of ship vector. Note that this method returns the CCW orthogonal vector
		local orthogonal_ship_vector = ship_vector:perpendicular()
		-- Step 3: Take mouse vector but we need to be in "ship" coordinate space, kind of. We do this by offsetting 0, 0 to the position of the ship (scaled ofc)
		local temp_x, temp_y = camera:getMousePosition(sx, sy, self.x*sx + xTranslationRequiredToCenter, self.y*sy + yTranslationRequiredToCenter, sx*gw, sy*gh)
		local mouse_vector = Vector(temp_x, -temp_y)
		
		if (mouse_vector:len() <= self.distanceTillNoBoost - self.noBoostZoneThickness/2) and self.boost > 1 and self.can_boost then 
			if self.movementMode == "slowDown" then 
				self:slowDown(dt) 
			else
				self.movementMode = "slowDown"
				self:onBoostEnd()
				self:onBoostStart()
			end
		end
		if (mouse_vector:len() >= self.distanceTillNoBoost + self.noBoostZoneThickness/2) and self.boost > 1 and self.can_boost then 
			if self.movementMode == "speedUp" then 
				self:speedUp(dt) 
			else
				self.movementMode = "speedUp"
				self:onBoostEnd()
				self:onBoostStart()
			end
		end

		local x, y = camera:getMousePosition(sx, sy, xTranslationRequiredToCenter, yTranslationRequiredToCenter, sx*gw, sy*gh)
		if not self.previous_x or (math.abs(x - self.previous_x) >= 2 or math.abs(y - self.previous_y) >= 2) then
			self.previous_x, self.previous_y = x, y
			self.last_mouse_vector = mouse_vector
		end

		-- Step 4: Take dot of orthogonal and our mouse vector. Divides the space into two half spaces, where the cut is along the ship vector
		local dot = orthogonal_ship_vector * self.last_mouse_vector

		if dot > 0 then
			self.r = self.r - self.rv*self.turn_rate_multiplier*dt
		else
			self.r = self.r + self.rv*self.turn_rate_multiplier*dt
		end

	end
end