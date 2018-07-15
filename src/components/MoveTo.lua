local class = require "middleclass"

local Component = require "../Component"
local Vec2 = require "../Vec2"

local MoveTo = class('MoveTo', Component)

function MoveTo:initialize(speed)
    Component.initialize(self, 'moveTo', true, false)
    self.speed = speed
    self.target = nil       -- Vec2 of movement target coordinates
    self.positionComp = nil -- Stores the reference to position component
    self.lastMovement = nil -- Stores the movement done in the last update
end

function MoveTo:setTarget(vec)
    self.target = vec
end

function MoveTo:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
end

function MoveTo:update(dt)
    if self.target == nil then
        self.lastMovement = nil
        return
    end

    local delta = self.target:sub(self.positionComp.pos)
    local dist = self.speed * dt
    if delta:length() < dist then
        self.positionComp.pos:set(self.target)
        self.lastMovement = delta
        self.target = nil
    else
        local movement = delta:normalize():mult(dist)
        self.lastMovement = movement
        self.positionComp.pos:selfAdd(movement)
    end
end

return MoveTo
