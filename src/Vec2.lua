local class = require "middleclass"

local Vec2 = class('Vec2')

function Vec2:initialize(x, y)
    self.x, self.y = x, y
end

function Vec2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2:normalize()
    local length = self:length()
    return Vec2:new(self.x / length, self.y / length)
end

function Vec2:add(vec)
    return Vec2:new(self.x + vec.x, self.y + vec.y)
end

function Vec2:sub(vec)
    return Vec2:new(self.x - vec.x, self.y - vec.y)
end

function Vec2:mult(num)
    return Vec2:new(num * self.x, num * self.y)
end

return Vec2
