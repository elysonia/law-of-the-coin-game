class_name CoinSideRandomPicker
extends RandomPicker

var _player_coin_name = GlobalEnums.COIN.INDEX


func _ready():
	GlobalCoinEvents.coin_delay_countdown_finished.connect(_on_coin_delay_countdown_finished)
	GlobalCoinEvents.coin_player_picked.connect(_on_coin_events_coin_player_picked)


func get_coin_result():
	for item in item_list:
		if str(item.name) == _player_coin_name:
			item.pick_chance = GlobalLevelState.player_win_rate
		else:
			item.pick_chance = 1 - GlobalLevelState.player_win_rate

	var result_coin_name = pick_random_item()
	var is_successful_throw = result_coin_name == _player_coin_name

	GlobalCoinEvents.coin_random_picker_picked.emit(result_coin_name, is_successful_throw)


func _on_coin_delay_countdown_finished():
	get_coin_result()


func _on_coin_events_coin_player_picked(player_coin_name):
	_player_coin_name = player_coin_name
