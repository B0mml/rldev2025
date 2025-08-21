require("game.components.consumable_component")
LightningScroll = ConsumableComponent:extend()

function LightningScroll:new(entity)
	LightningScroll.super.new(self)
	self.entity = entity
	self.damage = 5
end

function LightningScroll:activate(target)
	inventory_ui:selectTile(1, self)
	return true
end

function LightningScroll:executeAtSelectedTile()
	local tile_x = math.floor(inventory_ui.selected_x / tile_size)
	local tile_y = math.floor(inventory_ui.selected_y / tile_size)

	local entities = inventory_ui.map:getEntitiesAt(tile_x, tile_y)
	local hit_something = false

	for _, entity in ipairs(entities) do
		if entity.fighter_component then
			local target_name = entity.name or "Entity"
			message_log:addMessage(
				target_name .. " was hit by lightning for " .. self.damage .. " damage!",
				{ 1.0, 1.0, 0.0 }
			)
			entity.fighter_component:damage(self.damage)
			hit_something = true
		end
	end

	if not hit_something then message_log:addMessage("You hit nothing", { 0.7, 0.7, 0.7 }) end
end
