local class = require "middleclass"

local Utility = require "Utility"
local Entity = require 'Entity'
local PositionComp = require 'components/Position'
local LoopingAnimationComp = require 'components/LoopingAnimation'

local World = class('World')

function World:initialize(tileCntX, tileCntY)
    self.width = tileCntX
    self.height = tileCntY

    self.map = Utility.createArray2D(self.height, self.width, false)
end


function World:initializeEntities(gameContext)
    local offX, offY = 10, 10
    local tsize = 32

    for y = 1, self.height do
        for x = 1, self.width do
            local water = Entity:new()
            water:addComponent(
                PositionComp:new(offX + (x - 1) * tsize, offY + (y - 1) * tsize)
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
