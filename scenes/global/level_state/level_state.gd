# Stores the current level effects and modifiers
class_name LevelState
extends Node

var current_level_index = 0
var player_win_rate = 0

@onready var available_levels = preload("res://resources/levels/levels.tres")


func _ready():
	var current_level = get_level(current_level_index)

	player_win_rate = current_level.player_win_rate


func get_level(level_index):
	var level = available_levels.levels[level_index]

	return level


func restart_game():
	var current_level = get_level(0)

	current_level_index = 0
	player_win_rate = current_level.player_win_rate
