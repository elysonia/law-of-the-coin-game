extends Control

var _is_left_arrow_pressed = false
var _is_right_arrow_pressed = false
var _is_all_arrow_keys_used = false
var _arrow_button_container_scene = null


func initialize():
	var progress_bar = get_node("PlayerWinRateBar")
	progress_bar.set_value_no_signal(GlobalLevelState.player_win_rate * 100)

	var item_multidirectional_keycap = load(
		"res://resources/modifiers/items/item_multidirectional_keycap.tres"
	)
	_is_all_arrow_keys_used = GlobalLevelState.level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == item_multidirectional_keycap.name
	).size() > 0

	if _is_all_arrow_keys_used:
		var multidirectional_keycap_scene = load(
			"res://scenes/coin_flip/coin/arrow_keys_control/multidirectional_keycap_container.tscn"
		).instantiate()

		add_child(multidirectional_keycap_scene)

		multidirectional_keycap_scene.get_node("LeftButton").pressed.connect(
			_on_multidirectional_keycap_input
		)
		multidirectional_keycap_scene.get_node("RightButton").pressed.connect(
			_on_multidirectional_keycap_input
		)
		multidirectional_keycap_scene.get_node("UpButton").pressed.connect(
			_on_multidirectional_keycap_input
		)
		multidirectional_keycap_scene.get_node("DownButton").pressed.connect(
			_on_multidirectional_keycap_input
		)

	else:
		var arrow_container_scene = load(
			"res://scenes/coin_flip/coin/arrow_keys_control/arrow_container.tscn"
		).instantiate()

		add_child(arrow_container_scene)
		_arrow_button_container_scene = arrow_container_scene
		# TODO: Fix arrow buttons not responding to key input after pressing with mouse
		arrow_container_scene.get_node("RightArrowButton").pressed.connect(_on_right_arrow_button_pressed)
		arrow_container_scene.get_node("LeftArrowButton").pressed.connect(_on_left_arrow_button_pressed)


# Ensure adding pick chance only when the left and right arrow are pressed alternately
func _check_should_add_pick_chance():
	return self._is_left_arrow_pressed and self._is_right_arrow_pressed


func _reset_arrow_pressed():
	_is_left_arrow_pressed = false
	_is_right_arrow_pressed = false


func _add_pick_chance():
	var progress_bar = get_node("PlayerWinRateBar")
	GlobalLevelState.player_win_rate += GlobalLevelState.level_button_mash_increment_rate.value
	progress_bar.set_value_no_signal(GlobalLevelState.player_win_rate * 100)


func _on_right_arrow_button_pressed():
	if not GlobalLevelState.are_keys_mashed:
		GlobalLevelState.are_keys_mashed = true
 
	_is_right_arrow_pressed = true
	var should_add_pick_chance = _check_should_add_pick_chance()

	if should_add_pick_chance:
		_add_pick_chance()
		_reset_arrow_pressed()

	_reset_blinking_text()


func _on_left_arrow_button_pressed():
	if not GlobalLevelState.are_keys_mashed:
		GlobalLevelState.are_keys_mashed = true

	_is_left_arrow_pressed = true
	var should_add_pick_chance = _check_should_add_pick_chance()

	if should_add_pick_chance:
		_add_pick_chance()
		_reset_arrow_pressed()
	_reset_blinking_text()


func _on_multidirectional_keycap_input():
	if not GlobalLevelState.are_keys_mashed:
		GlobalLevelState.are_keys_mashed = true
	
	if not _is_all_arrow_keys_used:
		return

	_add_pick_chance()


func _reset_blinking_text():
	_arrow_button_container_scene.get_node("LeftArrowButton").stop_blinking_text()
	_arrow_button_container_scene.get_node("RightArrowButton").stop_blinking_text()

	if not _is_left_arrow_pressed:
		_arrow_button_container_scene.get_node("LeftArrowButton").start_blinking_text()

	if not _is_right_arrow_pressed:
		_arrow_button_container_scene.get_node("RightArrowButton").start_blinking_text()
