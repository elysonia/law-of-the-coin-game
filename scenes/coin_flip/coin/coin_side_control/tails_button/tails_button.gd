extends TextureButton


func _pressed():
	GlobalCoinEvents.coin_player_picked.emit(GlobalEnums.COIN.TAILS)
