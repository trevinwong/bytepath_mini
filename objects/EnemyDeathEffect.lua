require "objects/GameObject"

EnemyDeathEffect = GameObject:extend()

function EnemyDeathEffect:new(area, x, y, opts)
    EnemyDeathEffect.super.new(self, area, x, y, opts)

    self.current_color = default_color
    self.timer:after(0.1, function()
        self.current_color = self.color
        self.timer:after(0.15, function()
            self.dead = true
        end)
    end)
end

function EnemyDeathEffect:draw()
    love.graphics.setColor(self.current_color)
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.h/2, self.w, self.h)
end