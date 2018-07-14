local class = require "middleclass"

local Component = require "../Component"
local Vec2 = require "../Vec2"

local MoveTo = class('MoveTo', Component)

function MoveTo:initialize(speed, tx, ty)
    Component.initialize(self, 'moveto', true, false)
    self.speed = speed
    self.target = Vec2:new(tx, ty)
    self.positionComp = nil
end

function MoveTo:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
end

function MoveTo:update(dt)
    local delta = self.target:sub(self.positionComp.pos)
    local dist = self.speed * dt
    if delta:length() < dist then
        self.positionComp.pos:set(self.target)
    else
        local movement = delta:normalize():mult(dist)
        self.positionComp.pos:selfAdd(movement)
    end
end

return MoveTo
