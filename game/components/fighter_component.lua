FighterComponent = Object:extend()

function FighterComponent:new(entity, max_hp, attack, defense, xp_given)
	self.entity = entity
	self.max_hp = max_hp
	self.current_hp = max_hp
	self.attack = attack
	self.defense = defense
	self.xp_given = xp_given or 0
	
	if entity.name == "Player" or (entity.tags and M.include(entity.tags, "player")) then
		self.level = 1
		self.xp = 0
		self.level_up_base = 200
		self.level_up_factor = 150
	end
end

function FighterComponent:damage(value)
	self.current_hp = self.current_hp - value

	if self.current_hp <= 0 then self.entity:die() end
end

function FighterComponent:heal(value) self.current_hp = math.min(self.current_hp + value, self.max_hp) end

function FighterComponent:experience_to_next_level()
	if not self.level then return nil end
	return self.level_up_base + self.level * self.level_up_factor
end

function FighterComponent:requires_level_up()
	if not self.level then return false end
	return self.xp >= self:experience_to_next_level()
end

function FighterComponent:add_xp(xp)
	if not self.level then return end
	self.xp = self.xp + xp
	
	if xp > 0 then
		message_log:addMessage("You gain " .. xp .. " experience points.")
	end
	
	if self:requires_level_up() then
		if level_up_ui then
			level_up_ui:show()
		end
	end
end

function FighterComponent:level_up()
	self.xp = self.xp - self:experience_to_next_level()
	self.level = self.level + 1
	
	message_log:addMessage("You advance to level " .. self.level .. "!")
end

function FighterComponent:increase_max_hp(amount)
	self.max_hp = self.max_hp + amount
	self.current_hp = self.current_hp + amount
end

function FighterComponent:increase_attack(amount)
	self.attack = self.attack + amount
end

function FighterComponent:increase_defense(amount)
	self.defense = self.defense + amount
end
