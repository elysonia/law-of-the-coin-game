extends Control

signal flip_delay_timer_started

@onready var _arrow_keys_control = $ArrowKeysControl
@onready var _coin_side_control = $CoinSideControl


func _ready():
	_coin_side_control.show()
	_arrow_keys_control.hide()


func _process(_delta):
	pass


func _on_flip_delay_timer_timeout():
	hide()


func _on_coin_side_control_coin_side_selected():
	_coin_side_control.hide()
	_arrow_keys_control.show()
	flip_delay_timer_started.emit()
