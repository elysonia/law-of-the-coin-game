# Stores the current level effects and modifiers
class_name LevelState
extends Node

var current_level_scene = null

var current_level_index = 0

# Default player win rate for the current level
var player_win_rate = 0

var _game_level_scene = preload("res://scenes/game_level/game_level.tscn")
var _available_levels = preload("res://resources/levels/levels.tres")


func _ready():
	var current_level = get_level(current_level_index)
	player_win_rate = current_level.player_win_rate

	var root = get_tree().root
	current_level_scene = root.get_child(root.get_child_count() - 1)


func reset_level():
	current_level_index = 0
	var level = get_level(current_level_index)
	GlobalLevelState.player_win_rate = level.player_win_rate


func get_level(level_index):
	var level = _available_levels.levels[level_index]

	return level


func goto_scene(path):
	"""
	This function will usually be called from a signal callback
	or other functions in the current scene.
	Deleting the scene immediately is bad as it may still be executing code
	which could cause a crash or unexpected behavior.

	The solution is to defer the load to a later time when we
	can be sure that no code from the current scene is running.
	"""

	# call_deferred ensures _deferred_goto_scene only runs after
	# the current scene is done running.
	call_deferred("_deferred_goto_scene", path)

	"""
	Usage in scenes:

		i.e. level_1.gd
			func _on_button_pressed():
				GlobalState.goto_scene("res://level_2.tscn")
	"""


func goto_game_level_scene():
	call_deferred("_deferred_goto_game_level_scene")


func _deferred_goto_game_level_scene():
	current_level_scene = _game_level_scene.instantiate()

	get_tree().root.add_child(current_level_scene)
	get_tree().current_scene = current_level_scene


func _deferred_goto_scene(path):
	var new_scene = load(path).instantiate()

	if current_level_scene:
		get_tree().unload_current_scene()
		current_level_scene = null

	get_tree().root.add_child(new_scene)
