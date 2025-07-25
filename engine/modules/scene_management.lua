local scenes = {}

function scenes.changeScene(scene, ...)
	if active_scene and active_scene.destroy then active_scene:destroy() end
	active_scene = _G[scene](...)
end

return scenes
