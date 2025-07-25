GameObject = Object:extend()

function GameObject:new(scene, x, y, opts)
	local opts = opts or {}
	if opts then
		for k, v in pairs(opts) do
			self[k] = v
		end
	end

	self.scene = scene
	self.x, self.y = x, y
	self.id = engine.utils.UUID()
	self.dead = false
	self.timer = Timer()
	self.depth = 50
	self.creation_time = love.timer:getTime()
end

function GameObject:update(dt)
	if self.timer then self.timer:update(dt) end
end

function GameObject:draw() end

function GameObject:destroy() self.timer:destroy() end

return GameObject
