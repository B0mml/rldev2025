MessageLog = Object:extend()

function MessageLog:new()
	MessageLog.super.new(self)
	self.total_width = 200
	self.total_height = 100
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
end
