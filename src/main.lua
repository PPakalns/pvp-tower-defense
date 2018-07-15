local class = require "middleclass"

local LayerManager = require "LayerManager"
local MenuLayer = require "MenuLayer"

local layerManager = (require "LayerManager"):new()
local imageManager = (require "ImageManager"):new()

local SCALE = 2

function love.load()
    love.window.setMode(32 * 22 * SCALE, 32 * 12 * SCALE)
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
    love.graphics.scale(SCALE, SCALE)
    layerManager:draw(dt)
end

-- Handle events
-- Other similar events can  be mad in the same way
function love.keypressed(...)
    layerManager:event({name = 'keypressed', arg = {...}})
end
