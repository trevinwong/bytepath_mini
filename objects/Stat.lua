Stat = Object:extend()

function Stat:new(base)
    self.base = base

    self.additive = 0
    self.additives = {}
    self.value = self.base*(1 + self.additive)
end

function Stat:update(dt)
    for _, additive in ipairs(self.additives) do self.additive = self.additive + additive end

    if self.additive >= 0 then
        self.value = self.base*(1 + self.additive)
    else
        --[[
            A note because I found this so interesting, since I've never stopped to consider how stats in games are calculated:
            
            If you notice here, the calculation for negative percentages is totally different than positive percentages. Why?
            
            This is due to the limitation of how (many, if not all) of our stats cannot be reduced past 0.
            
            Of course, this is fairly obvious - after all, what does it mean to have negative movement speed? Should the player be moving
            backwards at this point? Of course not, although that would make for an interesting game. But this actually has some interesting
            implications on either the math or the gameplay. I'll cover 3 possible routes here, just for interest's sake:
            
            1. We follow the original author's way, which is to essentially allow players to stack negative percentages as much as they want,
            but tweak the math such that it follows an asymptote (i.e basically like an exponential curve). In other words, it doesn't matter
            how many negative effects you stack - you only get closer and closer to zero, with each percentage decrease having less and less
            of an effect.
            
            2. We allow players to additively stack negative percentages and simply linearly apply them, making negative percentages past
            -100% have no effect.
            
            3. League of Legends multiplicatively stacks your effective stat. In other words, if you have a -10% decrease in movement speed, you're
            effectively running at 90% movement speed. So if you stack another negative effect, you get 0.9 * 0.9 movement speed, which is 0.81.
            
            Both routes 1 and 3 actually have a similar effect of dampening the effect of further percentages - i.e the difference between having
            900% and 1000% decreased movement speed is much less than the difference between 100% and 200% decreased movement speed.
            I'd say that the curve for route 3 actually looks a little nicer in that these differences aren't so extreme.
            
            For the effective purpose of making designers lives easier (i.e it doesn't matter how many negative percentages we add to the game),
            I'd say routes 1 and 3 are much more convenient. I personally though think this is bad since it obscures the true effect of what
            negative percentages do, which leads the player to realize things like "wait, I thought I had 50% less movement speed, how come I'm actually
            moving at 66% of base movement speed?", and I'm not a big fan of obscuring information from players.
            
            Of course I don't intend to put my full effort into balancing this game, so I'm going to go with the convenient route #1.
        ]]--
        self.value = self.base/(1 - self.additive)
    end

    self.additive = 0
    self.additives = {}
end

function Stat:increase(percentage)
    table.insert(self.additives, percentage*0.01)
end

function Stat:decrease(percentage)
    table.insert(self.additives, -percentage*0.01)
end