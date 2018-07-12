local class = require "middleclass"

local LayerManager = require "LayerManager"
local MenuLayer = require "MenuLayer"

local layerManager = LayerManager:new()

function love.load()
    local context = {
        layerManager = layerManager
    }
    layerManager:push(MenuLayer:new(context))
end

function love.update(dt)
    layerManager:update(dt)
end

function love.draw()
    layerManager:draw(dt)
end

-- Handle events
function love.keypressed(key, scancode, isrepeat)
    layerManager:event({name = 'keypressed', arg = {key, scancode, isrepeat}})
end
