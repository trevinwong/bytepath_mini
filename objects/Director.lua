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
	
	self.timer:every(22, function()
			self.difficulty = self.difficulty + 1
			self:setEnemySpawnsForThisRound()
		end
	)
	
	-- Spawn enemies immediately for Round 1
	self:setEnemySpawnsForThisRound()
	
	-- Resources
	self.resource_spawn_chances = chanceList({'Boost', 28}, {'HP', 14}, {'SP', 58})
	self.timer:every(16, function()
			self.area:addGameObject(self.resource_spawn_chances:next())
		end
	)
	
	-- Attacks
	self.timer:every(30, function()
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

	--[[
		Exercise 118:
			Interestingly enough, the existing code already handles this case. The author claims that the while loop will get stuck if we can only spawn
			enemies with point values higher than the number of points we currently have to allocate for enemies.
			
			This is actually not the case however, since we don't actually care how many points we have remaining since our number of points can be negative
			due to the fact that we do a simple subtraction. So even if we only have 1 point remaining, we can actually just spawn an enemy with an extremely
			high point value, and that'll exit the loop since our number of points will be lower or equal to 0.
			
			If, however, the case that the author claims would happen were to actually happen, I would simply just spawn the lowest value enemy for that wave
			and call it a day. But to be honest, I don't think the above scenario is actually a bad alternative (technically our player could get a little
			screwed over by RNG), but since it's just 1 enemy, I don't think it will influence the gameplay that much.
			
			This is actually mentioned in the post itself by another reader. Reading the author's response, I do agree that one should be very careful with
			using while loops - perhaps it's a good routine to always think - "is there a way that this can not terminate?"
	]]--

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