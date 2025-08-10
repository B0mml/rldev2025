RenderBar = GameObject:extend()

function RenderBar:new(scene, x, y, opts)
	RenderBar.super.new(self, scene, x, y, opts)
	self.total_width = opts.total_width or 100
	self.total_height = opts.total_height or 20
	self.min = opts.min or 0
	self.max = opts.max or 100
	self.current = opts.current or self.max

	-- Create foreground and background bar objects for tweening
	self.hp_bar_fg = { w = (self.current / self.max) * self.total_width }
	self.hp_bar_bg = { w = (self.current / self.max) * self.total_width }

	-- Store tween handles for cancellation
	self.fg_tween = nil
	self.bg_tween = nil
	self.bg_after = nil
end

function RenderBar:ChangeValue(value)
	local new_value = math.max(self.min, math.min(self.max, value))
	if new_value ~= self.current then
		self.current = new_value
		local new_width = (self.current / self.max) * self.total_width

		-- Cancel previous tweens
		if self.fg_tween then self.timer:cancel(self.fg_tween) end
		if self.bg_tween then self.timer:cancel(self.bg_tween) end
		if self.bg_after then self.timer:cancel(self.bg_after) end

		-- Start foreground tween immediately
		self.fg_tween = self.timer:tween(0.5, self.hp_bar_fg, { w = new_width }, "in-out-cubic")

		-- Start background tween after delay
		self.bg_after = self.timer:after(
			0.25,
			function() self.bg_tween = self.timer:tween(0.5, self.hp_bar_bg, { w = new_width }, "in-out-cubic") end
		)
	end
end

function RenderBar:draw()
	hp_bar_bg_empty = { 0.2, 0.2, 0.2, 1 }
	hp_bar_bg_slow = { 0.6, 0.6, 0.2, 1 }
	hp_bar_fg = { 0.8, 0.2, 0.2, 1 }
	love.graphics.setColor(hp_bar_bg_empty)
	love.graphics.rectangle("fill", self.x, self.y, self.total_width, self.total_height)

	love.graphics.setColor(hp_bar_bg_slow)
	love.graphics.rectangle("fill", self.x, self.y, self.hp_bar_bg.w, self.total_height)

	love.graphics.setColor(hp_bar_fg)
	love.graphics.rectangle("fill", self.x, self.y, self.hp_bar_fg.w, self.total_height)

	-- Border
	love.graphics.setColor(default_color)
	love.graphics.rectangle("line", self.x, self.y, self.total_width, self.total_height)

	local text = math.floor(self.current) .. "/" .. self.max
	love.graphics.setColor(default_color)
	love.graphics.print(text, self.x + 5, self.y + 2)
end
