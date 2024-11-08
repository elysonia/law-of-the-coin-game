extends Control

var _is_left_arrow_pressed = false
var _is_right_arrow_pressed = false

@onready var _progress_bar = $ProgressBar


func _ready():
	_progress_bar.set_value_no_signal(GlobalLevelState.player_win_rate * 100)


# Ensure adding pick chance only when the left and right arrow are pressed alternately
func _check_should_add_pick_chance():
	return _is_left_arrow_pressed and _is_right_arrow_pressed


func _reset_arrow_pressed():
	_is_left_arrow_pressed = false
	_is_right_arrow_pressed = false


func _add_pick_chance():
	GlobalLevelState.player_win_rate += GlobalEnums.ARROW_KEY_INCREMENT_RATE
	_progress_bar.set_value_no_signal(GlobalLevelState.player_win_rate * 100)
	_reset_arrow_pressed()


func _on_right_arrow_button_pressed():
	_is_right_arrow_pressed = true

	var should_add_pick_chance = _check_should_add_pick_chance()

	if should_add_pick_chance:
		_add_pick_chance()


func _on_left_arrow_button_pressed():
	_is_left_arrow_pressed = true

	var should_add_pick_chance = _check_should_add_pick_chance()

	if should_add_pick_chance:
		_add_pick_chance()
