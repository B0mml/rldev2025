Player = GameObject:extend()

function Player:new(scene, x, y, opts)
	Player.super.new(self, scene, x, y, opts)

	self.fighter_component = FighterComponent(self, 10, 1, 0)
	self.view_radius = self.view_radius or 8

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
	if self.movement_tween then return end

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
	entity.fighter_component:damage(self.fighter_component.attack)
	print(entity.fighter_component.current_hp)

	self.scene:handleEnemyTurns()
end

function Player:die() self.dead = true end
