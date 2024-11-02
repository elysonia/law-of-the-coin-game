extends Control

@onready var _arrow_keys_control = $ArrowKeysControl
@onready var _coin_side_control = $CoinSideControl


func _ready():
	GlobalCoinEvents.coin_player_picked.connect(_on_coin_events_coin_player_picked)
	_coin_side_control.show()
	_arrow_keys_control.hide()


func _process(_delta):
	pass


func _on_flip_delay_timer_timeout():
	hide()


func _on_coin_events_coin_player_picked(_player_choice):
	_coin_side_control.hide()
	_arrow_keys_control.show()
