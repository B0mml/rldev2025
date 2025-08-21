require("game.objects.gamemap")

RectangularRoom = Object:extend()

function RectangularRoom:new(x, y, width, height)
	self.x1 = x
	self.y1 = y
	self.x2 = x + width
	self.y2 = y + height
end

function RectangularRoom:center()
	center_x = math.floor((self.x1 + self.x2) / 2)
	center_y = math.floor((self.y1 + self.y2) / 2)

	return center_x, center_y
end

function RectangularRoom:inner()
	return {
		x1 = self.x1 + 1,
		x2 = self.x2,
		y1 = self.y1 + 1,
		y2 = self.y2,
	}
end

function RectangularRoom:intersects(other)
	return (self.x1 <= other.x2 and self.x2 >= other.x1 and self.y1 <= other.y2 and self.y2 >= other.y1)
end

local function createRoom(room, tile_type)
	local inner = room:inner()
	for x = inner.x1, inner.x2 - 1 do
		for y = inner.y1, inner.y2 - 1 do
			if (x + y) % 2 == 0 then
				dungeon.tiles[y][x] = tile_types.floor
			else
				dungeon.tiles[y][x] = tile_types.floor_alt
			end
		end
	end
end

function place_entities(room, dungeon, max_monsters, max_items)
	local number_of_monsters = love.math.random(0, max_monsters)
	local number_of_items = love.math.random(0, max_items)

	for i = 1, number_of_monsters do
		x = love.math.random(room.x1 + 1, room.x2 - 1)
		y = love.math.random(room.y1 + 1, room.y2 - 1)

		if DEBUG then
			if current_monsters >= 1 then return end
		end
		if not M.include(dungeon.entities, function(e) return e.x == x and e.y == y end) then
			if engine.math.random() < 0.7 then
				entity_templates.goblin:spawn(dungeon, x, y)
			else
				entity_templates.ogre:spawn(dungeon, x, y)
			end
			current_monsters = current_monsters + 1
		end
	end

	for i = 1, number_of_items do
		x = love.math.random(room.x1 + 1, room.x2 - 1)
		y = love.math.random(room.y1 + 1, room.y2 - 1)

		if not M.include(dungeon.entities, function(e) return e.x == x and e.y == y end) then
			local roll = love.math.random(1, 100)

			if roll <= 40 then
				entity_templates.health_potion:spawn(dungeon, x, y)
			elseif roll <= 70 then
				entity_templates.lightning_scroll:spawn(dungeon, x, y)
			elseif roll <= 90 then
				entity_templates.confusion_scroll:spawn(dungeon, x, y)
			else
				entity_templates.fireball_scroll:spawn(dungeon, x, y)
			end
		end
	end
end

local function tunnelBetween(start_x, start_y, end_x, end_y)
	x1, y1 = start_x, start_y
	x2, y2 = end_x, end_y
	if engine.math.random() < 0.5 then
		corner_x, corner_y = x2, y1
	else
		corner_x, corner_y = x1, y2
	end

	engine.math.Bresenham.line(x1, y1, corner_x, corner_y, function(x, y)
		if dungeon:inbounds(x, y) then
			if (x + y) % 2 == 0 then
				dungeon.tiles[y][x] = tile_types.floor
			else
				dungeon.tiles[y][x] = tile_types.floor_alt
			end
		end
		return true
	end)

	engine.math.Bresenham.line(corner_x, corner_y, x2, y2, function(x, y)
		if dungeon:inbounds(x, y) then
			if (x + y) % 2 == 0 then
				dungeon.tiles[y][x] = tile_types.floor
			else
				dungeon.tiles[y][x] = tile_types.floor_alt
			end
		end
		return true
	end)
end

function generateDungeon(
	max_rooms,
	room_min_size,
	room_max_size,
	map_width,
	map_height,
	max_monsters_per_room,
	max_items_per_room
)
	dungeon = GameMap(map_width, map_height)

	rooms = {}

	for i = 1, max_rooms do
		room_width = love.math.random(room_min_size, room_max_size)
		room_height = love.math.random(room_min_size, room_max_size)

		x = love.math.random(1, dungeon.width - room_width - 1)
		y = love.math.random(1, dungeon.height - room_height - 1)

		new_room = RectangularRoom(x, y, room_width, room_height)

		if M.include(rooms, function(o) return new_room:intersects(o) end) then goto continue end

		createRoom(new_room, tile_types.floor)

		if #rooms == 0 then
			dungeon.player_start_x, dungeon.player_start_y = new_room:center()
		else
			local prev_center_x, prev_center_y = rooms[#rooms]:center()
			local new_center_x, new_center_y = new_room:center()
			tunnelBetween(prev_center_x, prev_center_y, new_center_x, new_center_y)
		end
		place_entities(new_room, dungeon, max_monsters_per_room, max_items_per_room)

		table.insert(rooms, new_room)
		::continue::
	end

	return dungeon
end
