local class = require "middleclass"

local DelayedAction = require "components/DelayedAction"
local Vec2 = require "Vec2"

local SpawnEntity = class('SpawnEntity', DelayedAction)

-- Component, which spawns entities

function SpawnEntity:initialize(name, interval, gameContext, entityCreateCallback)

    self.basicAttributesComp = nil
    self.positionComp = nil
    local callback = function(entity)
        local team = self.basicAttributesComp.team
        print("Spawning ship ", team, "position", self.positionComp.pos:toString())
        gameContext.entityManager:addEntity(
            entityCreateCallback(gameContext,
                                 team,
                                 gameContext.world:getNextTileInPath(self.positionComp.pos, team))
        )
    end

    DelayedAction.initialize(self, name, interval, callback, true)
end

function SpawnEntity:attach(entity)
    DelayedAction.attach(self, entity)
    self.basicAttributesComp = entity:getComponent('basicAttributes')
    self.positionComp = entity:getComponent('position')
end

return SpawnEntity
