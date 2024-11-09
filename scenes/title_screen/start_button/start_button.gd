extends Button


func _pressed():
	print("pressed")
	GlobalLevelState.current_level_index = 0
	var level = GlobalLevelState.get_level(GlobalLevelState.current_level_index)
	GlobalLevelState.player_win_rate = level.player_win_rate

	GlobalLevelState.goto_game_scene()
