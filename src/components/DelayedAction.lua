local class = require "middleclass"

local Component = require "../Component"
local DelayedAction = class('DelayedAction', Component)

-- Runs the action in callback after 'delay' seconds,
-- and then removes itself from entity

-- callback function will receive entity as argument

function DelayedAction:initialize(actionName, delay, callback, loop)
    Component.initialize(self, actionName, true, false)
    self.delay = delay
    self.loop = (loop and true or false)
    self.remaining = delay
    self.callback = callback

    self.localTable = {}
end

function DelayedAction:update(dt)
    self.remaining = self.remaining - dt
    if self.remaining < 0 then
        -- execute callback
        self.callback(self.entity, self.localTable)
        if self.loop then
            self.remaining = self.delay
        else
            self.entity:removeComponent(self)
        end
    end
end

return DelayedAction
