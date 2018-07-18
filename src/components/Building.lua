local class = require "middleclass"

local Component = require "Component"

local Building = class('Building', Component)

function Building:initialize(world)
    Component.initialize(self, 'building', false, false)
    self.size = world.tileSize
    self.world = world
    self.cworld = world.cworld
    self.positionComp = nil
    self.basicAttributesComp = nil  -- Basic attributes for fast access from collisions
end

function Building:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
    self.basicAttributesComp = entity:getComponent('basicAttributes')
    self.cworld:add(self,
        self.positionComp.pos.x - self.size / 2, self.positionComp.pos.y - self.size / 2,
        self.size / 2, self.size / 2)
    self.world:addBuilding(self.basicAttributesComp, self.world:getTileCoord(self.positionComp.pos))
end

function Building:detach()
    Component.detach(self)
    self.cworld:remove(self)
    self.world:removeBuilding(self.basicAttributesComp, self.world:getTileCoord(self.positionComp.pos))
end

return Building
