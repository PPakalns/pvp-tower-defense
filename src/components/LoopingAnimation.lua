local class = require "middleclass"

local Component = require "../Component"
local LoopingAnimation = class('LoopingAnimation', Component)

function LoopingAnimation:initialize(name, animation, total_duration, time_offset)
    Component.initialize(self, name, true, true)
    self.positionComp = nil
    self.animation = animation
    self.time_per_frame = total_duration / #animation.quads
    self.frame = 1
    if time_offset ~= nil then
        self.frame = 1 + math.floor(time_offset / self.time_per_frame)
        while self.frame > #animation.quads do
            self.frame = self.frame - #animation.quads
        end
        self.time = time_offset - self.frame * self.time_per_frame
    end
    self.time = 0
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
        self.positionComp.x, self.positionComp.y
        )
end

return LoopingAnimation
