local Config = require 'Config'
local Entity = require 'Entity'
local PositionComp = require 'components/Position'
local RectangleComp = require 'components/Rectangle'
local LoopingAnimationComp = require 'components/LoopingAnimation'
local BasicAttributesComp = require 'components/BasicAttributes'
local BuildingComp = require 'components/Building'
local ShipComp = require 'components/Ship'
local CorrectDirectionAnimationComp = require 'components/CorrectDirectionAnimation'
local DelayedActionComp = require 'components/DelayedAction'
local MoveToComp = require 'components/MoveTo'
local MoveToAcceleratedComp = require 'components/MoveToAccelerated'
local PathFindingComp = require 'components/PathFinding'
local Color = require 'Color'
local Vec2 = require 'Vec2'

local Entities = {}

Entities.createWaterEntity = function (gameContext, worldCoord)
    local water = Entity:new()
    water:addComponent(PositionComp:new(worldCoord.x, worldCoord.y))
    water:addComponent(
        LoopingAnimationComp:new(
            'water',
            gameContext.imageManager:getAnimation('water'),
            10,
            math.random()
            )
        )
    return water
end


Entities.createBaseEntity = function (gameContext, team, tileVec)
    local base = Entity:new()
    base:addComponent(PositionComp:new(
            gameContext.world.offX + (tileVec.x - 1) * gameContext.world.tileSize,
            gameContext.world.offY + (tileVec.y - 1) * gameContext.world.tileSize
        ))
    base:addComponent(BasicAttributesComp:new(team, Config.base.basicAttributes))
    base:addComponent(BuildingComp:new(gameContext.world))
    base:addComponent(RectangleComp:new(
            'baseRect',
            (team == 1) and Color:new(1, 0, 0, 1) or Color:new(0, 1, 0, 1),
            gameContext.world.tileSize, gameContext.world.tileSize,
            0, 0
        ))
    return base
end

Entities.createBasicShip = function (gameContext, team, tileVec)
    local ship = Entity:new()
    local worldPos = gameContext.world:getWorldCoordMiddle(tileVec)
    ship:addComponent(PositionComp:new(worldPos.x, worldPos.y))
    local shipAnimationComp = LoopingAnimationComp:new(
        'shipAnimation',
        gameContext.imageManager:getAnimation('shipRight'),
        1
    )
    ship:addComponent(shipAnimationComp)
    ship:addComponent(MoveToAcceleratedComp:new(32, 64, -40))
    ship:addComponent(
        CorrectDirectionAnimationComp:new(
            shipAnimationComp:getName(), 'ship', gameContext
        ))
    ship:addComponent(BasicAttributesComp:new(team, Config.basicShip.basicAttributes))
    ship:addComponent(ShipComp:new(gameContext.world))
    ship:addComponent(PathFindingComp:new(gameContext.world))
    ship:addComponent(DelayedActionComp:new('resetShip', 10,
            function(entity)
                entity:getComponent('position').pos:set(worldPos)
            end, true)
        )
    return ship
end

return Entities
