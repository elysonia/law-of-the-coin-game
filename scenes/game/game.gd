extends Node2D

var current_scene
var _level_stats_detail

var _game_mode_scene_mapping = {
	GlobalEnums.GameMode.MODIFIER_SELECTION:
	preload(
		"res://scenes/modifier_selection/perks_and_items_random_picker/perks_and_items_random_picker.tscn"
	),
	GlobalEnums.GameMode.COIN_FLIP: preload("res://scenes/coin_flip/coin_flip.tscn")
}

@onready var _crowd_worried_sfx_player = $CrowdWorriedSFXPlayer


func _ready():
	_on_game_mode_changed(GlobalEnums.GameMode.COIN_FLIP)
	GlobalLevelState.game_mode_changed.connect(_on_game_mode_changed)


func _update_level_stats_detail():
	if is_instance_valid(_level_stats_detail):
		_level_stats_detail.queue_free()

	_level_stats_detail = (
		load("res://scenes/game_menu/level_stats_detail/level_stats_detail.tscn").instantiate()
	)
	add_child(_level_stats_detail)
	_level_stats_detail.initialize()


func _on_game_mode_changed(game_mode: GlobalEnums.GameMode):

	var game_mode_scene = _game_mode_scene_mapping[game_mode]
	if game_mode == GlobalEnums.GameMode.MODIFIER_SELECTION:
		_crowd_worried_sfx_player.set_volume_db(-4.0)
	else:
		_crowd_worried_sfx_player.set_volume_db(0)

	if is_instance_valid(current_scene):
		current_scene.queue_free()
		current_scene = null

	current_scene = game_mode_scene.instantiate()
	get_children()[0].add_sibling(current_scene)
	_update_level_stats_detail()
