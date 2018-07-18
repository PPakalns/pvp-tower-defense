local class = require "middleclass"

local Component = require "Component"

local BasicAttributes = class('BasicAttributes', Component)

function BasicAttributes:initialize(team, params)
    Component.initialize(self, 'basicAttributes', true, false)
    self.team = team
    self.type = params.type
    self.maxHealth = params.health
    self.repair = params.repair
    self.health = params.health or 100
    self.defense = params.defense or 0 -- The ratio of damage that the object avoids
end

function BasicAttributes:update(dt)
    if self.repair ~= nil then
        self.health = math.min(self.maxHealth, self.health + self.repair * dt)
    end
end

function BasicAttributes:applyDamage(damage)
    local damageReceived = (1 - self.defense) * damage
    self.health = self.health - damageReceived
    if self.health <= 0 then
        -- DEAD, sadness
        self.entity.entityManager:destroyEntity(self.entity)
    end
end

return BasicAttributes
