extends Button


func _ready():
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	hide()


func _pressed():
	var next_level_index = GlobalLevelState.current_level_index + 1

	# Prevent attempting to start a level that doesn't exist
	if next_level_index > GlobalLevelState._available_levels.levels.size() - 1:
		GlobalLevelEvents.game_ended.emit()
		return

	var next_level = GlobalLevelState.get_level(next_level_index)

	GlobalLevelState.current_level_index = next_level_index
	GlobalLevelState.player_win_rate = next_level.player_win_rate

	get_tree().reload_current_scene()

	hide()


func _on_coin_flip_succeeded():
	show()
