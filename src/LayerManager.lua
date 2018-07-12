local class = require "middleclass"

local LayerManager = class('LayerManager')

function LayerManager:initialize()
    self.layers = {}
end

function LayerManager:push(layer)
    table.insert(self.layers, layer)
end

function LayerManager:pop()
    return table.remove(self.layers)
end

function LayerManager:update(dt)
    for i = #self.layers, 1, -1 do
        if self.layers[i]:update(dt) ~= true then
            break
        end
    end
end

function LayerManager:draw()
    drawFrom = #self.layers
    while drawFrom > 1 and self.layers[drawFrom]:drawUnder() do
        drawFrom = drawFrom - 1
    end

    for i = drawFrom, #self.layers do
        self.layers[i]:draw()
    end
end

function LayerManager:event(event)
    for i = #self.layers, 1, -1 do
        if self.layers[i]:event(event) ~= true then
            break
        end
    end
end

return LayerManager
