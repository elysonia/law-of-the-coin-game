extends Button


func _ready():
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	hide()


func _pressed():
	var next_level_index = GlobalLevelState.current_level_index + 1

	# Prevent attempting to start a level that doesn't exist
	if not _check_next_level_exists(next_level_index):
		return

	var next_level = GlobalLevelState.get_level(next_level_index)

	GlobalLevelState.current_level_index = next_level_index
	GlobalLevelState.player_win_rate = next_level.player_win_rate

	GlobalLevelState.goto_game_level_scene()


func _check_next_level_exists(next_level_index):
	var last_level_index = GlobalLevelState._available_levels.levels.size() - 1

	return next_level_index < last_level_index


func _on_coin_flip_succeeded():
	var next_level_index = GlobalLevelState.current_level_index + 1

	# Prevent showing the button when player has reached the end
	if not _check_next_level_exists(next_level_index):
		return

	show()
