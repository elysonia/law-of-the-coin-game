class_name CoinEvents
extends Node2D

# Should:
#	- Maybe it should be moved to coin_flip_hud
signal coin_timer_text_updated(time: float)

# Should:
# 	- Hide arrow buttons and timer
# 	- Play animation of the result
signal coin_random_picker_picked(result_coin)

# Should:
# 	- Hide coin faces
# 	- Start the delay timer
# 	- Show arrow buttons and timer
signal coin_player_picked(player_coin)
