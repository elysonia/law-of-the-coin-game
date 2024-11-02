extends Control

var _is_left_arrow_pressed = false
var _is_right_arrow_pressed = false


func _ready():
	pass


func _process(_delta):
	pass


# Ensure adding pick chance only when the left and right arrow are pressed alternately
func _check_should_add_pick_chance():
	return _is_left_arrow_pressed and _is_right_arrow_pressed


func _reset_arrows():
	_is_left_arrow_pressed = false
	_is_right_arrow_pressed = false


func _on_right_arrow_button_pressed():
	var should_add_pick_chance = _check_should_add_pick_chance()

	if should_add_pick_chance:
		# TODO: Complete code for adding pick chance here
		_reset_arrows()
	else:
		_is_right_arrow_pressed = true


func _on_left_arrow_button_pressed():
	var should_add_pick_chance = _check_should_add_pick_chance()

	if should_add_pick_chance:
		# TODO: Complete code for adding pick chance here
		_reset_arrows()
	else:
		_is_left_arrow_pressed = true
