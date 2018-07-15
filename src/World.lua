local class = require "middleclass"

local Utility = require "Utility"
local Entity = require 'Entity'
local PositionComp = require 'components/Position'
local LoopingAnimationComp = require 'components/LoopingAnimation'

local World = class('World')

function World:initialize(tileCntX, tileCntY)
    self.width = tileCntX
    self.height = tileCntY
    self.offX = 10
    self.offY = 10
    self.tileSize = 32

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
                    1,
                    math.random()
                    )
                )
            gameContext.entityManager:addEntity(water)
        end
    end

end

return World
