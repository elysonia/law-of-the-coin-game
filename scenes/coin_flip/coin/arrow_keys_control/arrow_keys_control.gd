extends Control

var _is_left_arrow_pressed = false
var _is_right_arrow_pressed = false

var _progress_bar_scene = null


func _ready():
	var progress_bar = load("res://scenes/coin_flip/player_control/progress_bar/progress_bar.tscn")

	_progress_bar_scene = progress_bar.instantiate()
	_progress_bar_scene.set_value_no_signal(GlobalLevelState.player_win_rate * 100)

	get_tree().root.add_child(_progress_bar_scene)


# TODO: Maybe adding the key shortcuts programmatically helps maintainability


# Ensure adding pick chance only when the left and right arrow are pressed alternately
func _check_should_add_pick_chance():
	return _is_left_arrow_pressed and _is_right_arrow_pressed


func _reset_arrow_pressed():
	_is_left_arrow_pressed = false
	_is_right_arrow_pressed = false


func _add_pick_chance():
	GlobalLevelState.player_win_rate += GlobalEnums.ARROW_KEY_INCREMENT_RATE
	_progress_bar_scene.set_value_no_signal(GlobalLevelState.player_win_rate * 100)
	_reset_arrow_pressed()


func _on_right_arrow_button_pressed():
	var should_add_pick_chance = _check_should_add_pick_chance()

	if should_add_pick_chance:
		_add_pick_chance()
	else:
		_is_right_arrow_pressed = true


func _on_left_arrow_button_pressed():
	var should_add_pick_chance = _check_should_add_pick_chance()

	if should_add_pick_chance:
		_add_pick_chance()
	else:
		_is_left_arrow_pressed = true
