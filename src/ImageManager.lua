local class = require "middleclass"

-- List of loadable images and their aliases
local imageAliasPath = {
    water = "images/coldwaterdeepwater.png"
}

-- Create animation that holds image and quads
-- that represents the location of sprites in the image
function newAnimation(image, x, y, width, height, frames)
    local animation = {}
    local quads = {}
    animation.image = image
    animation.quads = quads

    for i = 1, frames do
        table.insert(quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        x = x + width
        if x >= image:getWidth() then
            x = 0
            y = y + height
        end
    end

    return animation
end

-- Simple class that preloads images and manages animation descriptions
local ImageManager = class('ImageManager')

function ImageManager:initialize()
    print("Loading images")

    self.images = {}
    self.aliases = imageAliasPath
    for alias, path in pairs(imageAliasPath) do
        self.images[alias] = love.graphics.newImage(path)
    end

    -- Predefine animations and their location in sprite sheet
    self.animations = {}
    self.animations.water =
        newAnimation(self:getImage('water'), 0, 160, 32, 32, 3)

    print("Images loaded")
end

function ImageManager:getImage(alias)
    return self.images[alias]
end

function ImageManager:getAnimation(alias)
    return self.animations[alias]
end

return ImageManager
