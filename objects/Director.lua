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
    for i = 2, 1024, 4 do
        self.difficulty_to_points[i] = self.difficulty_to_points[i-1] + 8
        self.difficulty_to_points[i+1] = self.difficulty_to_points[i]
        self.difficulty_to_points[i+2] = math.floor(self.difficulty_to_points[i+1]/1.5)
        self.difficulty_to_points[i+3] = math.floor(self.difficulty_to_points[i+2]*2)
    end
	
	-- Enemies
	self.enemy_to_points = {
        ['Rock'] = 1,
        ['Shooter'] = 2,
    }
	
	self.enemy_spawn_chances = {
        [1] = chanceList({'Rock', 1}),
        [2] = chanceList({'Rock', 8}, {'Shooter', 4}),
        [3] = chanceList({'Rock', 8}, {'Shooter', 8}),
        [4] = chanceList({'Rock', 4}, {'Shooter', 8}),
    }
	
	for i = 5, 1024 do
        self.enemy_spawn_chances[i] = chanceList(
      	    {'Rock', love.math.random(2, 12)}, 
      	    {'Shooter', love.math.random(2, 12)}
    	)
    end
	
	self.timer:every(22/self.player.enemy_spawn_rate_multiplier, function()
			self.difficulty = self.difficulty + 1
			self:setEnemySpawnsForThisRound()
		end
	)
	
	-- Spawn enemies immediately for Round 1
	self:setEnemySpawnsForThisRound()
	
	-- Resources
    self.resource_spawn_chances = chanceList({'Boost', 28*self.player.boost_spawn_chance_multiplier}, 
    {'HP', 14*self.player.hp_spawn_chance_multiplier}, {'SP', 58*self.player.sp_spawn_chance_multiplier})
	self.timer:every(16/self.player.resource_spawn_rate_multiplier, function()
			local resource_name = self.resource_spawn_chances:next()
			self.area:addGameObject(resource_name)
			self.player:onResourceSpawn(resource_name)
		end
	)
	
	-- Attacks
	self.timer:every(30/self.player.attack_spawn_rate_multiplier, function()
			local i = 1
			local selectAttackName = {}
			for attackName, _ in pairs(attacks) do
				selectAttackName[i] = attackName
				i = i + 1
			end
			self.area:addGameObject('Attack', 0, 0, {attack = selectAttackName[love.math.random(1, #selectAttackName)]})
		end
	)
	
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

function Director:destroy()
	Director.super.destroy(self)
end