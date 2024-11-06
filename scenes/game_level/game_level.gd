class_name GameLevel
extends Node2D

@onready var _level_label = $LevelLabel


func _ready():
	var level_number = GlobalLevelState.current_level_index + 1
	_level_label.text = "Trial " + str(level_number)
