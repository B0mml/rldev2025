require("game.components.consumable_component")
FireballScroll = ConsumableComponent:extend()

function FireballScroll:new(entity)
	FireballScroll.super.new(self)
	self.entity = entity
	self.damage = 3
	self.radius = 3
end

function FireballScroll:activate(target)
	inventory_ui:selectTile(self.radius, self)
	return true
end

function FireballScroll:executeAtSelectedTile()
	local center_x = math.floor(inventory_ui.selected_x / tile_size)
	local center_y = math.floor(inventory_ui.selected_y / tile_size)

	local hit_something = false
	local radius = math.floor(self.radius / 2)

	for dx = -radius, radius do
		for dy = -radius, radius do
			local tile_x = center_x + dx
			local tile_y = center_y + dy

			if inventory_ui.map:inbounds(tile_x, tile_y) then
				local entities = inventory_ui.map:getEntitiesAt(tile_x, tile_y)

				for _, entity in ipairs(entities) do
					if entity.fighter_component then
						local target_name = entity.name or "Entity"
						message_log:addMessage(
							target_name .. " was hit by fireball for " .. self.damage .. " damage!",
							{ 1.0, 0.5, 0.0 }
						)
						entity.fighter_component:damage(self.damage)
						hit_something = true
					end
				end

				local player = inventory_ui.map.player
				if player and player.x == tile_x and player.y == tile_y and player.fighter_component then
					message_log:addMessage(
						"You were hit by fireball for " .. self.damage .. " damage!",
						{ 1.0, 0.2, 0.2 }
					)
					player.fighter_component:damage(self.damage)
					hit_something = true
				end
			end
		end
	end

	if not hit_something then message_log:addMessage("You hit nothing", { 0.7, 0.7, 0.7 }) end
end
