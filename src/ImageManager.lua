local class = require "middleclass"

-- List of loadable images and their aliases
local imageAliasPath = {
    water = "images/coldwaterdeepwater.png",
    spritesheet = "images/spritesheet.png"
}

-- Create animation that holds image and quads
-- that represents the location of sprites in the image
function newAnimation(image, x, y, width, height, frames, offX, offY)
    local animation = {}
    local quads = {}
    animation.image = image
    animation.quads = quads

    -- Offset in sprite to the center of object
    animation.offX = offX or 0
    animation.offY = offY or 0

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
        self.images[alias]:setFilter('nearest', 'nearest')
    end

    -- Predefine animations and their location in sprite sheet
    self.animations = {}
    self.animations.water =
        newAnimation(self:getImage('water'), 0, 160, 32, 32, 3)

    self.animations.shipLeft =
        newAnimation(self:getImage('spritesheet'), 0, 0, 34, 47, 2, 18, 40)
    self.animations.shipUp =
        newAnimation(self:getImage('spritesheet'), 68, 0, 34, 47, 2, 16, 32)
    self.animations.shipDown =
        newAnimation(self:getImage('spritesheet'), 136, 0, 34, 47, 2, 16, 32)
    self.animations.shipRight =
        newAnimation(self:getImage('spritesheet'), 0, 63, 34, 47, 2, 18, 40)

    self.animations.explosion =
        newAnimation(self:getImage('spritesheet'), 0, 47, 16, 16, 5, 8, 8)

    print("Images loaded")
end

function ImageManager:getImage(alias)
    return self.images[alias]
end

function ImageManager:getAnimation(alias)
    return self.animations[alias]
end

return ImageManager
