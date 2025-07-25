local sprites = {}

function sprites.createQuad(tileset, tile_x, tile_y, tile_width, tile_height)
	return love.graphics.newQuad(
		tile_x * tile_width,
		tile_y * tile_height,
		tile_width,
		tile_height,
		tileset:getWidth(),
		tileset:getHeight()
	)
end

function sprites.createTileset(image_path, tile_width, tile_height)
	local tileset = {
		image = love.graphics.newImage(image_path),
		quads = {},
	}

	local cols = tileset.image:getWidth() / tile_width
	local rows = tileset.image:getHeight() / tile_height

	for y = 0, rows - 1 do
		for x = 0, cols - 1 do
			local id = y * cols + x + 1
			tileset.quads[id] = sprites.createQuad(tileset.image, x, y, tile_width, tile_height)
		end
	end

	return tileset
end

function sprites.drawTile(sprite, x, y, offset_x, offset_y)
	offset_x = offset_x or 0
	offset_y = offset_y or 0

	love.graphics.draw(sprite.image, sprite.quad, x + offset_x, y + offset_y)
end

return sprites
