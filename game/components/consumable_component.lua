ConsumableComponent = Object:extend()

function ConsumableComponent:new() ConsumableComponent.super.new(self) end

function ConsumableComponent:get_action()
	-- try to return the action for this item
end

function ConsumableComponent:activate()
	-- invoke this items ability
end
