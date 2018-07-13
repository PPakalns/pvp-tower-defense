local class = require "middleclass"

local Component = require "../Component"
local Position = class('Position', Component)

function Position:initialize(x, y)
    Component.initialize(self, 'position', false, false)
    self.x, self.y = x, y
end

return Position
