# Stores the current level effects and modifiers
class_name LevelState
extends Node

signal money_updated

var current_scene = null
var current_level_index = 0
var player_win_rate = 0
var money = 0

# TODO: Research load as local function variable vs preload as local class variable more
var _title_screen_scene = preload("res://scenes/title_screen/title_screen.tscn")
var _game_scene = preload("res://scenes/game/game.tscn")
var _available_levels = preload("res://resources/levels/levels.tres")


func _ready():
	var current_level = get_level(current_level_index)
	player_win_rate = current_level.player_win_rate

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func check_is_last_level():
	var last_level_index = GlobalLevelState._available_levels.levels.size() - 1

	return current_level_index >= last_level_index


func get_level(level_index):
	var level = _available_levels.levels[level_index]

	return level


func goto_main_scene():
	var main_scene = _title_screen_scene.instantiate()

	if is_instance_valid(current_scene):
		current_scene.queue_free()
		current_scene = null

	current_scene = _title_screen_scene.instantiate()
	get_tree().root.add_child(main_scene)


func goto_game_scene():
	if is_instance_valid(current_scene):
		current_scene.queue_free()
		current_scene = null

	current_scene = _game_scene.instantiate()

	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene


func set_money(value):
	money = value
	money_updated.emit()
