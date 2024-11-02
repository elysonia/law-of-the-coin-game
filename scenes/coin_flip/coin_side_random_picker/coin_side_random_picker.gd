class_name CoinSideRandomPicker
extends RandomPicker

signal coin_side_selected(result)


func _ready():
	pass


func _process(_delta):
	pass


func get_coin_result():
	var result = pick_random_item()
	coin_side_selected.emit(result)


func _on_flip_delay_timer_timeout():
	get_coin_result()
