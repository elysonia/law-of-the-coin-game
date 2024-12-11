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



func _get_adios_screen():
	return load(
		"res://scenes/game_menu/level_transition/adios/adios.tscn"
	)


func _on_coin_flip_failed():
	_level_transition_container = _get_level_transition_container().instantiate()
	add_child(_level_transition_container)

	var jailed_screen = _get_jailed_screen().instantiate()
	add_child(jailed_screen)

	var hole_me_achievement = GodotParadiseAchievements.get_achievement("hole_me")

	if not hole_me_achievement.unlocked:
		GodotParadiseAchievements.unlock_achievement("hole_me")

	await get_tree().create_timer(2).timeout

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

	var whole_free_achievement = GodotParadiseAchievements.get_achievement("whole_free")

	if not whole_free_achievement.unlocked:
		GodotParadiseAchievements.unlock_achievement("whole_free")

	var straight_man_achievement = GodotParadiseAchievements.get_achievement("straight_man")
	var should_get_straight_man_achievement = GlobalLevelState.are_keys_mashed and not GlobalLevelState.are_modifiers_bought
	
	if not straight_man_achievement.unlocked and should_get_straight_man_achievement:
		GodotParadiseAchievements.unlock_achievement("straight_man")
	
	var laissez_faire_achievement = GodotParadiseAchievements.get_achievement("laissez_faire")
	var should_get_laissez_faire_achievement = not GlobalLevelState.are_keys_mashed and not GlobalLevelState.are_modifiers_bought
	
	if not laissez_faire_achievement.unlocked and should_get_laissez_faire_achievement:
		GodotParadiseAchievements.unlock_achievement("laissez_faire")
	
	var adios_screen = _get_adios_screen().instantiate()
	add_child(adios_screen)

	await adios_screen.adios_completed
	await get_tree().create_timer(2).timeout

	_back_to_title_button = _get_back_to_title_button().instantiate()
	_level_transition_container.add_child(_back_to_title_button)


func _on_game_mode_changed(game_mode):
	if game_mode == GlobalEnums.GameMode.MODIFIER_SELECTION:
		_level_transition_container.queue_free()
