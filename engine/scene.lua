local Scene = Object:extend()

function Scene:new()
	self.game_objects = {}
	self.timer = Timer()
	self.main_canvas = love.graphics.newCanvas(gw, gh)
end

function Scene:update(dt)
	if self.timer then self.timer:update(dt) end

	for i = #self.game_objects, 1, -1 do
		local game_object = self.game_objects[i]
		game_object:update(dt)
		if game_object.dead then
			game_object:destroy()
			table.remove(self.game_objects, i)
		end
	end
end

function Scene:draw()
	table.sort(self.game_objects, function(a, b)
		if a.depth == b.depth then return a.creation_time < b.creation_time end
		return a.depth < b.depth
	end)

	for _, game_object in ipairs(self.game_objects) do
		game_object:draw()
	end
end

function Scene:addGameObject(game_object_type, x, y, opts)
	local opts = opts or {}
	local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
	table.insert(self.game_objects, game_object)
	return game_object
end

function Scene:getAllGameObjectsThat(filter)
	local out = {}
	for _, game_object in pairs(self.game_objects) do
		if filter(game_object) then table.insert(out, game_object) end
	end
	return out
end

function Scene:getAllGameObjectsOfType(game_object_type)
	return self:getAllGameObjectsThat(
		function(obj) return obj.class_name == game_object_type or obj:is(_G[game_object_type]) end
	)
end

function Scene:removeGameObject(game_object)
	for i, obj in ipairs(self.game_objects) do
		if obj == game_object then
			obj:destroy()
			table.remove(self.game_objects, i)
			return true
		end
	end
	return false
end

function Scene:remove()
	for i = #self.game_objects, 1, -1 do
		local game_object = self.game_objects[i]
		game_object:destroy()
		table.remove(self.game_objects, i)
	end

	if self.timer then
		self.timer:destroy()
		self.timer = nil
	end

	if self.main_canvas then
		self.main_canvas:release()
		self.main_canvas = nil
	end

	self.game_objects = nil
	self.room = nil
end

return Scene
