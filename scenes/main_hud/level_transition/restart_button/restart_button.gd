extends Button


func _ready():
	GlobalLevelEvents.game_ended.connect(_on_game_ended)
	GlobalCoinEvents.coin_flip_failed.connect(_on_coin_flip_failed)
	hide()


func _pressed():
	var current_level = GlobalLevelState.get_level(0)

	GlobalLevelState.current_level_index = 0
	GlobalLevelState.player_win_rate = current_level.player_win_rate

	get_tree().reload_current_scene()


func _on_coin_flip_failed():
	show()


func _on_game_ended():
	show()
