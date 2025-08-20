input = Input.new({
	controls = {
		left = { "key:left", "key:a", "key:h", "axis:leftx-", "button:dpleft" },
		right = { "key:right", "key:d", "key:l", "axis:leftx+", "button:dpright" },
		up = { "key:up", "key:w", "key:k", "axis:lefty-", "button:dpup" },
		down = { "key:down", "key:s", "key:j", "axis:lefty+", "button:dpdown" },
		action = { "key:return", "button:a" },
		log = { "key:v" },
		inventory = { "key:i" },
		pickup = { "key:x" },
		skip_turn = { "key:space" },
	},
	pairs = {
		move = { "left", "right", "up", "down" },
	},
	joystick = love.joystick.getJoysticks()[1],
})
