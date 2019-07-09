require "objects/GameObject"

ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, opts)
    ProjectileDeathEffect.super.new(self, area, x, y, opts)

    self.current_color = default_color
    self.timer:after(0.1, function()
        self.current_color = hp_color
        self.timer:after(0.15, function()
            self.dead = true
        end)
    end)
end

function ProjectileDeathEffect:draw()
    love.graphics.setColor(self.current_color)
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
end