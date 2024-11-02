# Event bus for communicating coin events to distant nodes.
class_name CoinEvents
extends Node2D

# Should:
#	- Maybe it should be moved to coin_flip_hud
signal coin_timer_text_updated(time: float)

# Emit when a coin side has picked randomly
# Should:
# 	- Hide arrow buttons and timer
# 	- Play animation of the result
signal coin_random_picker_picked(result_coin)

# Emit when the player picks a coin face
# Should:
# 	- Hide the UI for coin faces
# 	- Start the delay countdown
# 	- Show the UI for arrow buttons and delay countdown text
#	- Show default coin face
signal coin_player_picked(player_coin)
