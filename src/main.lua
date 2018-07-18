local class = require "middleclass"

local LayerManager = require "LayerManager"
local MenuLayer = require "MenuLayer"

local layerManager = (require "LayerManager"):new()
local imageManager = (require "ImageManager"):new()

local Config = require 'Config'

function love.load()

    math.randomseed( os.time() )

    love.window.setMode(32 * (3 - Config.gameScale) + 32 * 21 * 2, 32 * (3 - Config.gameScale) + 32 * 11 * 2)
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
    love.graphics.scale((3 - Config.gameScale), (3 - Config.gameScale))
    layerManager:draw(dt)
end

-- Handle events
-- Other similar events can  be mad in the same way
function love.keypressed(...)
    layerManager:event({name = 'keypressed', arg = {...}})
end
