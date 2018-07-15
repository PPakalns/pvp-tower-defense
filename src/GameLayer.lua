local class = require "middleclass"

local Layer = require 'Layer'
local PauseLayer = require 'PauseLayer'

local Entity = require 'Entity'
local EntityManager = require 'EntityManager'
local PositionComp = require 'components/Position'
local LoopingAnimationComp = require 'components/LoopingAnimation'
local CorrectDirectionAnimationComp = require 'components/CorrectDirectionAnimation'
local DelayedActionComp = require 'components/DelayedAction'
local MoveToComp = require 'components/MoveTo'
local MoveToAcceleratedComp = require 'components/MoveToAccelerated'
local World = require 'World'
local Vec2 = require 'Vec2'

local GameLayer = class('GameLayer', Layer)

function GameLayer:initialize(context)
    Layer.initialize(self, context)

    self.entityManager = EntityManager:new()

    self.gameContext = {
        layerManager = context.layerManager,
        imageManager = context.imageManager,
        entityManager = self.entityManager,
        world = World:new(21, 11),
    }

    self.gameContext.world:initializeEntities(self.gameContext)

    local ship = Entity:new()
    ship:addComponent(PositionComp:new(100, 50))
    local shipAnimationComp = LoopingAnimationComp:new(
        'shipAnimation',
        self.gameContext.imageManager:getAnimation('shipRight'),
        1
    )
    ship:addComponent(shipAnimationComp)
    ship:addComponent(MoveToAcceleratedComp:new(32, 64, -40))
    ship:addComponent(
        CorrectDirectionAnimationComp:new(
            shipAnimationComp:getName(), 'ship', self.gameContext
        ))
    ship:addComponent(
        DelayedActionComp:new(
            'changeMovementTarget',
            2,
            function(entity, localTable)
                local dir = localTable.dir or 0
                dir = dir + 1
                if dir > 5 then
                    dir = 1
                end
                local pos = entity:getComponent('position').pos
                local targ
                if dir == 5 then
                    targ = pos:clone()
                else
                    targ = pos:add(Vec2.getMainDirectionVector(dir):mult(500))
                end
                entity:getComponent('moveTo'):setTarget(targ)
                localTable.dir = dir
            end,
            true
        ))
    self.entityManager:addEntity(ship)

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
