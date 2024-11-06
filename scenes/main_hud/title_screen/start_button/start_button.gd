extends Button


func _pressed():
	GlobalLevelState.reset_level()
	GlobalLevelState.goto_game_level_scene()
