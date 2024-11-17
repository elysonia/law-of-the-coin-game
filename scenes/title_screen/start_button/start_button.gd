extends Button


func _pressed():
	GlobalLevelState.reset_game()
	GlobalLevelState.goto_game_scene()
