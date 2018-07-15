local class = require "middleclass"

local Component = require "../Component"

local CorrectDirectionAnimation = class('MoveTo', Component)

function CorrectDirectionAnimation:initialize(animationCompName, baseAnimationName, gameContext)
    Component.initialize(self, animationCompName..'CorrectorDirection', true, false)
    self.animationCompName = animationCompName
    self.animationComp = nil
    self.moveToComp = nil
    self.lastDir = nil
    self.animations = {
        gameContext.imageManager:getAnimation(baseAnimationName.."Right"),
        gameContext.imageManager:getAnimation(baseAnimationName.."Down"),
        gameContext.imageManager:getAnimation(baseAnimationName.."Left"),
        gameContext.imageManager:getAnimation(baseAnimationName.."Up"),
    }
end

function CorrectDirectionAnimation:attach(entity)
    Component.attach(self, entity)
    self.animationComp = entity:getComponent(self.animationCompName)
    self.moveToComp = entity:getComponent('moveTo')
end

function CorrectDirectionAnimation:update(dt)
    local lastMovement = self.moveToComp.lastMovement
    if lastMovement == nil then
        return
    end
    local mainDir = lastMovement:getMainDirection()
    if mainDir == self.lastDir then
        return
    end
    self.lastDir = mainDir
    self.animationComp:setAnimation(self.animations[mainDir])
end

return CorrectDirectionAnimation
