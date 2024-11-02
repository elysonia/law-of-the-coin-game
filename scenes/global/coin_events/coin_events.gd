# Event bus for communicating coin events to distant nodes.
class_name CoinEvents
extends Node2D

# Emit on delay timer timeout
# Should:
#   - Trigger random picker for heads or tails
signal coin_delay_countdown_finished

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
