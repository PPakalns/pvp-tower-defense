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
    local movement = self.target:sub(self.positionComp.pos):normalize():mult(self.speed * dt)
    self.positionComp.pos = self.positionComp.pos:add(movement)
end

return MoveTo
