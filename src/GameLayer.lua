local class = require "middleclass"

local Layer = require 'Layer'
local PauseLayer = require 'PauseLayer'

local Entity = require 'Entity'
local EntityManager = require 'EntityManager'
local PositionComp = require 'components/Position'
local LoopingAnimationComp = require 'components/LoopingAnimation'
local DelayedActionComp = require 'components/DelayedAction'
local MoveToComp = require 'components/MoveTo'

local GameLayer = class('GameLayer', Layer)

function GameLayer:initialize(context)
    Layer.initialize(self, context)

    self.entityManager = EntityManager:new()
    self.game_context = {
        layerManager = context.layerManager,
        imageManager = context.imageManager,
        entityManager = self.entityManager,
    }


    local resetPosition = function(entity)
        local positionComp = entity:getComponent('position')
        positionComp.pos.x = math.random(1, 400)
        positionComp.pos.y = math.random(1, 400)
    end

    for i = 1, 10 do
        local explosionEntity = Entity:new(self.entityManager)
        explosionEntity:addComponent(PositionComp:new(math.random(1, 400), math.random(1, 400)))
        explosionEntity:addComponent(
            LoopingAnimationComp:new(
                'explosion',
                self.game_context.imageManager:getAnimation('explosion'),
                2,
                math.random(1, 100000) / 100000
            )
        )
        explosionEntity:addComponent(DelayedActionComp:new('resetPosition', math.random(1, 200) / 100, resetPosition, true))
        explosionEntity:addComponent(MoveToComp:new(50, 300, 300))
        self.entityManager:addEntity(explosionEntity)
    end
end

-- Update layer, return true if layers under it should be updated
function GameLayer:update(dt)
    self.entityManager:update(dt)
end

-- Return true if layer under it should be drawn
function GameLayer:drawUnder()
    return false
end

-- Draw layer
function GameLayer:draw()
    self.entityManager:draw()
end

-- Distribute events, return true if event should be passed to lower layer
function GameLayer:event(event)
    if event.name == 'keypressed' and event.arg[2] == 'escape' then
        self.context.layerManager:push(PauseLayer:new(self.context))
    end

    return false
end

return GameLayer
