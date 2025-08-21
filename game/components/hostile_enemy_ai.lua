require("game.components.ai_component")
HostileEnemyAI = AiComponent:extend()

function HostileEnemyAI:new(entity) HostileEnemyAI.super.new(self, entity) end

function HostileEnemyAI:perform()
	if self.entity.fighter_component.current_hp <= 0 then return end
	local player = self.entity.gamemap.player or nil
	if player == nil then return end
	local visible = self.entity.gamemap.visible[self.entity.x][self.entity.y]
	if not visible then
		if DEBUG then print("not visible") end
		return
	end

	if self:get_distance_to(player.x, player.y) <= 1 then
		self:attack(player)
		return
	end
	self:move_along_path(player.x, player.y)
end

function HostileEnemyAI:attack(target)
	message_log:addMessage(
		self.entity.name .. " hit you for " .. self.entity.fighter_component.attack .. " damage!",
		hp_bar_fg
	)
	target.fighter_component:damage(self.entity.fighter_component.attack)
end
