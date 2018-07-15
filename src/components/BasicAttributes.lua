local class = require "middleclass"

local Component = require "Component"

local BasicAttributes = class('BasicAttributes', Component)

function BasicAttributes:initialize(team, health)
    Component.initialize(self, 'BasicAttributes', false, false)
    self.team = team
    self.health = health
    self.armor = 1        -- Ratio of how much damage the object absorbs
end

return BasicAttributes
