local class = require "middleclass"

local Component = require "Component"
local Vec2 = require 'Vec2'

local Position = class('Position', Component)

function Position:initialize(x, y)
    Component.initialize(self, 'position', false, false)
    self.pos = Vec2:new(x, y)
end

return Position
