Player = GameObject:extend()

function Player:new(scene, x, y, opts)
	Player.super.new(self, scene, x, y, opts)

	-- collision
	self.map = opts.map

	-- visual
	self.vx, self.vy = self.x * tile_size, self.y * tile_size
	self.sprite = {
		image = tilesets["rogues"].image,
		quad = tilesets["rogues"].quads[1],
	}
end

function Player:update(dt)
	Player.super.update(self, dt)

	self:handleMovement()
end

function Player:draw() engine.sprites.drawTile(self.sprite, self.vx, self.vy) end

function Player:handleMovement()
	if self.movement_tween then return end
	local new_x, new_y = self.x, self.y

	local has_moved = false

	if input:down("left") then
		new_x = self.x - 1
		has_moved = true
	end
	if input:down("right") then
		new_x = self.x + 1
		has_moved = true
	end
	if input:down("up") then
		new_y = self.y - 1
		has_moved = true
	end
	if input:down("down") then
		new_y = self.y + 1
		has_moved = true
	end

	if not has_moved then return end

	local tile = self.map:getTile(new_x, new_y)

	if not tile.walkable then return end

	self.x, self.y = new_x, new_y

	if self.movement_tween then self.timer:cancel(self.movement_tween) end
	self.movement_tween = self.timer:tween(
		0.1,
		self,
		{ vx = self.x * tile_size, vy = self.y * tile_size },
		"linear",
		function() self.movement_tween = nil end
	)
end
