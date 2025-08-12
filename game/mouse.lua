Mouse = Object:extend()

function Mouse:new() Mouse.super.new(self) end

function Mouse:getTile(camera)
	local mouse_x, mouse_y = love.mouse.getPosition()

	local scale = sx or 1
	mouse_x = mouse_x / scale
	mouse_y = mouse_y / scale

	local world_x, world_y = camera:worldCoords(mouse_x, mouse_y)

	local tile_x = math.floor(world_x / tile_size)
	local tile_y = math.floor(world_y / tile_size)

	return tile_x, tile_y
end

function Mouse:getEntities(camera, map)
	local tile_x, tile_y = self:getTile(camera)
	return map:getEntitiesAt(tile_x, tile_y)
end
