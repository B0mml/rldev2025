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

	local corpse_sprite = {
		image = tilesets["tiles"].image,
		quad = tilesets["tiles"].quads[17 * 22 + 1],
	}

	-- Scene, x, y, sprite, name, blocks_movmement, ai_type, max_hp, attack, defense
	entity_templates.goblin = Entity(nil, 0, 0, goblin_sprite, "Goblin", true, HostileEnemyAI, 3, 1, 0)
	entity_templates.ogre = Entity(nil, 0, 0, ogre_sprite, "Ogre", true, HostileEnemyAI, 5, 2, 1)
	entity_templates.corpse = Entity(nil, 0, 0, corpse_sprite, "Corpse", false, AiComponent, 1, 0, 0)

	return entity_templates
end
