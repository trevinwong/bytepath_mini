--[[
	I changed the Director to extend from GameObject. Why? It's annoying to write boilerplate timer code on your own (i.e storing the current time and
	duration, manually adding dt to time, checking if time > duration, resetting it, etc.), plus, since the exercises ask you to write similar timers
	for spawning resources and attacks, it also clogs up the file and makes it look not very nice.
	
	So why go through all that trouble when we have a perfectly nice Timer included with the GameObject class we can use?
	
	One could argue that the Director is technically a construct of the "Room" and not the "Area" since it is not truly a GameObject that has a place,
	but honestly, even commerical game engines like Unity and Unreal disregard this argument - you often place objects such as Directors that have 
	nothing to do with the game inside the scene, just because it's the simplest way to get code to run.
]]--

Director = GameObject:extend()

function Director:new(area, x, y, opts)
	Director.super.new(self, area, x, y, opts)
	self.difficulty = 1

	self.difficulty_to_points = {}
	self.difficulty_to_points[1] = 16
	self.difficulty_to_points[2] = 24
	self.difficulty_to_points[3] = 24
	self.difficulty_to_points[4] = 16
	self.difficulty_to_points[5] = 32
	self.difficulty_to_points[6] = 40
	self.difficulty_to_points[7] = 40 
	self.difficulty_to_points[8] = 26
	self.difficulty_to_points[9] = 52
	self.difficulty_to_points[10] = 60
	self.difficulty_to_points[11] = 60 
	self.difficulty_to_points[12] = 52
	self.difficulty_to_points[13] = 78
	self.difficulty_to_points[14] = 70
	self.difficulty_to_points[15] = 70 
	self.difficulty_to_points[16] = 62 
	self.difficulty_to_points[17] = 98
	self.difficulty_to_points[18] = 98 
	self.difficulty_to_points[19] = 90 
	self.difficulty_to_points[20] = 108
	self.difficulty_to_points[21] = 128
	self.difficulty_to_points[22] = 72 
	self.difficulty_to_points[23] = 80
	self.difficulty_to_points[24] = 140 
	self.difficulty_to_points[25] = 92
	self.difficulty_to_points[26] = 128
	self.difficulty_to_points[27] = 86
	self.difficulty_to_points[28] = 94 
	self.difficulty_to_points[29] = 142
	self.difficulty_to_points[30] = 88
	self.difficulty_to_points[31] = 96
	self.difficulty_to_points[32] = 104 
	self.difficulty_to_points[33] = 112 
	self.difficulty_to_points[34] = 142
	self.difficulty_to_points[35] = 158
	self.difficulty_to_points[36] = 178
	self.difficulty_to_points[37] = 128
	self.difficulty_to_points[38] = 96
	self.difficulty_to_points[39] = 160
	for i = 40, 1024, 4 do
		self.difficulty_to_points[i] = self.difficulty_to_points[i-1] + 8
		self.difficulty_to_points[i+1] = self.difficulty_to_points[i]
		self.difficulty_to_points[i+2] = math.floor(self.difficulty_to_points[i+1]/1.5)
		self.difficulty_to_points[i+3] = math.ceil(self.difficulty_to_points[i+2]*1.66)
	end

	self.enemy_to_points = {
		['Rock'] = 1,
		['BigRock'] = 2,
		['Shooter'] = 2,
		['Waver'] = 4,
		['Seeker'] = 6,
		['Orbitter'] = 12,
	}

	self.enemy_spawn_chances = {
		[1] = chanceList({'Rock', 1}),
		[2] = chanceList({'Rock', 8}, {'BigRock', 4}),
		[3] = chanceList({'Rock', 7}, {'BigRock', 3}, {'Shooter', 3}),
		[4] = chanceList({'Rock', 6}, {'BigRock', 3}, {'Shooter', 3}, {'Seeker', 3}),
		[5] = chanceList({'Rock', 5}, {'BigRock', 3}, {'Shooter', 3}, {'Waver', 4}),
		[6] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Seeker', 1}, {'Waver', 1}),
		[7] = chanceList({'Rock', 4}, {'BigRock', 3}, {'Shooter', 3}, {'Seeker', 2}, {'Waver', 2}),
		[8] = chanceList({'Rock', 4}, {'BigRock', 3}, {'Shooter', 3}, {'Seeker', 2}, {'Waver', 2}),
		[9] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 2}),
		[10] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 4}), --{'Rotator', 2}),
		[11] = chanceList({'Rock', 6}, {'BigRock', 6}),
		[12] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 4}, {'Seeker', 4}, {'Waver', 4}),
		[13] = chanceList({'Rock', 4}, {'BigRock', 4}),
		[14] = chanceList({'Rock', 2}, {'BigRock', 2}, {'Shooter', 2}, {'Waver', 2}),
		[15] = chanceList({'Rock', 4}, {'BigRock', 4}),
		[16] = chanceList({'Rock', 4}, {'BigRock', 2}, {'Shooter', 2}), --{'Rotator', 2}),
		[17] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 3}, {'Orbitter', 4}),
		[18] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 3}),
		[19] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 3}),
		[20] = chanceList({'Orbitter', 1}),
	}
	for i = 21, 1024 do 
		self.enemy_spawn_chances[i] = chanceList({'Rock', love.math.random(2, 12)}, {'BigRock', love.math.random(2, 12)}, {'Shooter', love.math.random(2, 12)}, 
			{'Seeker', love.math.random(2, 12)}, {'Waver', love.math.random(2, 12)},
			{'Orbitter', love.math.random(2, 12)}) 
	end

	self.timer:every(22/self.player.enemy_spawn_rate_multiplier, function()
			self.difficulty = self.difficulty + 1
			self:setEnemySpawnsForThisRound()
		end
	)

	self:generateAttackSpawnChances()

	-- Spawn enemies, item and attack immediately for Round 1
	self:setEnemySpawnsForThisRound()
	self.timer:after(1, function() 
			self.area:addGameObject('Attack', 0, 0, {attack = self.attack_spawn_chances:next()}) 
			self.area:addGameObject('Item') 
		end)

	-- Resources
	self.resource_spawn_chances = chanceList({'Boost', 28*self.player.boost_spawn_chance_multiplier}, 
		{'HP', 14*self.player.hp_spawn_chance_multiplier}, {'SP', 58*self.player.sp_spawn_chance_multiplier})
	self.timer:every(16/self.player.resource_spawn_rate_multiplier, function()
			--[[
				What should happen if the player has both "only_spawn" passives enabled? Well, only_spawn_boost makes it so the only resources spawned are boosts, and
				only_spawn_attack overrides the spawning of resources to spawn only attacks, so, it works out.
			]]--
			if self.player.only_spawn_attack then
				self.area:addGameObject('Attack', 0, 0, {attack = self.attack_spawn_chances:next()})
			elseif self.player.only_spawn_boost then 
				self.area:addGameObject('Boost') 
			else
				local resource_name = self.resource_spawn_chances:next()
				self.area:addGameObject(resource_name)
				self.player:onResourceSpawn(resource_name)
			end
		end
	)

	-- Attacks
	self.timer:every(30/self.player.attack_spawn_rate_multiplier, function()
			self.area:addGameObject('Attack', 0, 0, {attack = self.attack_spawn_chances:next()})
		end
	)

	-- Item
	self.timer:every(62/(self.player.item_spawn_rate_multiplier), function()
			self.area:addGameObject('Item')
		end)
end

function Director:update(dt)
	Director.super.update(self, dt)
end

function Director:setEnemySpawnsForThisRound()
	local points = self.difficulty_to_points[self.difficulty]

	-- Find enemies
	local enemy_list = {}
	while points > 0 do
		local enemy = self.enemy_spawn_chances[self.difficulty]:next()
		points = points - self.enemy_to_points[enemy]
		table.insert(enemy_list, enemy)
	end

	-- Find enemies spawn times
	local enemy_spawn_times = {}
	for i = 1, #enemy_list do 
		enemy_spawn_times[i] = random(0, self.round_duration) 
	end
	table.sort(enemy_spawn_times, function(a, b) return a < b end)


	for i = 1, #enemy_spawn_times do
		self.timer:after(enemy_spawn_times[i], function()
				self.area:addGameObject(enemy_list[i])
			end)
	end
end

function Director:generateAttackSpawnChances()
	self.attack_spawn_chances = chanceList(
		{'Double', 10 + self.player.double_spawn_chance}, {'Triple', 10 + self.player.triple_spawn_chance}, {'Rapid', 10 + self.player.rapid_spawn_chance}, 
		{'Spread', 10 + self.player.spread_spawn_chance}, {'Back', 10 + self.player.back_spawn_chance}, {'Side', 10 + self.player.side_spawn_chance}, 
		{'Homing', 10 + self.player.homing_spawn_chance}, {'Blast', 10 + self.player.blast_spawn_chance}, {'Spin', 10 + self.player.spin_spawn_chance}, 
		{'Bounce', 10 + self.player.bounce_spawn_chance}, {'Lightning', 10 + self.player.lightning_spawn_chance}, {'Flame', 10 + self.player.flame_spawn_chance},
		{'2Split', 10 + self.player.twosplit_spawn_chance}, {'4Split', 10 + self.player.foursplit_spawn_chance}, {'Explode', 10 + self.player.explode_spawn_chance}, 
		{'Laser', 10 + self.player.laser_spawn_chance}
	)
end

function Director:destroy()
	Director.super.destroy(self)
end