Entity = GameObject:extend()

function Entity:new(scene, x, y, sprite, name, blocks_movement, opts)
  Entity.super.new(self, scene, x, y, opts)

  self.x = x or 0
  self.y = y or 0
  self.sprite = sprite or {
    image = tilesets["rogues"].image,
    quad = tilesets["rogues"].quads[0],
  }
  self.name = name or "<Unnamed>"
  self.blocks_movement = blocks_movement or false

  self.vx, self.vy = self.x * tile_size, self.y * tile_size
end

function Entity:update(dt)
  Entity.super.update(self, dt)
end

function Entity:draw() engine.sprites.drawTile(self.sprite, self.vx, self.vy) end

function Entity:spawn(gamemap, x, y)
  local clone = Entity(self.scene, x, y, self.sprite, self.name, self.blocks_movement)

  clone.id = engine.utils.UUID()
  clone.creation_time = love.timer:getTime()

  table.insert(gamemap.entities, clone)
  return clone
end

function Entity:die()
  self.dead = true
end
