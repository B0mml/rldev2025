MouseHover = Object:extend()

function MouseHover:new()
	MouseHover.super.new(self)
	self.visible = false
	self.entities = {}
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	self.padding = 8
	self.line_height = 16
	self.font = love.graphics.getFont()
end

function MouseHover:update(entities, tile_x, tile_y, camera, player_x, player_y)
	if message_log and message_log.expanded then
		self.visible = false
		return
	end
	if #entities > 0 then
		self.visible = true
		self.entities = entities

		local world_x = tile_x * tile_size
		local world_y = tile_y * tile_size
		local screen_x, screen_y = camera:cameraCoords(world_x, world_y)

		local max_width = 0
		for _, entity in ipairs(entities) do
			local text_width = self.font:getWidth(entity.name)
			if text_width > max_width then max_width = text_width end
		end

		self.width = max_width + (self.padding * 2)
		self.height = (#entities * self.line_height) + (self.padding * 2)

		if player_x and player_y and player_x <= tile_x then
			self.x = screen_x + tile_size + 5
		else
			self.x = screen_x - self.width - 5
		end
		self.y = screen_y

		if self.x + self.width > gw then self.x = screen_x - self.width - 5 end
		if self.y + self.height > gh then self.y = gh - self.height end
		if self.x < 0 then self.x = 5 end
		if self.y < 0 then self.y = 5 end
	else
		self.visible = false
	end
end

function MouseHover:draw()
	if not self.visible or #self.entities == 0 then return end

	local bg_color = { 0.1, 0.1, 0.1, 0.9 }
	local border_color = { 0.4, 0.4, 0.4, 1 }
	local text_color = { 1, 1, 1, 1 }

	love.graphics.setColor(bg_color)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

	love.graphics.setColor(text_color)
	for i, entity in ipairs(self.entities) do
		local text_x = self.x + self.padding
		local text_y = self.y + self.padding + ((i - 1) * self.line_height)
		love.graphics.print(entity.name, text_x, text_y)
	end

	love.graphics.setColor(default_color)
end
