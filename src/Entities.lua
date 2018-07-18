local Config = require 'Config'
local Entity = require 'Entity'
local PositionComp = require 'components/Position'
local RectangleComp = require 'components/Rectangle'
local CircleComp = require 'components/Circle'
local FollowEntityComp = require 'components/FollowEntity'
local BasicAttackComp = require 'components/BasicAttack'
local LoopingAnimationComp = require 'components/LoopingAnimation'
local BasicAttributesComp = require 'components/BasicAttributes'
local BuildingComp = require 'components/Building'
local ShipComp = require 'components/Ship'
local CorrectDirectionAnimationComp = require 'components/CorrectDirectionAnimation'
local DelayedActionComp = require 'components/DelayedAction'
local MoveToComp = require 'components/MoveTo'
local MoveToAcceleratedComp = require 'components/MoveToAccelerated'
local SpawnEntityComp = require 'components/SpawnEntity'
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
    local worldPos = gameContext.world:getWorldCoordMiddle(tileVec)
    base:addComponent(PositionComp:new(worldPos.x, worldPos.y))
    base:addComponent(BasicAttributesComp:new(team, Config.base.basicAttributes))
    base:addComponent(BuildingComp:new(gameContext.world))
    base:addComponent(RectangleComp:new(
            'baseRect',
            (team == 1) and Color:new(1, 0, 0, 1) or Color:new(0, 1, 0, 1),
            gameContext.world.tileSize, gameContext.world.tileSize,
            -gameContext.world.tileSize / 2, -gameContext.world.tileSize / 2
        ))
    base:addComponent(BasicAttackComp:new(gameContext, Config.base.basicAttack, Entities.spawnBasicCannonBall))
    return base
end

Entities.createBasicFactory = function (gameContext, team, tileVec)
    local factory = Entity:new()
    local worldPos = gameContext.world:getWorldCoordMiddle(tileVec)
    factory:addComponent(PositionComp:new(worldPos.x, worldPos.y))
    factory:addComponent(BasicAttributesComp:new(team, Config.basicFactory.basicAttributes))
    factory:addComponent(BuildingComp:new(gameContext.world))
    factory:addComponent(
        SpawnEntityComp:new('basicSpawn', Config.basicFactory.spawnRate, gameContext, Entities.createBasicShip)
        )
    factory:addComponent(RectangleComp:new(
            'factoryRect',
            (team == 1) and Color:new(1, 0, 0, 1) or Color:new(0, 1, 0, 1),
            gameContext.world.tileSize, gameContext.world.tileSize,
            -gameContext.world.tileSize / 2, -gameContext.world.tileSize / 2
        ))
    factory:addComponent(RectangleComp:new(
            'factoryRect2',
            (team == 1) and Color:new(1, 0, 0, 1) or Color:new(0, 1, 0, 1),
            gameContext.world.tileSize - 10, gameContext.world.tileSize - 10,
            -gameContext.world.tileSize / 2 + 5, -gameContext.world.tileSize / 2 + 5
        ))
    return factory
end

Entities.createBasicShip = function (gameContext, team, tileVec)
    local ship = Entity:new()
    local worldPos = gameContext.world:getWorldCoordMiddle(tileVec)
    ship:addComponent(PositionComp:new(worldPos.x, worldPos.y))
    ship:addComponent(MoveToAcceleratedComp:new(32, 64, -40))
    local shipAnimationComp = LoopingAnimationComp:new(
        'shipAnimation',
        gameContext.imageManager:getAnimation('shipRight'),
        1
    )
    ship:addComponent(shipAnimationComp)
    ship:addComponent(
        CorrectDirectionAnimationComp:new(
            shipAnimationComp:getName(), 'ship', gameContext
        ))
    ship:addComponent(BasicAttributesComp:new(team, Config.basicShip.basicAttributes))
    ship:addComponent(ShipComp:new(gameContext.world))
    ship:addComponent(PathFindingComp:new(gameContext.world))
    ship:addComponent(BasicAttackComp:new(gameContext, Config.basicShip.basicAttack, Entities.spawnBasicCannonBall))
    print("Basic ship created")
    return ship
end

Entities.spawnBasicCannonBall = function (gameContext, pos, targetEntity, damage)
    local cannonBall = Entity:new()
    cannonBall:addComponent(PositionComp:new(pos.x, pos.y))
    cannonBall:addComponent(MoveToComp:new(200))
    cannonBall:addComponent(CircleComp:new('cannonball', (team == 1) and Color:new(1, 0, 0, 1) or Color:new(0, 1, 0, 1), 3))
    cannonBall:addComponent(FollowEntityComp:new(targetEntity, false, function(followEntityComp, targetEntity)
        gameContext.entityManager:destroyEntity(cannonBall)
        if not targetEntity:isDestroyed() then
            targetEntity:getComponent('basicAttributes'):applyDamage(damage)
        end
        -- TODO: Add smoke
    end))
    gameContext.entityManager:addEntity(cannonBall)
end

return Entities
