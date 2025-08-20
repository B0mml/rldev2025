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

	local health_potion_sprite = {
		image = tilesets["items"].image,
		quad = tilesets["items"].quads[11 * 19 + 2],
	}

	-- Scene, x, y, sprite, name, blocks_movement, gamemap, components, tags
	entity_templates.goblin = Entity(nil, 0, 0, goblin_sprite, "Goblin", true, nil, {
		ai = { type = HostileEnemyAI },
		fighter = { max_hp = 3, attack = 1, defense = 0 },
	}, {})

	entity_templates.ogre = Entity(nil, 0, 0, ogre_sprite, "Ogre", true, nil, {
		ai = { type = HostileEnemyAI },
		fighter = { max_hp = 5, attack = 1, defense = 0 },
	}, {})

	entity_templates.corpse = Entity(nil, 0, 0, corpse_sprite, "Corpse", false, nil, {}, {})

	entity_templates.health_potion = Entity(nil, 0, 0, health_potion_sprite, "Health Potion", false, nil, {
		consumable = { type = HealthPotion },
	}, { "item" })

	return entity_templates
end
