local Pathfinder = require("engine.libraries.jumper.pathfinder")

AiComponent = Object:extend()

function AiComponent:new(entity) self.entity = entity end

-- TODO: perform()

function AiComponent:get_path_to(end_x, end_y)
	local myFinder = Pathfinder(self.entity.gamemap.grid, "ASTAR", self.entity.gamemap.walkable)

	local path = myFinder:getPath(self.entity.x, self.entity.y, end_x, end_y)
	if path then
		local path_coords = {}
		for node, count in path:nodes() do
			table.insert(path_coords, { x = node.x or node[1], y = node.y or node[2] })
		end

		return path_coords
	end
	return nil
end

function AiComponent:move_along_path(target_x, target_y)
	local path_coords = self:get_path_to(target_x, target_y)

	if path_coords and #path_coords > 1 then
		local next_step = path_coords[2]

		self.entity:move_to(next_step.x, next_step.y)
		return true
	end

	return false
end
