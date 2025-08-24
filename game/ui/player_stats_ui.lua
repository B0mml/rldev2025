PlayerStatsUI = GameObject:extend()

function PlayerStatsUI:new(scene, x, y, opts)
	PlayerStatsUI.super.new(self, scene, x, y, opts)
	self.player = opts.player
	self.width = 200
	self.height = 100
	self.padding = 10
	self.line_height = 16
end

function PlayerStatsUI:draw()
	if not self.player or not self.player.fighter_component then return end

	local fighter = self.player.fighter_component
	if not fighter.level then return end

	local bg_color = { 12 / 255, 19 / 255, 23 / 255, 0.8 }
	local border_color = { 90 / 255, 88 / 255, 117 / 255, 1 }
	local xp_bar_bg = { 0.2, 0.2, 0.2, 1 }
	local xp_bar_fg = { 0.2, 0.8, 0.2, 1 }

	love.graphics.setColor(bg_color)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

	love.graphics.setColor(default_color)

	local text_x = self.x + self.padding
	local text_y = self.y + self.padding

	love.graphics.print("Level: " .. fighter.level, text_x, text_y)
	text_y = text_y + self.line_height

	love.graphics.print("Attack: " .. fighter.attack, text_x, text_y)
	text_y = text_y + self.line_height

	love.graphics.print("Defense: " .. fighter.defense, text_x, text_y)
	text_y = text_y + self.line_height

	local xp_to_next = fighter:experience_to_next_level()
	love.graphics.print("XP: " .. fighter.xp .. "/" .. xp_to_next, text_x, text_y)
	text_y = text_y + self.line_height + 5

	local bar_width = self.width - (self.padding * 2)
	local bar_height = 8
	local xp_progress = math.min(fighter.xp / xp_to_next, 1.0)
	local fill_width = bar_width * xp_progress

	love.graphics.setColor(xp_bar_bg)
	love.graphics.rectangle("fill", text_x, text_y, bar_width, bar_height)

	love.graphics.setColor(xp_bar_fg)
	love.graphics.rectangle("fill", text_x, text_y, fill_width, bar_height)

	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", text_x, text_y, bar_width, bar_height)
end

