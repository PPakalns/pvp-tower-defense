local class = require "middleclass"

local Vec2 = require "Vec2"
local Component = require "Component"

local FollowEntity = class('FollowEntity', Component)

function FollowEntity:initialize(targetEntity, followForever, callback)
    Component.initialize(self, 'followEntity', true, false)
    self.callback = callback  -- callback gets executed when target entity is reached
    self.targetReached = false
    self.targetEntity = targetEntity
    self.targetEntityPosComp = targetEntity:getComponent('position')
    self.followForever = followForever
    self.positionComp = nil
    self.moveToComp = nil
end

function FollowEntity:updateTargetPos()
    if not self.targetEntity:isDestroyed() then
        self.moveToComp:setTarget(self.targetEntityPosComp.pos)
    else
        -- Do nothing and allow entity to go to the last position set
    end
end

function FollowEntity:attach(entity)
    Component.attach(self, entity)
    self.moveToComp = entity:getComponent('moveTo')
    self.positionComp = entity:getComponent('position')
    self:updateTargetPos()
end

function FollowEntity:update(dt)
    if not self.targetReached and not self.moveToComp:isTargetSet() then
        self.targetReached = true
        if self.callback ~= nil then
            self.callback(self, self.targetEntity, self.positionComp.pos)
        end
    end

    if (not self.targetReached or self.followForever) then
        self:updateTargetPos()
    end
end

return FollowEntity
