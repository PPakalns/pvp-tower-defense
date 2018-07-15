local class = require "middleclass"

local LayerManager = require "LayerManager"
local MenuLayer = require "MenuLayer"

local layerManager = (require "LayerManager"):new()
local imageManager = (require "ImageManager"):new()

function love.load()
    love.window.setMode(660 * 2, 340 * 2)
    local context = {
        layerManager = layerManager,
        imageManager = imageManager,
    }
    layerManager:push(MenuLayer:new(context))
end

function love.update(dt)
    layerManager:update(dt)
end

function love.draw()
    love.graphics.scale(2, 2)
    layerManager:draw(dt)
end

-- Handle events
-- Other similar events can  be mad in the same way
function love.keypressed(...)
    layerManager:event({name = 'keypressed', arg = {...}})
end
