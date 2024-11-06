extends Button


func _ready():
	GlobalLevelEvents.game_ended.connect(_on_game_ended)
	GlobalCoinEvents.coin_flip_failed.connect(_on_coin_flip_failed)
	hide()


func _pressed():
	GlobalLevelState.goto_scene("res://scenes/main.tscn")


func _on_coin_flip_failed():
	show()


func _on_game_ended():
	show()
