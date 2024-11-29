# Stores the current level effects and modifiers
class_name LevelState
extends Node

signal money_updated
signal game_mode_changed(game_mode: GlobalEnums.GameMode)

# TODO: Fix original modifiers getting mutated
var modifiers
var current_scene = null
var current_level_index = 0
var money = 0
var player_win_rate = 0

var level_modifiers: Array = []
var level_modifier_handicaps = []
var level_button_mash_time = {value = 5, label = ""}
var level_decrease_other_modifiers_effectiveness_by = {value = 0.0, label = ""}
var level_notifications: Array[String] = []

var _available_levels = preload("res://resources/levels/levels.tres")
var _game_scene = preload("res://scenes/game/game.tscn")
var _title_screen_scene = preload("res://scenes/title_screen/title_screen.tscn")
var _updates_label = preload("res://scenes/notifications/updates_label/updates_label.tscn")


func _ready():
	_reset_modifiers()
	var current_level = get_level(current_level_index)
	player_win_rate = current_level.player_win_rate

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func check_is_last_level():
	var last_level_index = GlobalLevelState._available_levels.levels.size() - 1

	return current_level_index >= last_level_index


func check_is_next_level_last_level():
	var last_level_index = GlobalLevelState._available_levels.levels.size() - 1

	return last_level_index - current_level_index == 1


func get_level(level_index):
	var level = _available_levels.levels[level_index]

	return level


func goto_main_scene():
	if is_instance_valid(current_scene):
		current_scene.queue_free()
		current_scene = null

	current_scene = _title_screen_scene.instantiate()
	get_tree().root.add_child(current_scene)


func goto_game_scene():
	if is_instance_valid(current_scene):
		current_scene.queue_free()
		current_scene = null

	current_scene = _game_scene.instantiate()
	get_tree().root.add_child(current_scene)


# Remember to include the amount added/deducted in the message
func set_money(value, message, should_notify_later = false):
	money = value
	money_updated.emit(message)

	if should_notify_later:
		level_notifications.append(message)
		return

	if message:
		var updates_label = _updates_label.instantiate()
		updates_label.text = message
		get_tree().root.add_child(updates_label)
		await updates_label.fade_tween().finished
		updates_label.queue_free()


func show_all_notifications():
	if level_notifications.size() == 0:
		return

	# Only show all the notifications that have been added until now.
	var level_notifications_copy = level_notifications.duplicate(true)
	level_notifications = []

	for level_notification in level_notifications_copy:
		var updates_label = _updates_label.instantiate()
		updates_label.set_text(level_notification)
		get_tree().root.add_child(updates_label)
		await updates_label.fade_tween().finished
		updates_label.queue_free()


func reset_game():
	_reset_modifiers()
	current_level_index = 0
	money = 0
	var current_level = get_level(current_level_index)
	player_win_rate = current_level.player_win_rate

	level_modifiers = []
	level_modifier_handicaps = []
	level_button_mash_time = {value = 5, label = ""}
	level_decrease_other_modifiers_effectiveness_by = {value = 0.0, label = ""}
	level_notifications = []


func _reset_modifiers():
	var original_modifiers = load("res://resources/modifiers/modifiers.tres")

	# Duplicate modifiers to prevent modifying the original.
	# Resource.duplicate() doesn't work when there are nested arrays apparently
	# so everything in an array has to be duplicated manually.
	var new_modifiers = {
		items = original_modifiers.items.map(func(item): return item.duplicate(true)),
		perks = original_modifiers.perks.map(func(perk): return perk.duplicate(true))
	}

	modifiers = new_modifiers
