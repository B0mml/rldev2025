DungeonLevelDisplay = GameObject:extend()

function DungeonLevelDisplay:new(scene, x, y, opts)
	DungeonLevelDisplay.super.new(self, scene, x, y, opts)
	self.floor_number = opts.floor_number or 1
	self.player = opts.player
end

function DungeonLevelDisplay:updateFloor(floor_number) self.floor_number = floor_number end

function DungeonLevelDisplay:draw()
	local dungeon_text = "Dungeon Level: " .. self.floor_number
	love.graphics.setColor(default_color)
	love.graphics.print(dungeon_text, self.x, self.y)
end

