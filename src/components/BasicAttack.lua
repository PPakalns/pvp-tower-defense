local class = require "middleclass"

local Component = require "../Component"

local BasicAttack = class('BasicAttack', Component)


function BasicAttack:initialize(gameContext, params, entityCreateCallback)
    Component.initialize(self, 'basicAttack', true, false)
    self.gameContext = gameContext
    self.cworld = gameContext.world.cworld
    self.radius = params.radius
    self.damage = params.damage
    self.timeRemaining = params.reloadSec / 2
    self.reloadSec = params.reloadSec
    self.entityCreateCallback = entityCreateCallback

    self.positionComp = nil
    self.basicAttributesComp = nil
end

function BasicAttack:attach(entity)
    Component.attach(self, entity)
    self.positionComp = entity:getComponent('position')
    self.basicAttributesComp = entity:getComponent('basicAttributes')
end

function BasicAttack:update(dt)
    self.timeRemaining = self.timeRemaining - dt
    if self.timeRemaining > 0 then
        return
    end

    local pos = self.positionComp.pos
    local basicAttributesComp = self.basicAttributesComp

    local items, len = self.cworld:queryRect(pos.x - self.radius,
                                             pos.y - self.radius,
                                             2 * self.radius,
                                             2 * self.radius,
                                             function(item)
        return basicAttributesComp.team ~= item.basicAttributesComp.team
    end)

    if len == 0 then
        return
    end

    local closestEnemy = nil
    local bestLen = math.huge
    for i = 1, len do
        local len = pos:sub(items[i].positionComp.pos):length()
        if len < bestLen then
            closestEnemy = items[i]
            bestLen = len
        end
    end

    self.timeRemaining = self.reloadSec
    self.entityCreateCallback(self.gameContext, self.positionComp.pos, closestEnemy.entity, self.damage)
end

return BasicAttack
