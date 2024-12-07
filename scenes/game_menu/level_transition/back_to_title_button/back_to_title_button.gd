extends Button


func _pressed():
	SoundManager.play_sfx("gavel_once_strong")

	for modifier in GlobalLevelState.level_modifiers:
		modifier.end_trial()

	GlobalLevelState.reset_game()
	GlobalLevelState.goto_main_scene()
