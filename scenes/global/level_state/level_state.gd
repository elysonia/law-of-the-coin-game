# Stores the current level effects and modifiers
class_name LevelState
extends Node

var current_level_index = 0
var player_win_rate = 0

@onready var _available_levels = preload("res://resources/levels/levels.tres")


func _ready():
	var current_level = get_level(current_level_index)

	player_win_rate = current_level.player_win_rate


func get_level(level_index):
	var level = _available_levels.levels[level_index]

	return level


func go_to_next_level(previous_level_index):
	var next_level_index = previous_level_index + 1

	if next_level_index > _available_levels.levels.length() - 1:
		return

	var next_level = get_level(next_level_index)

	current_level_index = next_level_index
	player_win_rate = next_level.player_win_rate
