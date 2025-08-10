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

	-- Scene, x, y, sprite, name, blocks_movmement, max_hp, attack, defense
	entity_templates.goblin = Entity(nil, 0, 0, goblin_sprite, "Goblin", true, 3, 1, 0)
	entity_templates.ogre = Entity(nil, 0, 0, ogre_sprite, "Ogre", true, 5, 2, 1)

	return entity_templates
end
