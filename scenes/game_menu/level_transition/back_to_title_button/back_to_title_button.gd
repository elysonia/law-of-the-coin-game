extends Button


func _pressed():
	var sfx = get_node("StrongGavelOnceSFXPlayer")
	sfx.play()

	for modifier in GlobalLevelState.level_modifiers:
		modifier.end_trial()

	await sfx.finished
	GlobalLevelState.reset_game()
	GlobalLevelState.goto_main_scene()
