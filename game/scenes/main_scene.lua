require("game.procgen.procgen")
MainScene = Scene:extend()

map_width = 64
map_height = 64

room_max_size = 10
room_min_size = 3
max_rooms = 10

function MainScene:new()
	MainScene.super.new(self)

	self.map = generateDungeon(max_rooms, room_min_size, room_max_size, map_width, map_height)
	self.player = self:addGameObject(
		"Player",
		self.map.player_start_x,
		self.map.player_start_y,
		{ map = self.map, view_radius = 4 }
	)

	local cam_x = math.floor(self.player.vx + tile_size / 2 + gw / 2)
	local cam_y = math.floor(self.player.vy + tile_size / 2 + gh / 2)
	self.camera = Camera(cam_x, cam_y)
end

function MainScene:update(dt)
	MainScene.super.update(self, dt)
	local cam_x = math.floor(self.player.vx + tile_size / 2 + gw / 2)
	local cam_y = math.floor(self.player.vy + tile_size / 2 + gh / 2)
	self.camera:lookAt(cam_x, cam_y)

	self:updateFOV()
end

function MainScene:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()

	self.camera:attach()
	self.map:draw()
	MainScene.super.draw(self)
	self.camera:detach()

	love.graphics.setCanvas()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx or 1, sy or 1)
	love.graphics.setBlendMode("alpha")
end

function MainScene:updateFOV()
	if not self.player or not self.map then return end

	for i = 1, self.map.height do
		for j = 1, self.map.width do
			self.map.visible[i][j] = false
		end
	end

	local px, py = self.player.x, self.player.y
	local radius = self.player.view_radius

	for dx = -radius, radius do
		for dy = -radius, radius do
			local tx, ty = px + dx, py + dy

			engine.math.Bresenham.line(px, py, tx, ty, function(x, y)
				self.map.visible[x][y] = true
				self.map.explored[x][y] = true

				if not self.map:isTileTransparent(x, y) then return false end
				return true
			end)
		end
	end
end
