require("game.ui.message")
MessageLog = Object:extend()

function MessageLog:new()
	MessageLog.super.new(self)
	self.total_width = 200
	self.total_height = 100
	self.messages = {}
end

function MessageLog:draw()
	local bg_color = { 12 / 255, 19 / 255, 23 / 255, 1 }
	local border_color = { 90 / 255, 88 / 255, 117 / 255, 1 }
	local text_color = { 211 / 255, 217 / 255, 178 / 255, 1 }

	local start_x = gw - self.total_width - 10
	local start_y = gh - self.total_height - 10

	love.graphics.setColor(bg_color)
	love.graphics.rectangle("fill", start_x, start_y, self.total_width, self.total_height)
	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", start_x, start_y, self.total_width, self.total_height)
	love.graphics.setColor(default_color)

	self:renderMessages()
end

function MessageLog:addMessage(text, color)
	local color = color or default_color

	if #self.messages > 0 and self.messages[#self.messages].text == text then
		self.messages[#self.messages].count = (self.messages[#self.messages].count or 1) + 1
	else
		local message = Message(text, color)
		message.count = 1
		table.insert(self.messages, message)
	end
end

function MessageLog:renderMessages()
	local start_x = gw - self.total_width - 10
	local start_y = gh - self.total_height - 10
	local padding = 5
	local line_height = 12
	local max_width = self.total_width - (padding * 2)
	local max_lines = math.floor((self.total_height - (padding * 2)) / line_height)

	local font = love.graphics.getFont()
	local current_y = start_y + padding
	local lines_rendered = 0

	for i = #self.messages, 1, -1 do
		if lines_rendered >= max_lines then break end

		local message = self.messages[i]
		local text = message.text
		local color = message.color or default_color

		if message.count and message.count > 1 then text = text .. " (" .. message.count .. "x)" end

		local wrapped_text, wrapped_lines = font:getWrap(text, max_width)

		local lines_needed = #wrapped_lines
		if lines_rendered + lines_needed > max_lines then lines_needed = max_lines - lines_rendered end

		for j = lines_needed, 1, -1 do
			love.graphics.setColor(color)
			love.graphics.print(wrapped_lines[j], start_x + padding, current_y)
			current_y = current_y + line_height
			lines_rendered = lines_rendered + 1
		end
	end

	love.graphics.setColor(default_color)
end
