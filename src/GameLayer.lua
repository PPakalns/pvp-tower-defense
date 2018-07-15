local class = require "middleclass"

local Layer = require 'Layer'
local PauseLayer = require 'PauseLayer'

local Entity = require 'Entity'
local EntityManager = require 'EntityManager'
local PositionComp = require 'components/Position'
local LoopingAnimationComp = require 'components/LoopingAnimation'
local DelayedActionComp = require 'components/DelayedAction'
local MoveToComp = require 'components/MoveTo'
local World = require 'World'

local GameLayer = class('GameLayer', Layer)

function GameLayer:initialize(context)
    Layer.initialize(self, context)

    self.entityManager = EntityManager:new()

    self.gameContext = {
        layerManager = context.layerManager,
        imageManager = context.imageManager,
        entityManager = self.entityManager,
        world = World:new(20, 10),
    }

    self.gameContext.world:initializeEntities(self.gameContext)
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
