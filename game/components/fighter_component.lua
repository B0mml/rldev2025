FighterComponent = Object:extend()

function FighterComponent:new(entity, max_hp, attack, defense)
  self.entity = entity
  self.max_hp = max_hp
  self.current_hp = max_hp
  self.attack = attack
  self.defense = defense
end
