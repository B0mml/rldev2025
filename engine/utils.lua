local utils = {}

function utils.UUID()
	local fn = function(x)
		local r = love.math.random(16) - 1
		r = (x == "x") and (r + 1) or (r % 4) + 9
		return ("0123456789abcdef"):sub(r, r)
	end
	return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function utils.resize_game(s)
	love.window.setMode(s * gw, s * gh)
	sx, sy = s, s
end

return utils
