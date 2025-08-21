require("game.components.ai_component")
ConfusedAI = AiComponent:extend()

function ConfusedAI:new(entity) ConfusedAI.super.new(self, entity) end

function ConfusedAI:perform()
	if self.entity.fighter_component.current_hp <= 0 then return end

	local directions = {
		{ x = -1, y = 0 }, -- left
		{ x = 1, y = 0 }, -- right
		{ x = 0, y = -1 }, -- up
		{ x = 0, y = 1 }, -- down
		{ x = -1, y = -1 }, -- up-left
		{ x = 1, y = -1 }, -- up-right
		{ x = -1, y = 1 }, -- down-left
		{ x = 1, y = 1 }, -- down-right
	}

	for i = 1, #directions do
		local random_index = love.math.random(#directions)
		local dir = directions[random_index]

		local new_x = self.entity.x + dir.x
		local new_y = self.entity.y + dir.y

		local player = self.entity.gamemap.player
		local player_at_position = player and player.x == new_x and player.y == new_y
		
		if self.entity.gamemap:inbounds(new_x, new_y) and not self.entity.gamemap:isBlocked(new_x, new_y) and not player_at_position then
			self.entity:move_to(new_x, new_y)
			return
		end

		table.remove(directions, random_index)
	end
end
