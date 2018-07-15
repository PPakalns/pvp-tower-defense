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

function Vec2:set(vec)
    self.x, self.y = vec.x, vec.y
end

function Vec2:selfAdd(vec)
    self.x, self.y = self.x + vec.x, self.y + vec.y
    return self
end

function Vec2:isZero()
    return self.x == 0 and self.y == 0
end

function Vec2:getMainDirection()
    local res = 0
    if self:isZero() then
        return res
    end

    if math.abs(self.y) > math.abs(self.x)  then
        if self.y > 0 then
            res = 2
        else
            res = 4
        end
    else
        if self.x > 0 then
            res = 1
        else
            res = 3
        end
    end
    return res
end

Vec2.static.getMainDirectionVector = function(dir)
    if dir == 1 then
        return Vec2:new(1, 0)
    elseif dir == 2 then
        return Vec2:new(0, 1)
    elseif dir == 3 then
        return Vec2:new(-1, 0)
    else
        return Vec2:new(0, -1)
    end
end

return Vec2
