function loadTilesets()
	tilesets = {
		["rogues"] = engine.sprites.createTileset("game/assets/rogues.png", tile_size, tile_size),
		["tiles"] = engine.sprites.createTileset("game/assets/tiles.png", tile_size, tile_size),
		["monsters"] = engine.sprites.createTileset("game/assets/monsters.png", tile_size, tile_size),
		["items"] = engine.sprites.createTileset("game/assets/items.png", tile_size, tile_size),
	}
end

--@param walkable: true if this tile can be walked over
--@param transparent: true if this tile doesnt block line of sight
--@param type_name: internal name of the tile
function tile(walkable, transparent, type_name)
	return { walkable = walkable, transparent = transparent, type = type_name }
end

tile_types = {
	floor = tile(true, true, "floor"),
	floor_alt = tile(true, true, "floor_alt"),
	wall = tile(false, false, "wall"),
	wall_front = tile(false, false, "wall_front"),
}

tile_sprite_definition = {
	--Tilesize width * tile_y * tile_x
	floor = { tileset = "tiles", quad_id = 17 * 6 + 1 },
	floor_alt = { tileset = "tiles", quad_id = 17 * 12 + 1 },
	wall = { tileset = "tiles", quad_id = 17 * 2 + 1 },
	wall_front = { tileset = "tiles", quad_id = 17 * 2 + 2 },
}
