extends Control

@onready var _arrow_keys_control = $ArrowKeysControl
@onready var _coin_side_control = $CoinSideControl


func _ready():
	GlobalCoinEvents.coin_player_picked.connect(
		_on_coin_events_coin_player_picked
	)
	GlobalCoinEvents.coin_delay_countdown_finished.connect(
		_on_coin_events_coin_delay_countdown_finished
	)
	_coin_side_control.show()
	_arrow_keys_control.hide()


func _process(_delta):
	pass


func _on_coin_events_coin_delay_countdown_finished():
	hide()


func _on_coin_events_coin_player_picked(_player_coin_name):
	_coin_side_control.hide()
	_arrow_keys_control.show()
