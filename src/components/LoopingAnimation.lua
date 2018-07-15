local class = require "middleclass"

local Component = require "../Component"
local LoopingAnimation = class('LoopingAnimation', Component)

function LoopingAnimation:initialize(name, animation, total_duration, relative_time_offset)
    Component.initialize(self, name, true, true)
    self.positionComp = nil
    self:setAnimation(animation, total_duration, relative_time_offset)
end

function LoopingAnimation:setAnimation(animation, total_duration, relative_time_offset)
    total_duration = total_duration or 1

    self.animation = animation
    self.frame = 1
    self.time_per_frame = total_duration / #animation.quads
    self.time = 0
    if relative_time_offset ~= nil then
        local time_offset = relative_time_offset * total_duration
        self.frame = math.floor(time_offset / self.time_per_frame) + 1
        self.frame = math.max(1, math.min(#animation.quads, self.frame))
        self.time = time_offset - self.frame * self.time_per_frame
    end
end

function LoopingAnimation:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
end

function LoopingAnimation:update(dt)
    self.time = self.time + dt
    while self.time > self.time_per_frame do
        self.frame = self.frame + 1
        self.time = self.time - self.time_per_frame
        if self.frame > #self.animation.quads then
            self.frame = 1
        end
    end
end

function LoopingAnimation:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.animation.image,
        self.animation.quads[self.frame],
        self.positionComp.pos.x - self.animation.offX,
        self.positionComp.pos.y - self.animation.offY
        )
end

return LoopingAnimation
