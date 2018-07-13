local class = require "middleclass"

local Component = class('Component')

function Component:initialize(name, updatable, drawable)
    self.entity = nil
    self.comp_name = name
    self.comp_updatable = updatable
    self.comp_drawable = drawable
end

function Component:isDrawable()
    return self.comp_drawable
end

function Component:isUpdatable()
    return self.comp_updatable
end

function Component:getName()
    return self.comp_name
end

function Component:attach(entity)
    self.entity = entity
end

function Component:update(dt)
    error('Not implemented')
end

function Component:draw(dt)
    error('Not implemented')
end

return Component
