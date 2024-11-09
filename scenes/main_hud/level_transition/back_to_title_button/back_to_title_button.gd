extends Button


func _ready():
	GlobalCoinEvents.coin_flip_failed.connect(_on_coin_flip_failed)
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	hide()


func _pressed():
	GlobalLevelState.goto_main_scene()


func _on_coin_flip_failed():
	show()


func _on_coin_flip_succeeded():
	if GlobalLevelState.check_is_last_level():
		show()
