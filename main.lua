require("engine.core")
require("tile_types")

DEBUG = false
tile_size = 32

function love.load()
	loadEngine()
	love.graphics.setDefaultFilter("nearest")
	love.graphics.setLineStyle("rough")
	engine.utils.resize_game(2)

	local object_files = {}
	recursiveEnumerate("game/objects", object_files)
	requireFiles(object_files)

	local scene_files = {}
	recursiveEnumerate("game/scenes", scene_files)
	requireFiles(scene_files)

	loadTilesets()

	engine.scenes.changeScene("MainScene")
end

function love.update(dt)
	updateEngine()

	if active_scene then active_scene:update(dt * game_speed) end
end

function love.draw()
	if active_scene then active_scene:draw() end
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
end
