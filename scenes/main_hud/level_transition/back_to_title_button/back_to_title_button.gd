extends Button


func _ready():
	GlobalCoinEvents.coin_flip_failed.connect(_on_coin_flip_failed)
	hide()


func _pressed():
	GlobalLevelState.goto_scene("res://scenes/main.tscn")


func _on_coin_flip_failed():
	show()
