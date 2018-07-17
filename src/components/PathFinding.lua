local class = require "middleclass"

local Component = require "../Component"
local Vec2 = require "../Vec2"

local PathFinding = class('PathFinding', Component)

function PathFinding:initialize(world)
    Component.initialize(self, 'pathFinding', true, false)
    self.world = world
    self.lastTile = nil
end

function PathFinding:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
    self.moveToComp = entity:getComponent('moveTo')
    self.basicAttributesComp = entity:getComponent('basicAttributes')
end

function PathFinding:update(dt)
    local tileNow = self.world:getTileCoord(self.positionComp.pos)
    if self.lastTile == nil or not tileNow:integerEqual(self.lastTile) then
        self.lastTile = tileNow
        self.moveToComp:setTarget(
            self.world:getNextCellMiddle(self.positionComp.pos, self.basicAttributesComp.team)
            )
    end
end

return PathFinding
