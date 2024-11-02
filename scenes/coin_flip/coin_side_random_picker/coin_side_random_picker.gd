class_name CoinSideRandomPicker
extends RandomPicker


func _ready():
	GlobalCoinEvents.coin_delay_countdown_finished.connect(
		_on_coin_delay_countdown_finished
	)


func _process(_delta):
	pass


func get_coin_result():
	var result = pick_random_item()
	GlobalCoinEvents.coin_random_picker_picked.emit(result)


func _on_coin_delay_countdown_finished():
	get_coin_result()
