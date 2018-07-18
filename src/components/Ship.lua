local class = require "middleclass"

local Component = require "Component"
local Vec2 = require "Vec2"

local Ship = class('Ship', Component)

-- Component whose collision box moves with it

function Ship:initialize(world)
    Component.initialize(self, 'ship', true, false)
    self.size = 16
    self.offX = self.size / 2
    self.offY = self.size / 2

    self.world = world
    self.cworld = world.cworld
    self.positionComp = nil
    self.basicAttributesComp = nil  -- Basic attributes for fast access from collisions

    self.tilePosition = nil
end

function Ship:update(dt)
    -- Handle collisions with objects or other ships
    local pos = self.positionComp.pos
    local actualX, actualY, cols, len = self.cworld:move(self, pos.x - self.offX, pos.y - self.offY)
    self.positionComp.pos = Vec2:new(actualX + self.offX, actualY + self.offY)

    -- Check if tiles crossed
    local newTilePos = self.world:getTileCoord(self.positionComp.pos)
    if not newTilePos:integerEqual(self.tilePosition) then
        -- Remove ship from old tile
        self.world:removeShip(self.basicAttributesComp, self.tilePosition)
        self.tilePosition = newTilePos
        -- Add ship to the new one
        self.world:addShip(self.basicAttributesComp, self.tilePosition)
    end
end

function Ship:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
    self.basicAttributesComp = entity:getComponent('basicAttributes')
    self.cworld:add(self,
        self.positionComp.pos.x - self.offX, self.positionComp.pos.y - self.offY,
        self.size, self.size)
    self.world:addShip(self.basicAttributesComp, self.world:getTileCoord(self.positionComp.pos))
    self.tilePosition = self.world:getTileCoord(self.positionComp.pos)
end

function Ship:detach()
    Component.detach(self)
    self.cworld:remove(self)
    self.world:removeShip(self.basicAttributesComp, self.world:getTileCoord(self.positionComp.pos))
end

return Ship
