local class = require "middleclass"

local Component = require "../Component"
local Vec2 = require "../Vec2"

local MoveTo = class('MoveTo', Component)

function MoveTo:initialize(maxSpeed)
    Component.initialize(self, 'moveTo', true, false)
    self.maxSpeed = maxSpeed
    self.target = nil       -- Vec2 of movement target coordinates
    self.positionComp = nil -- Stores the reference to position component
    self.lastMovement = nil -- Stores the movement done in the last update
end

function MoveTo:setTarget(vec)
    self.target = vec:clone()
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
    local dist = self.maxSpeed * dt
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

function MoveTo:isTargetSet()
    return self.target ~= nil
end

return MoveTo
