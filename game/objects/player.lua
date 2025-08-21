Player = GameObject:extend()

function Player:new(scene, x, y, opts)
	Player.super.new(self, scene, x, y, opts)

	self.fighter_component = FighterComponent(self, 10, 1, 0)
	self.inventory_component = InventoryComponent(10)
	self.view_radius = self.view_radius or 8
	self.frozen = false

	-- collision
	self.map = opts.map

	-- visual
	self.vx, self.vy = self.x * tile_size, self.y * tile_size
	self.sprite = {
		image = tilesets["rogues"].image,
		quad = tilesets["rogues"].quads[1],
	}
	self.move_repeat_timer = nil
	self.held_dir = nil
end

function Player:update(dt)
	Player.super.update(self, dt)

	self:handleMovementInput()
end

function Player:draw() engine.sprites.drawTile(self.sprite, self.vx, self.vy) end

function Player:handleMovementInput()
	if self.frozen then return end
	if self.movement_tween then return end

	if inventory_ui and (inventory_ui.visible or inventory_ui.select_mode) then
		if input:pressed("up") then
			inventory_ui:handleInput("up")
			return
		end
		if input:pressed("down") then
			inventory_ui:handleInput("down")
			return
		end
		if input:pressed("left") then
			inventory_ui:handleInput("left")
			return
		end
		if input:pressed("right") then
			inventory_ui:handleInput("right")
			return
		end
		if input:pressed("action") then
			inventory_ui:handleInput("return")
			return
		end
		if input:pressed("pickup") then
			inventory_ui:handleInput("x")
			return
		end
		if input:pressed("inventory") then
			inventory_ui:handleInput("i")
			return
		end
		return
	end

	if input:pressed("pickup") then
		local items_on_tile = self:getItemsOnTile()
		if #items_on_tile > 0 then self:pickupItems() end
		return
	end

	if input:pressed("skip_turn") then
		self.scene:handleEnemyTurns()
		return
	end

	if input:pressed("inventory") then
		if inventory_ui then inventory_ui:toggle() end
		return
	end

	local directions = {
		left = { x = -1, y = 0 },
		right = { x = 1, y = 0 },
		up = { x = 0, y = -1 },
		down = { x = 0, y = 1 },
	}

	for dir, delta in pairs(directions) do
		if input:pressed(dir) then
			self.held_direction = dir
			self:attemptMove(delta.x, delta.y)
			self:startMoveRepeat(dir, delta)
			return
		end
	end
end

function Player:attemptMove(dx, dy)
	local new_x, new_y = self.x + dx, self.y + dy

	local blocked_by = self.map:isBlocked(new_x, new_y)
	if blocked_by then
		if type(blocked_by) == "table" and blocked_by.name then
			self:attack(blocked_by)
			self:stopMoveRepeat()
		end
		return
	end

	self.x, self.y = new_x, new_y

	if self.movement_tween then self.timer:cancel(self.movement_tween) end
	self.movement_tween = self.timer:tween(
		0.1,
		self,
		{ vx = self.x * tile_size, vy = self.y * tile_size },
		"linear",
		function() self.movement_tween = nil end
	)

	self.scene:handleEnemyTurns()
end

function Player:startMoveRepeat(dir, delta)
	self:stopMoveRepeat()

	self.move_repeat_timer = self.timer:every(0.2, function()
		if input:down(dir) then
			self:attemptMove(delta.x, delta.y)
		else
			self:stopMoveRepeat()
		end
	end)
end

function Player:stopMoveRepeat()
	if self.move_repeat_timer then
		self.timer:cancel(self.move_repeat_timer)
		self.move_repeat_timer = nil
	end
end

function Player:attack(entity)
	message_log:addMessage("You hit " .. entity.name .. " for " .. self.fighter_component.attack .. " damage!")
	entity.fighter_component:damage(self.fighter_component.attack)

	self.scene:handleEnemyTurns()
end

function Player:die()
	message_log:addMessage("You Died! ", hp_bar_fg)
	self.dead = true
	local corpse = entity_templates.corpse:spawn(self.map, self.x, self.y)
	corpse.name = "Your Remains"
end

function Player:getItemsOnTile()
	if not self.map or not self.map.entities then return {} end

	local items = {}
	for _, entity in ipairs(self.map.entities) do
		if entity.x == self.x and entity.y == self.y then
			if entity.tags and M.include(entity.tags, "item") then table.insert(items, entity) end
		end
	end
	return items
end

function Player:pickupItems()
	if not self.map or not self.map.entities then return end

	local items_picked_up = {}
	for i = #self.map.entities, 1, -1 do
		local entity = self.map.entities[i]
		if entity.x == self.x and entity.y == self.y and entity.tags and M.include(entity.tags, "item") then
			table.insert(self.inventory_component.items, entity)
			table.insert(items_picked_up, entity.name)
			table.remove(self.map.entities, i)
		end
	end

	if #items_picked_up > 0 then
		for _, item_name in ipairs(items_picked_up) do
			message_log:addMessage("Picked up " .. item_name)
		end
	end
end
