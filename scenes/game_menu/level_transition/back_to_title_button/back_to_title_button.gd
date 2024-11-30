extends Button


func _pressed():
	for modifier in GlobalLevelState.level_modifiers:
		modifier.end_trial()

	GlobalLevelState.reset_game()
	GlobalLevelState.goto_main_scene()
