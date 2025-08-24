LevelUpUI = Object:extend()

function LevelUpUI:new()
	LevelUpUI.super.new(self)
	self.total_width = 350
	self.total_height = 250
	self.visible = false
	self.selected_index = 1
	self.options = {
		{ text = "Constitution (+20 HP)", stat = "hp", value = 20 },
		{ text = "Strength (+1 Attack)", stat = "attack", value = 1 },
		{ text = "Agility (+1 Defense)", stat = "defense", value = 1 }
	}
end

function LevelUpUI:show()
	self.visible = true
	self.selected_index = 1
end

function LevelUpUI:hide()
	self.visible = false
end

function LevelUpUI:handleInput(input_type)
	if not self.visible then return end
	
	if input_type == "up" then
		self.selected_index = self.selected_index - 1
		if self.selected_index < 1 then
			self.selected_index = #self.options
		end
	elseif input_type == "down" then
		self.selected_index = self.selected_index + 1
		if self.selected_index > #self.options then
			self.selected_index = 1
		end
	elseif input_type == "return" then
		self:selectOption()
	end
end

function LevelUpUI:selectOption()
	if not self.player or not self.player.fighter_component then return end
	
	local option = self.options[self.selected_index]
	local fighter = self.player.fighter_component
	
	if option.stat == "hp" then
		fighter:increase_max_hp(option.value)
		message_log:addMessage("Your health improves!")
	elseif option.stat == "attack" then
		fighter:increase_attack(option.value)
		message_log:addMessage("You feel stronger!")
	elseif option.stat == "defense" then
		fighter:increase_defense(option.value)
		message_log:addMessage("Your movements are getting swifter!")
	end
	
	fighter:level_up()
	self:hide()
end

function LevelUpUI:draw()
	if not self.visible then return end

	local bg_color = { 12 / 255, 19 / 255, 23 / 255, 0.9 }
	local border_color = { 90 / 255, 88 / 255, 117 / 255, 1 }
	local selection_color = { 50 / 255, 50 / 255, 80 / 255, 0.8 }

	local start_x = (gw - self.total_width) / 2
	local start_y = (gh - self.total_height) / 2

	love.graphics.setColor(bg_color)
	love.graphics.rectangle("fill", start_x, start_y, self.total_width, self.total_height)
	love.graphics.setColor(border_color)
	love.graphics.rectangle("line", start_x, start_y, self.total_width, self.total_height)

	love.graphics.setColor(default_color)
	love.graphics.print("Level Up! Choose a stat to increase:", start_x + 10, start_y + 10)

	local line_height = 30
	local option_start_y = start_y + 50

	for i, option in ipairs(self.options) do
		local option_y = option_start_y + (i - 1) * line_height
		
		if i == self.selected_index then
			love.graphics.setColor(selection_color)
			love.graphics.rectangle("fill", start_x + 5, option_y - 5, self.total_width - 10, line_height - 5)
		end
		
		love.graphics.setColor(default_color)
		love.graphics.print((string.char(96 + i)) .. ") " .. option.text, start_x + 15, option_y)
	end
end