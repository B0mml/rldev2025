local stdmath = math

local math = {}

setmetatable(math, { __index = stdmath })

function math.random(min, max)
	local min, max = min or 0, max or 1
	return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end

math.Bresenham = {}
---
-- Maps a line from point (ox, oy) to point (ex, ey) onto a two dimensional
-- tile grid.
--
-- The callback function will be called for each tile the line passes on its
-- way from the origin to the target tile. The line algorithm can be stopped
-- early by making the callback return false.
--
-- The callback will receive parameters in the following order:
--      callback( ox, oy, counter, ... )
--
-- With ox and oy being the coordinates of the pixel the algorithm is currently
-- passing through, counter being the amount of passed pixels and ...
-- representing variable arguments passed through.
--
-- @tparam number ox The origin's x-coordinates.
-- @tparam number oy The origin's y-coordinates.
-- @tparam number ex The target's x-coordinates.
-- @tparam number ey The target's y-coordinates.
-- @tparam[opt] function callback
--                      A callback function being called for every tile the line passes.
--                      The line algorithm will stop if the callback returns false.
-- @tparam[opt] vararg ...
--                      Additional parameters which will be forwarded to the callback.
-- @treturn boolean     True if the target was reached, otherwise false.
-- @treturn number      The counter variable containing the number of passed pixels.
--
function math.Bresenham.line(ox, oy, ex, ey, callback, ...)
	local dx = math.abs(ex - ox)
	local dy = math.abs(ey - oy) * -1

	local sx = ox < ex and 1 or -1
	local sy = oy < ey and 1 or -1
	local err = dx + dy

	local counter = 0
	while true do
		-- If a callback has been provided, it controls wether the line
		-- algorithm should proceed or not.
		if callback then
			local continue = callback(ox, oy, counter, ...)
			if not continue then return false, counter end
		end

		counter = counter + 1

		if ox == ex and oy == ey then return true, counter end

		local tmpErr = 2 * err
		if tmpErr > dy then
			err = err + dy
			ox = ox + sx
		end
		if tmpErr < dx then
			err = err + dx
			oy = oy + sy
		end
	end
end

return math
