local class = require "middleclass"

local Layer = require 'Layer'
local PauseLayer = require 'PauseLayer'

local EntityManager = require 'EntityManager'
local World = require 'World'
local Config = require 'Config'

local GameLayer = class('GameLayer', Layer)

function GameLayer:initialize(context)
    Layer.initialize(self, context)

    self.entityManager = EntityManager:new()

    self.gameContext = {
        layerManager = context.layerManager,
        imageManager = context.imageManager,
        entityManager = self.entityManager,
        world = World:new(21 * Config.gameScale, 11 * Config.gameScale),
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
