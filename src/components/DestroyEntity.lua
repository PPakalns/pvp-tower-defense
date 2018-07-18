local class = require "middleclass"

local DelayedAction = require "components/DelayedAction"
local DestroyEntity = class('DestroyEntity', DelayedAction)

-- Destroys entity after delay

function DestroyEntity:initialize(delay)
    local callback = function(entity)
        entity.entityManager:destroyEntity(entity)
    end
    DelayedAction.initialize(self, 'destroyEntity', delay, callback, false)
end

return DestroyEntity
