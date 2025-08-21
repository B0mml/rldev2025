require("game.components.consumable_component")
require("game.components.confused_ai")
ConfusionScroll = ConsumableComponent:extend()

function ConfusionScroll:new(entity)
	ConfusionScroll.super.new(self)
	self.entity = entity
end

function ConfusionScroll:activate(target)
	inventory_ui:selectTile(1, self)
	return true
end

function ConfusionScroll:executeAtSelectedTile()
	local tile_x = math.floor(inventory_ui.selected_x / tile_size)
	local tile_y = math.floor(inventory_ui.selected_y / tile_size)

	local entities = inventory_ui.map:getEntitiesAt(tile_x, tile_y)
	local hit_something = false

	for _, entity in ipairs(entities) do
		if entity.ai and entity.ai_type and entity.ai_type ~= ConfusedAI then
			entity.original_ai_type = entity.ai_type
			entity.original_ai = entity.ai
			entity.confusion_turns = love.math.random(5, 10)

			entity.ai_type = ConfusedAI
			entity.ai = ConfusedAI(entity)

			local target_name = entity.name or "Entity"
			message_log:addMessage(target_name .. " is confused!", { 1.0, 0.5, 1.0 })
			hit_something = true
		end
	end

	if not hit_something then message_log:addMessage("You hit nothing", { 0.7, 0.7, 0.7 }) end
end
