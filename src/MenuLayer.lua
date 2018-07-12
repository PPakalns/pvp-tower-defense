local class = require "middleclass"

local Layer = require "Layer"

local GameLayer = require "GameLayer"
local Gui = require "Gui"
local Color = require "Color"

local MenuLayer = class('MenuLayer', Layer)

function MenuLayer:initialize(context)
    Layer.initialize(self, context)
    self.vlayout = Gui.VertLayout:new('w', 's', 10, 10, 10)
    self.vlayout:push(Gui.Text:new("Menu", 40, Color:new(1, 1, 1, 1)))
    local fg, bg = Color:new(0.8, 0.3, 0.3, 1), Color:new(0.4, 0, 0, 1)

    self.vlayout:push(Gui.Button:new("Start", 20, fg, bg, function()
        self.context.layerManager:push(GameLayer:new(context))
    end))

    self.vlayout:push(Gui.Button:new("Exit", 20, fg, bg, function()
        love.event.quit()
    end))
end

function MenuLayer:update(dt)
    return self.vlayout:update(dt)
end

function MenuLayer:draw()
    self.vlayout:draw()
end

function MenuLayer:event(event)
    return self.vlayout:event(event)
end

return MenuLayer
