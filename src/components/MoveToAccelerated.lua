local class = require "middleclass"

local Vec2 = require "Vec2"
local MoveTo = require 'components/MoveTo'

local MoveToAccelerated = class('MoveToAccelerated', MoveTo)

-- acc      - acceleration that can be applied to speed up object
-- brakeAcc - acceleration that always applies and tries to stop object
--          | Must be negative!!!

function calcDrag(vec, dt, brakeAcc)
    if vec:isZero() then
        return Vec2:new(0, 0)
    end
    return vec:normalize():mult(brakeAcc * dt):limit(vec:length())
end

function MoveToAccelerated:initialize(maxSpeed, acc, brakeAcc)
    MoveTo.initialize(self, maxSpeed)
    self.brakeAcc = brakeAcc
    self.acc = acc
    self.speed = Vec2:new(0, 0)
end

function MoveToAccelerated:update(dt)
    if self.target == nil then
        if self.speed:isZero() then
            self.lastMovement = nil
            return
        end
        self.speed:selfAdd(calcDrag(self.speed, dt, self.brakeAcc))
    else
        local delta = self.target:sub(self.positionComp.pos)

        -- Aproximate stopping
        if delta:length() < 5 and self.speed:length() < 20 then
            self.positionComp.pos:set(self.target)
            self.lastMovement = delta
            self:setTarget(nil)
            self.speed:setZero()
            return
        end

        -- Check that object can stop in time with increased
        -- acceleration
        local newSpeed = self.speed:clone()
        if not delta:isZero() then
            newSpeed:selfAdd(delta:normalize():mult(self.acc * dt))
        end
        newSpeed:selfAdd(calcDrag(newSpeed, dt, self.brakeAcc))
        newSpeed = newSpeed:limit(self.maxSpeed)

        local projectedSpeed = newSpeed:projection(delta)
        local distNeededToStop = (projectedSpeed * projectedSpeed) / (self.brakeAcc)

        if distNeededToStop + projectedSpeed * dt > delta:length() then
            -- Will not accelerate
            self.speed:selfAdd(calcDrag(self.speed, dt, self.brakeAcc))
        else
            -- Accelerate
            self.speed = newSpeed
        end
    end

    self.lastMovement = self.speed:mult(dt)
    self.positionComp.pos:selfAdd(self.lastMovement)
end

return MoveToAccelerated
