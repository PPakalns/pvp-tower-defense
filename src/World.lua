local class = require "middleclass"

local Utility = require "Utility"
local Entity = require 'Entity'
local PositionComp = require 'components/Position'
local RectangleComp = require 'components/Rectangle'
local LoopingAnimationComp = require 'components/LoopingAnimation'
local BasicAttributesComp = require 'components/BasicAttributes'
local BuildingComp = require 'components/Building'
local Color = require 'Color'
local Bump = require 'bump'

local World = class('World')

function World:initialize(tileCntX, tileCntY)
    self.width = tileCntX
    self.height = tileCntY
    self.offX = 16
    self.offY = 16
    self.tileSize = 32

    -- bump library collision world
    self.cworld = Bump.newWorld()

    self.map = Utility.createArray2D(self.height, self.width, false)
end


function World:initializeEntities(gameContext)
    for y = 1, self.height do
        for x = 1, self.width do
            local water = Entity:new()
            water:addComponent(
                PositionComp:new(self.offX + (x - 1) * self.tileSize,
                                 self.offY + (y - 1) * self.tileSize)
                )
            water:addComponent(
                LoopingAnimationComp:new(
                    'water',
                    gameContext.imageManager:getAnimation('water'),
                    8,
                    math.random()
                    )
                )
            gameContext.entityManager:addEntity(water)
        end
    end

    function createBaseEntity(team, x, y)
        local base = Entity:new()
        base:addComponent(PositionComp:new(
                self.offX + (x - 1) * self.tileSize,
                self.offY + (y - 1) * self.tileSize
            ))
        base:addComponent(BasicAttributesComp:new(team, 100))
        base:addComponent(BuildingComp:new(self, self.tileSize))
        base:addComponent(RectangleComp:new(
                'baseRect',
                (team == 1) and Color:new(1, 0, 0, 1) or Color:new(0, 1, 0, 1),
                self.tileSize, self.tileSize,
                0, 0
            ))
        return base
    end

    gameContext.entityManager:addEntity(createBaseEntity(1, 1, math.floor(self.height / 2) + 1))
    gameContext.entityManager:addEntity(createBaseEntity(2, self.width, math.floor(self.height / 2) + 1))
end

return World
