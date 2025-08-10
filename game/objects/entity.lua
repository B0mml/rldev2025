Entity = GameObject:extend()

function Entity:new(scene, x, y, sprite, name, blocks_movement, ai_type, max_hp, attack, defense, gamemap, opts)
	Entity.super.new(self, scene, x, y, opts)

	self.ai_type = ai_type
	self.ai = self.ai_type(self)

	self.fighter_component = FighterComponent(self, max_hp, attack, defense)
	self.x = x or 0
	self.y = y or 0
	self.sprite = sprite or {
		image = tilesets["rogues"].image,
		quad = tilesets["rogues"].quads[0],
	}
	self.name = name or "<Unnamed>"
	self.blocks_movement = blocks_movement or false
	self.gamemap = gamemap

	self.vx, self.vy = self.x * tile_size, self.y * tile_size
end

function Entity:update(dt) Entity.super.update(self, dt) end

function Entity:draw() engine.sprites.drawTile(self.sprite, self.vx, self.vy) end

function Entity:spawn(gamemap, x, y)
	local clone = Entity(
		self.scene,
		x,
		y,
		self.sprite,
		self.name,
		self.blocks_movement,
		self.ai_type,
		self.fighter_component.max_hp,
		self.fighter_component.attack,
		self.fighter_component.defense,
		gamemap
	)

	clone.id = engine.utils.UUID()
	clone.creation_time = love.timer:getTime()

	table.insert(gamemap.entities, clone)
	return clone
end

function Entity:move_to(new_x, new_y)
	if self.gamemap and not self.gamemap:isBlocked(new_x, new_y) then
		self.x = new_x
		self.y = new_y
		self.vx = self.x * tile_size
		self.vy = self.y * tile_size
		return true
	end
	return false
end

function Entity:die()
	self.dead = true
	entity_templates.corpse:spawn(self.gamemap, self.x, self.y)
end
