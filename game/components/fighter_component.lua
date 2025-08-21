FighterComponent = Object:extend()

function FighterComponent:new(entity, max_hp, attack, defense)
	self.entity = entity
	self.max_hp = max_hp
	self.current_hp = max_hp
	self.attack = attack
	self.defense = defense
end

function FighterComponent:damage(value)
	self.current_hp = self.current_hp - value

	if self.current_hp <= 0 then self.entity:die() end
end

function FighterComponent:heal(value) self.current_hp = math.min(self.current_hp + value, self.max_hp) end
