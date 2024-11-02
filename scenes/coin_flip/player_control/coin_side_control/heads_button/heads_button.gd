extends TextureButton

func _pressed():
	# TODO: Replace "heads" with enums
	GlobalCoinEvents.coin_player_picked.emit("heads")
