engine = engine or {}

engine.utils = require("engine.utils")
engine.scenes = require("engine.modules.scene_management")
engine.sprites = require("engine.graphics.sprites")
engine.math = require("engine.modules.math")

Object = require("engine.objects.object")
GameObject = require("engine.objects.gameobject")
Scene = require("engine.scene")

Timer = require("engine.libraries.timer")
Input = require("engine.libraries.input")
M = require("engine.libraries.functional")
Camera = require("engine.libraries.camera")

require("engine.modules.input_manager")

function loadEngine()
	timer = Timer()
	active_scene = nil
	game_speed = 1
end

function updateEngine() input:update() end

function recursiveEnumerate(folder, file_list)
	local items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		local file = folder .. "/" .. item
		if love.filesystem.getInfo(file, "file") then
			table.insert(file_list, file)
		elseif love.filesystem.getInfo(file, "directory") then
			recursiveEnumerate(file, file_list)
		end
	end
end

function requireFiles(files)
	for _, file in ipairs(files) do
		file = file:sub(1, -5)
		require(file)
	end
end
