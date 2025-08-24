DungeonLevelDisplay = GameObject:extend()

function DungeonLevelDisplay:new(scene, x, y, opts)
	DungeonLevelDisplay.super.new(self, scene, x, y, opts)
	self.floor_number = opts.floor_number or 1
end

function DungeonLevelDisplay:updateFloor(floor_number)
	self.floor_number = floor_number
end

function DungeonLevelDisplay:draw()
	local text = "Dungeon Level: " .. self.floor_number
	love.graphics.setColor(default_color)
	love.graphics.print(text, self.x, self.y)
end