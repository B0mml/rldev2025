local entity_templates = {}

function LoadEntityTemplates()
  local goblin_sprite = {
    image = tilesets["monsters"].image,
    quad = tilesets["monsters"].quads[8],
  }

  local ogre_sprite = {
    image = tilesets["monsters"].image,
    quad = tilesets["monsters"].quads[13],
  }

  entity_templates.goblin = Entity(nil, 0, 0, goblin_sprite, "Goblin", true)
  entity_templates.ogre = Entity(nil, 0, 0, ogre_sprite, "Ogre", true)

  return entity_templates
end
