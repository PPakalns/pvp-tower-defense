local class = require "middleclass"

local Layer = require "Layer"
local Gui = require "Gui"
local Color = require "Color"

local PauseLayer = class('PauseLayer', Layer)

function PauseLayer:initialize(context)
    Layer.initialize(self, context)

    self.vlayout = Gui.VertLayout:new('w', 's', 100, 100, 10)
    self.vlayout:push(Gui.Text:new("Pause", 40, Color:new(1, 1, 1, 1)))
    local fg, bg = Color:new(0.8, 0.3, 0.3, 1), Color:new(0.4, 0, 0, 1)

    self.vlayout:push(Gui.Button:new("Continue", 20, fg, bg, function()
        self.context.layerManager:pop()
    end))

    self.vlayout:push(Gui.Button:new("Quit", 20, fg, bg, function()
        self.context.layerManager:pop()
        self.context.layerManager:pop()
    end))
end

-- Update layer, return true if layers under it should be updated
function PauseLayer:update(dt)
    self.vlayout:update(dt)
    return false
end

-- Return true if layer under it should be drawn
function PauseLayer:drawUnder()
    return true
end

-- Draw layer
function PauseLayer:draw()
    -- Draw background
    love.graphics.setColor(10, 0, 0, 0.15)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    self.vlayout:draw()
end

-- Distribute events, return true if event should be passed to lower layer
function PauseLayer:event(event)
    if event.name == 'keypressed' and event.arg[2] == 'escape' then
        -- Pause game
        self.context.layerManager:pop()
    else
        self.vlayout:event(event)
    end

    return false
end

return PauseLayer
