require("game.procgen.procgen")
require("game.ui.render_bar")
require("game.ui.message_log")
require("game.ui.mouse_hover")
require("game.mouse")
MainScene = Scene:extend()

map_width = 64
map_height = 64

room_max_size = 12
room_min_size = 4
max_rooms = 20
max_monsers_per_room = 2
current_monsters = 0

function MainScene:new()
	MainScene.super.new(self)

	self.map = generateDungeon(max_rooms, room_min_size, room_max_size, map_width, map_height, max_monsers_per_room)
	self.player = self:addGameObject(
		"Player",
		self.map.player_start_x,
		self.map.player_start_y,
		{ map = self.map, view_radius = 4 }
	)
	self.map:addPlayer(self.player)

	self.hp_bar = self:addGameObject("RenderBar", 10, 10, {
		total_width = 200,
		total_height = 20,
		min = 0,
		max = self.player.fighter_component.max_hp,
		current = self.player.fighter_component.current_hp,
	})

	message_log = MessageLog()
	message_log:addMessage("Welcome to the Dungeon", { 0, 1, 0, 1 })

	mouse = Mouse()
	self.hovered_entities = {}
	self.mouse_hover = MouseHover()

	local cam_x = math.floor(self.player.vx + tile_size / 2 + gw / 2)
	local cam_y = math.floor(self.player.vy + tile_size / 2 + gh / 2)
	self.camera = Camera(cam_x, cam_y)
end

function MainScene:update(dt)
	MainScene.super.update(self, dt)
	local cam_x = math.floor(self.player.vx + tile_size / 2 + gw / 2)
	local cam_y = math.floor(self.player.vy + tile_size / 2 + gh / 2)
	self.camera:lookAt(cam_x, cam_y)
	self.map:update()

	if self.hp_bar and self.player.fighter_component then
		self.hp_bar:ChangeValue(self.player.fighter_component.current_hp)
	end

	self:updateFOV()

	if input:pressed("log") then
		message_log.expanded = not message_log.expanded
		self.player.frozen = not self.player.frozen

		if not message_log.expanded then message_log:scrollToBottom() end
	end
	if message_log.expanded then
		if input:pressed("down") then
			message_log:scroll(-1)
		elseif input:pressed("up") then
			message_log:scroll(1)
		end
	end

	local entities = mouse:getEntities(self.camera, self.map)
	local tile_x, tile_y = mouse:getTile(self.camera)

	local is_visible = false
	if self.map:inbounds(tile_x, tile_y) and self.map.visible[tile_x] and self.map.visible[tile_x][tile_y] then
		is_visible = true
	end

	if is_visible then self.mouse_hover:update(entities, tile_x, tile_y, self.camera, self.player.x, self.player.y) end
end

function MainScene:entitiesEqual(entities1, entities2)
	if not entities1 or not entities2 then return false end
	if #entities1 ~= #entities2 then return false end

	for i, entity in ipairs(entities1) do
		if entity ~= entities2[i] then return false end
	end
	return true
end

function love.wheelmoved(x, y)
	if message_log.expanded then message_log:scroll(y * 1) end
end

function MainScene:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()

	self.camera:attach()
	self.map:draw()
	for _, object in ipairs(self.game_objects) do
		if object.draw and object ~= self.hp_bar then object:draw() end
	end
	self.camera:detach()

	if self.hp_bar then self.hp_bar:draw() end
	if message_log then message_log:draw() end
	if self.mouse_hover then self.mouse_hover:draw() end

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

function MainScene:handleEnemyTurns()
	for _, entity in ipairs(self.map.entities) do
		entity.ai:perform(self.player.x, self.player.y)
	end
end
