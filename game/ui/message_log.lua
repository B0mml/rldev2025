require("game.ui.message")
MessageLog = Object:extend()

function MessageLog:new()
	MessageLog.super.new(self)
	self.total_width = 200
	self.total_height = 100
	self.messages = {}
	self.expanded = false
	self.scroll_offset = 0
end

function MessageLog:draw()
	if self.expanded then
		self:drawExpanded()
	else
		self:drawCollapsed()
	end
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

function MessageLog:drawCollapsed()
	local bg_color = { 12 / 255, 19 / 255, 23 / 255, 1 }
	local border_color = { 90 / 255, 88 / 255, 117 / 255, 1 }

	local start_x = gw - self.total_width - 10
	local start_y = gh - self.total_height - 10

	love.graphics.setColor(bg_color)
	love.graphics.rectangle("fill", start_x, start_y, self.total_width, self.total_height)
	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", start_x, start_y, self.total_width, self.total_height)

	self:renderMessages(start_x, start_y, self.total_width, self.total_height)
end

function MessageLog:renderMessages(start_x, start_y, width, height)
	local padding = 5
	local line_height = 12
	local max_width = width - (padding * 2)
	local max_lines = math.floor((height - (padding * 2)) / line_height)

	local font = love.graphics.getFont()
	local total_lines = 0
	local message_lines = {}

	for i = 1, #self.messages do
		local message = self.messages[i]
		local text = message.text
		if message.count and message.count > 1 then text = text .. " (" .. message.count .. "x)" end

		local wrapped_text, wrapped_lines = font:getWrap(text, max_width)
		message_lines[i] = wrapped_lines
		total_lines = total_lines + #wrapped_lines
	end

	local start_line = math.max(1, total_lines - max_lines + 1 - self.scroll_offset)
	local current_line = 1
	local current_y = start_y + padding
	local lines_rendered = 0

	for i = 1, #self.messages do
		if lines_rendered >= max_lines then break end

		local message = self.messages[i]
		local color = message.color or default_color
		local wrapped_lines = message_lines[i]

		for j = 1, #wrapped_lines do
			if current_line >= start_line and lines_rendered < max_lines then
				love.graphics.setColor(color)
				love.graphics.print(wrapped_lines[j], start_x + padding, current_y)
				current_y = current_y + line_height
				lines_rendered = lines_rendered + 1
			end
			current_line = current_line + 1
		end
	end

	love.graphics.setColor(default_color)
end

function MessageLog:drawExpanded()
	local bg_color = { 12 / 255, 19 / 255, 23 / 255, 1 }
	local border_color = { 90 / 255, 88 / 255, 117 / 255, 1 }

	local start_x = 50
	local start_y = 50
	local expanded_width = gw - 100
	local expanded_height = gh - 100

	love.graphics.setColor(bg_color)
	love.graphics.rectangle("fill", start_x, start_y, expanded_width, expanded_height)
	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", start_x, start_y, expanded_width, expanded_height)

	self:renderMessages(start_x, start_y, expanded_width, expanded_height)
end

function MessageLog:scroll(delta)
	if not self.expanded then return end

	self.scroll_offset = math.max(0, self.scroll_offset + delta)
end

function MessageLog:scrollToBottom() self.scroll_offset = 0 end
