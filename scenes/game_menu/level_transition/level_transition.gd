extends Control
var _next_trial_button = null
var _back_to_title_button = null
var _level_transition_container = null


func _ready():
	GlobalCoinEvents.coin_flip_failed.connect(_on_coin_flip_failed)
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	GlobalLevelState.game_mode_changed.connect(_on_game_mode_changed)


func _get_level_transition_container():
	return load("res://scenes/game_menu/level_transition/level_transition_container.tscn")


func _get_back_to_title_button():
	return load(
		"res://scenes/game_menu/level_transition/back_to_title_button/back_to_title_button.tscn"
	)


func _get_jailed_screen():
	return load(
		"res://scenes/game_menu/level_transition/jailed_screen/jailed_screen.tscn"
	)


func _on_coin_flip_failed():
	_level_transition_container = _get_level_transition_container().instantiate()
	var jailed_screen = _get_jailed_screen().instantiate()

	add_child(jailed_screen)
	add_child(_level_transition_container)

	_back_to_title_button = _get_back_to_title_button().instantiate()
	_level_transition_container.add_child(_back_to_title_button)


func _on_coin_flip_succeeded():
	_level_transition_container = _get_level_transition_container().instantiate()
	add_child(_level_transition_container)

	# Prevent showing the button when player has reached the end
	if not GlobalLevelState.check_is_last_level():
		_next_trial_button = (
			load("res://scenes/game_menu/level_transition/next_trial_button/next_trial_button.tscn")
			. instantiate()
		)
		_level_transition_container.add_child(_next_trial_button)
		return

	_back_to_title_button = _get_back_to_title_button().instantiate()
	_level_transition_container.add_child(_back_to_title_button)


func _on_game_mode_changed(game_mode):
	if game_mode == GlobalEnums.GameMode.MODIFIER_SELECTION:
		_level_transition_container.queue_free()
