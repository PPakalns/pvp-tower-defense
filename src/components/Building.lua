local class = require "middleclass"

local Component = require "Component"

local Building = class('Building', Component)

function Building:initialize(world, size)
    Component.initialize(self, 'building', false, false)
    self.size = size
    self.cworld = world.cworld
    self.positionComp = nil
end

function Building:attach(entity)
    self.positionComp = entity:getComponent('position')
    self.cworld:add(self,
        self.positionComp.pos.x, self.positionComp.pos.y,
        self.size, self.size)
end

function Building:detach()
    self.cworld:remove(self)
end

return Building
