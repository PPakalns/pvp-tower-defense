local class = require "middleclass"

local Gui = require "Gui"
local Layer = require('Layer')
local PauseLayer = require('PauseLayer')

local GameLayer = class('GameLayer', Layer)

function GameLayer:initialize(context)
    Layer.initialize(self, context)

    self.rColor = 0;
    self.rDir = 1;
    self.animation = context.imageManager:getAnimation('explosion')
    self.frame = 1

end

-- Update layer, return true if layers under it should be updated
function GameLayer:update(dt)

    -- Random code to control Game screen preview text
    self.rColor = self.rColor + dt * self.rDir;
    if self.rColor > 1 or self.rColor < 0 then
        self.rDir = self.rDir * -1
        self.rColor = math.max(0, math.min(self.rColor, 1))
    end

    self.frame = self.frame + 1
    if self.frame > #self.animation.quads then
        self.frame = 1
    end

    return false
end

-- Return true if layer under it should be drawn
function GameLayer:drawUnder()
    return false
end

-- Draw layer
function GameLayer:draw()

    -- Render temporary string
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.setColor(self.rColor, 0, 0, 1)
    love.graphics.print("Game screen", 100, 100)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.animation.image,
        self.animation.quads[self.frame],
        200, 200
        )
end

-- Distribute events, return true if event should be passed to lower layer
function GameLayer:event(event)
    if event.name == 'keypressed' and event.arg[2] == 'escape' then
        self.context.layerManager:push(PauseLayer:new(self.context))
    end

    return false
end

return GameLayer
