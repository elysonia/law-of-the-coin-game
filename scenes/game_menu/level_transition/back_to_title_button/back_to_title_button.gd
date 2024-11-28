extends Button


func _ready():
	GlobalCoinEvents.coin_flip_failed.connect(_on_coin_flip_failed)
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	disabled = true
	hide()


func _pressed():
	for modifier in GlobalLevelState.level_modifiers:
		modifier.end_trial()

	GlobalLevelState.reset_game()
	GlobalLevelState.goto_main_scene()


func _on_coin_flip_failed():
	disabled = false
	show()


func _on_coin_flip_succeeded():
	if GlobalLevelState.check_is_last_level():
		disabled = false
		show()
