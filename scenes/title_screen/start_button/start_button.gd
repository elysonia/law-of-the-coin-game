extends Button


func _pressed():
	var sfx = get_node("StrongGavelOnceSFXPlayer")
	sfx.play()
	await sfx.finished
	GlobalLevelState.goto_game_scene()
