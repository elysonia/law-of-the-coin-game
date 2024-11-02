extends TextureButton


func _pressed():
	# TODO: Replace "tails" with enums
	GlobalCoinEvents.coin_player_picked.emit("tails")
