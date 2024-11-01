extends RandomPicker
class_name CoinSideSelection


signal _coin_side_selected(result)
signal _flip_delay_timer_started



func _ready():
	pass


func _process(_delta):
	pass


func get_coin_result():
	var result = pick_random_item()
	_coin_side_selected.emit(result)


func _on_tails_button_pressed():
	_flip_delay_timer_started.emit()


func _on_heads_button_pressed():
	_flip_delay_timer_started.emit()


func _on_flip_delay_timer_timeout():
	get_coin_result()
