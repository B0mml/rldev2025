InventoryUI = Object:extend()

function InventoryUI:new()
	InventoryUI.super.new(self)
	self.total_width = 300
	self.total_height = 400
	self.visible = false
	self.scroll_offset = 0
	self.selected_index = 1
end

function InventoryUI:draw()
	if not self.visible then return end

	local bg_color = { 12 / 255, 19 / 255, 23 / 255, 0.9 }
	local border_color = { 90 / 255, 88 / 255, 117 / 255, 1 }
	local selection_color = { 50 / 255, 50 / 255, 80 / 255, 0.8 }

	local start_x = (gw - self.total_width) / 2
	local start_y = (gh - self.total_height) / 2

	love.graphics.setColor(bg_color)
	love.graphics.rectangle("fill", start_x, start_y, self.total_width, self.total_height)
	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", start_x, start_y, self.total_width, self.total_height)

	love.graphics.setColor(default_color)
	love.graphics.print("Inventory", start_x + 10, start_y + 10)

	self:renderItems(start_x, start_y + 30, self.total_width, self.total_height - 30)
end

function InventoryUI:renderItems(start_x, start_y, width, height)
	local padding = 10
	local line_height = 20
	local max_lines = math.floor((height - padding) / line_height)

	local inventory = self:getPlayerInventory()
	if not inventory then
		love.graphics.setColor(default_color)
		love.graphics.print("No inventory available", start_x + padding, start_y + padding)
		return
	end

	local items = inventory.items or {}
	if #items == 0 then
		love.graphics.setColor(default_color)
		love.graphics.print("Inventory is empty", start_x + padding, start_y + padding)
		return
	end

	local start_index = math.max(1, self.selected_index - max_lines + 1)
	local current_y = start_y + padding

	for i = start_index, math.min(#items, start_index + max_lines - 1) do
		local item = items[i]
		local is_selected = (i == self.selected_index)

		if is_selected then
			love.graphics.setColor({ 50 / 255, 50 / 255, 80 / 255, 0.8 })
			love.graphics.rectangle("fill", start_x + 5, current_y - 2, width - 10, line_height)
		end

		love.graphics.setColor(default_color)
		local item_text = item.name or "Unknown Item"
		if item.consumable and item.consumable.activate then item_text = item_text .. " [usable]" end
		love.graphics.print(item_text, start_x + padding, current_y)

		current_y = current_y + line_height
	end

	love.graphics.setColor({ 0.7, 0.7, 0.7, 1 })
	love.graphics.print("Use: Enter/x, Close: i/Escape", start_x + padding, start_y + height - 30)
end

function InventoryUI:getPlayerInventory()
	if self.player and self.player.inventory_component then return self.player.inventory_component end
	return nil
end

function InventoryUI:toggle()
	self.visible = not self.visible
	if self.visible then
		self.selected_index = 1
		self.scroll_offset = 0
	end
end

function InventoryUI:show()
	self.visible = true
	self.selected_index = 1
	self.scroll_offset = 0
end

function InventoryUI:hide() self.visible = false end

function InventoryUI:handleInput(key)
	if not self.visible then return false end

	local inventory = self:getPlayerInventory()
	if not inventory or not inventory.items then return true end

	local items = inventory.items

	if key == "up" and self.selected_index > 1 then
		self.selected_index = self.selected_index - 1
	elseif key == "down" and self.selected_index < #items then
		self.selected_index = self.selected_index + 1
	elseif key == "return" or key == "kpenter" then
		self:useSelectedItem()
	elseif key == "x" then
		self:useSelectedItem()
	elseif key == "i" or key == "escape" then
		self:hide()
	end

	return true
end

function InventoryUI:useSelectedItem()
	local inventory = self:getPlayerInventory()
	if not inventory or not inventory.items then return end

	local items = inventory.items
	if self.selected_index < 1 or self.selected_index > #items then return end

	local item = items[self.selected_index]

	if item and item.consumable and item.consumable.activate then
		if item.consumable:activate(self.player) then
			table.remove(items, self.selected_index)

			if self.selected_index > #items and #items > 0 then
				self.selected_index = #items
			elseif #items == 0 then
				self.selected_index = 1
			end
		end
	else
		message_log:addMessage("Cannot use " .. (item.name or "this item"))
	end
end
