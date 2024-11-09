extends Button


func _ready():
	GlobalCoinEvents.coin_flip_failed.connect(_on_coin_flip_failed)
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	hide()


func _pressed():
	var current_level = GlobalLevelState.get_level(0)

	GlobalLevelState.current_level_index = 0
	GlobalLevelState.player_win_rate = current_level.player_win_rate

	get_tree().reload_current_scene()


func _on_coin_flip_failed():
	show()


func _on_coin_flip_succeeded():
	if GlobalLevelState.check_is_last_level():
		show()
