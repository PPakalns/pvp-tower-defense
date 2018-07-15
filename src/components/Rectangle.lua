local class = require "middleclass"

local Component = require "../Component"

local Rectangle = class('Rectangle', Component)

function Rectangle:initialize(name, color, w, h, offX, offY)
    Component.initialize(self, name, false, true)
    self.color = color
    self.w = w
    self.h = h
    self.offX = offX
    self.offY = offY
end

function Rectangle:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
end

function Rectangle:draw()
    self.color:set()
    love.graphics.rectangle(
        'line',
        self.positionComp.pos.x - self.offX,
        self.positionComp.pos.y - self.offY,
        self.w,
        self.h
        )
end

return Rectangle
