local class = require "middleclass"

local Component = require "../Component"
local HealthBar = class('HealthBar', Component)

function HealthBar:initialize()
	Component.initialize(self, 'healthBar', false, true)
	self.position = nil
	self.attributes = nil
end

function HealthBar:attach(entity)
	Component.attach(self, entity)
	self.position = entity:getComponent('position')
	self.attributes = entity:getComponent('basicAttributes')
end

function HealthBar:draw()
	local maxHP = self.attributes.maxHealth
	local health = self.attributes.health
	
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle(
		'fill', 
		self.position.pos.x-16,
		self.position.pos.y+10,
		32,
		5
		)
	
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.rectangle(
		'fill', 
		self.position.pos.x-16,
		self.position.pos.y+10,
		(health/maxHP)*32,
		5
		)
end

return HealthBar