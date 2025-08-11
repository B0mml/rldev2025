Message = Object:extend()

function Message:new(text, color)
	Message.super.new(self)

	self.text = text
	self.color = color
	self.timestamp = love.timer:getTime()
end
