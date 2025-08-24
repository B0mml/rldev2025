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

	local lightning_scroll_sprite = {
		image = tilesets["items"].image,
		quad = tilesets["items"].quads[11 * 21 + 1],
	}

	local confusion_scroll_sprite = {
		image = tilesets["items"].image,
		quad = tilesets["items"].quads[11 * 21 + 4],
	}

	local fireball_scroll_sprite = {
		image = tilesets["items"].image,
		quad = tilesets["items"].quads[11 * 21 + 3],
	}

	-- Scene, x, y, sprite, name, blocks_movement, gamemap, components, tags
	entity_templates.goblin = Entity(nil, 0, 0, goblin_sprite, "Goblin", true, nil, {
		ai = { type = HostileEnemyAI },
		fighter = { max_hp = 3, attack = 1, defense = 0, xp_given = 35 },
	}, {})

	entity_templates.ogre = Entity(nil, 0, 0, ogre_sprite, "Ogre", true, nil, {
		ai = { type = HostileEnemyAI },
		fighter = { max_hp = 5, attack = 1, defense = 0, xp_given = 100 },
	}, {})

	entity_templates.corpse = Entity(nil, 0, 0, corpse_sprite, "Corpse", false, nil, {}, {})

	entity_templates.health_potion = Entity(nil, 0, 0, health_potion_sprite, "Health Potion", false, nil, {
		consumable = { type = HealthPotion },
	}, { "item" })

	entity_templates.lightning_scroll = Entity(nil, 0, 0, lightning_scroll_sprite, "Lightning Scroll", false, nil, {
		consumable = { type = LightningScroll },
	}, { "item" })

	entity_templates.confusion_scroll = Entity(nil, 0, 0, confusion_scroll_sprite, "Confusion Scroll", false, nil, {
		consumable = { type = ConfusionScroll },
	}, { "item" })

	entity_templates.fireball_scroll = Entity(nil, 0, 0, fireball_scroll_sprite, "Fireball Scroll", false, nil, {
		consumable = { type = FireballScroll },
	}, { "item" })

	return entity_templates
end
