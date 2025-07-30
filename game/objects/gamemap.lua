require("tile_types")

GameMap = Object:extend()

function GameMap:new(width, height)
	self.width = width or 64
	self.height = height or 64
	self.tiles = {}
	self.visible = {}
	self.explored = {}
	self.entities = {}


	for i = 1, self.height do
		self.visible[i] = {}
		for j = 1, self.width do
			self.visible[i][j] = false
		end
	end

	for i = 1, self.height do
		self.explored[i] = {}
		for j = 1, self.width do
			self.explored[i][j] = false
		end
	end

	for i = 1, self.height do
		self.tiles[i] = {}
		for j = 1, self.width do
			self.tiles[i][j] = tile_types.wall
		end
	end
end

function GameMap:inbounds(x, y) return x >= 1 and x <= self.width and y >= 1 and y <= self.height end

function GameMap:getTile(x, y)
	if not self:inbounds(x, y) then return tile_types.wall end
	return self.tiles[y][x]
end

function GameMap:isTileTransparent(x, y)
	local tile = self:getTile(x, y)
	return tile.transparent
end

function GameMap:isBlocked(x, y)
	local tile = self:getTile(x, y)
	if not tile.walkable then
		return true
	end

	for _, entity in ipairs(self.entities) do
		if entity.blocks_movement and entity.x == x and entity.y == y then
			return entity
		end
	end

	return false
end

function GameMap:getEntityAt(x, y)
	for _, entity in ipairs(self.entities) do
		if entity.x == x and entity.y == y then
			return entity
		end
	end
	return nil
end

function GameMap:getSprite(tile)
	if not tile.type then return nil end

	local sprite_def = tile_sprite_definition[tile.type]

	if not sprite_def then return nil end

	if not tilesets[sprite_def.tileset] then
		print("error: tileset not found:", sprite_def.tileset)
		return nil
	end

	return {
		image = tilesets[sprite_def.tileset].image,
		quad = tilesets[sprite_def.tileset].quads[sprite_def.quad_id],
	}
end

function GameMap:update(dt)
	for i = #self.entities, 1, -1 do
		local entity = self.entities[i]
		if entity.dead then
			entity:die()
			print("aua")
			table.remove(self.entities, i)
		else
			entity:update(dt)
		end
	end
end

function GameMap:draw()
	for i = 1, self.height do
		for j = 1, self.width do
			local tile = self.tiles[i][j]
			local visible = self.visible[j][i]
			local explored = self.explored[j][i]
			local visual_x = j * tile_size
			local visual_y = i * tile_size
			local sprite = self:getSprite(tile)
			if sprite and visible then
				engine.sprites.drawTile(sprite, visual_x, visual_y)
			elseif sprite and explored then
				love.graphics.setColor(fog_color)
				engine.sprites.drawTile(sprite, visual_x, visual_y)
				love.graphics.setColor(default_color)
			end
		end
	end

	for _, entity in ipairs(self.entities) do
		if self.visible[entity.x] and self.visible[entity.x][entity.y] then
			entity:draw()
		end
	end
end
