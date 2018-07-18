local class = require "middleclass"

local Component = require "../Component"

local Circle = class('Circle', Component)

function Circle:initialize(name, color, radius)
    Component.initialize(self, name, false, true)
    self.color = color
    self.radius = radius
end

function Circle:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
end

function Circle:draw()
    self.color:set()
    love.graphics.circle(
        'line',
        self.positionComp.pos.x,
        self.positionComp.pos.y,
        self.radius
        )
end

return Circle
