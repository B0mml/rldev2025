require("game.components.consumable_component")
HealthPotion = ConsumableComponent:extend()

function HealthPotion:new(entity)
	HealthPotion.super.new(self)
	self.entity = entity
	self.amount = 5
end

function HealthPotion:activate(target)
	if target and target.fighter_component then
		target.fighter_component:heal(self.amount)
		local target_name = target.name or "Player"
		message_log:addMessage(target_name .. " healed for " .. self.amount .. " HP!", { 0.0, 1.0, 0.0 })

		if self.entity and self.entity.gamemap then
			for i, entity in ipairs(self.entity.gamemap.entities) do
				if entity == self.entity then
					table.remove(self.entity.gamemap.entities, i)
					break
				end
			end
		end
		return true
	end
	return false
end
