extends Control

@onready var _level_label = $LevelLabel


func _ready():
	var level_number = GlobalLevelState.current_level_index + 1
	_level_label.text = "Trial " + str(level_number)
	GlobalLevelState.game_mode_changed.connect(_on_game_mode_changed)

	GlobalLevelState.show_all_notifications()


func _on_game_mode_changed(_game_mode):
	var level_number = GlobalLevelState.current_level_index + 1
	_level_label.text = "Trial " + str(level_number)

	GlobalLevelState.show_all_notifications()