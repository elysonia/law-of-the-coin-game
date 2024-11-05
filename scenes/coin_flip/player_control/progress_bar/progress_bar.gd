extends ProgressBar


func _ready():
	GlobalLevelEvents.level_player_win_rate_updated.connect(_on_level_player_win_rate_updated)
	GlobalCoinEvents.coin_player_picked.connect(_on_coin_event_coin_player_picked)
	GlobalCoinEvents.coin_delay_countdown_finished.connect(
		_on_coin_events_coin_delay_countdown_finished
	)


	set_value_no_signal(GlobalLevelState.player_win_rate * 100)
	hide()


func _on_coin_event_coin_player_picked(_player_coin_name):
	show()


func _on_coin_events_coin_delay_countdown_finished():
	hide()


func _on_level_player_win_rate_updated():
	set_value_no_signal(GlobalLevelState.player_win_rate * 100)

