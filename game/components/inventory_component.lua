InventoryComponent = Object:extend()

function InventoryComponent:new(capacity)
	InventoryComponent.super.new(self)
	self.capacity = capacity
	self.items = {}
end

function InventoryComponent:drop(item)
	-- remove an Item from inventory
end
