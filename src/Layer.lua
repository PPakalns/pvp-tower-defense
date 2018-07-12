local class = require "middleclass"

local Layer = class('Layer')

function Layer:initialize(context)
    self.context = context
    print("Layer "..tostring(self).." initialized!")
end

-- Update layer, return true if layers under it should be updated
function Layer:update(dt)
    return true
end

-- Return true if layer under it should be drawn
function Layer:drawUnder()
    return true
end

-- Draw layer
function Layer:draw()
end

-- Distribute events, return true if event should be passed to lower layer
function Layer:event(event)
    return true
end

return Layer
