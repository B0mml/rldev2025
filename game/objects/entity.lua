Entity = GameObject:extend()

function Entity:new(scene, x, y, sprite, name, blocks_movement, gamemap, components, tags, opts)
	Entity.super.new(self, scene, x, y, opts)

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

	self.tags = tags or {}

	if components then
		for component_name, component_data in pairs(components) do
			if component_name == "ai" then
				self.ai_type = component_data.type
				if self.ai_type then self.ai = self.ai_type(self) end
			elseif component_name == "fighter" then
				self.fighter_component =
					FighterComponent(self, component_data.max_hp, component_data.attack, component_data.defense, component_data.xp_given)
			elseif component_name == "consumable" then
				self.consumable = component_data.type(self)
			else
				if type(component_data) == "table" and component_data.type then
					self[component_name .. "_component"] = component_data.type(self)
				elseif type(component_data) == "function" then
					self[component_name .. "_component"] = component_data(self)
				end
			end
		end
	end
end

function Entity:update(dt) Entity.super.update(self, dt) end

function Entity:draw() engine.sprites.drawTile(self.sprite, self.vx, self.vy) end

function Entity:spawn(gamemap, x, y)
	local components = {}

	if self.ai_type then components.ai = { type = self.ai_type } end

	if self.fighter_component then
		components.fighter = {
			max_hp = self.fighter_component.max_hp,
			attack = self.fighter_component.attack,
			defense = self.fighter_component.defense,
			xp_given = self.fighter_component.xp_given,
		}
	end

	if self.consumable then components.consumable = { type = getmetatable(self.consumable) } end

	local clone = Entity(self.scene, x, y, self.sprite, self.name, self.blocks_movement, gamemap, components, self.tags)

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
	message_log:addMessage(self.name .. " Died! ", hp_bar_fg)
	self.dead = true
	
	if self.fighter_component and self.fighter_component.xp_given and self.fighter_component.xp_given > 0 then
		if self.gamemap and self.gamemap.player and self.gamemap.player.fighter_component then
			self.gamemap.player.fighter_component:add_xp(self.fighter_component.xp_given)
		end
	end
	
	local corpse = entity_templates.corpse:spawn(self.gamemap, self.x, self.y)
	corpse.name = "Remains of " .. self.name
end
