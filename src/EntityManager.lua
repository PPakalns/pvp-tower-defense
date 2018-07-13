local class = require "middleclass"

local EntityManager = class('EntityManager')

function EntityManager:initialize()
    self.entities = {}
    self.counter = 0
end

function EntityManager:addEntity(entity)
    self.counter = self.counter + 1
    self.entities[self.counter] = entity
    entity:setUniqueId(self.counter)
end

function EntityManager:update(dt)
    for _, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function EntityManager:draw()
    for _, entity in pairs(self.entities) do
        entity:draw()
    end
end

return EntityManager
