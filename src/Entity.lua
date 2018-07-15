local class = require "middleclass"

local Entity = class('Entity')

function Entity:initialize()
    self.components = {}
    self.componentUpdateOrder = {}
    self.componentDrawOrder = {}
    self.unique_id = 0
end

-- Functions to fastly retrieve entity in EntityManager, when entity is destroyed
function Entity:setUniqueId(id)
    self.unique_id = id
end

function Entity:getUniqueId(id)
    return self.unique_id
end

function Entity:addComponent(component)
    component:attach(self)
    self.components[component:getName()] = component
    if component:isUpdatable() then
        table.insert(self.componentUpdateOrder, component)
    end
    if component:isDrawable() then
        table.insert(self.componentDrawOrder, component)
    end
end

function Entity:removeComponent(component)
    component:detach()
    self.components[component:getName()] = nil
    if component:isUpdatable() then
        for i = 1, #self.componentUpdateOrder[i] do
            if self.componentUpdateOrder[i] == component then
                table.remove(self.componentUpdateOrder, i)
                break
            end
        end
    end
    if component:isDrawable() then
        for i = 1, #self.componentDrawOrder[i] do
            if self.componentDrawOrder[i] == component then
                table.remove(self.componentDrawOrder, i)
                break
            end
        end
    end
end

-- Called when entity is destroyed
function Entity:destroy()
    for i = #self.components, 1, -1 do
        self.components[i]:detach()
    end
end

function Entity:getComponent(alias)
    local comp = self.components[alias]
    if comp == nil then
        error("Component with "..alias.." not found")
    end
    return comp
end

function Entity:update(dt)
    for i = 1, #self.componentUpdateOrder do
        self.componentUpdateOrder[i]:update(dt)
    end
end

function Entity:draw()
    for i = 1, #self.componentDrawOrder do
        self.componentDrawOrder[i]:draw()
    end
end

return Entity
