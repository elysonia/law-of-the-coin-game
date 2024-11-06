extends Control


func _ready():
	GlobalLevelEvents.game_title_shown.connect(_on_game_title_shown)


func _on_game_title_shown():
	show()
