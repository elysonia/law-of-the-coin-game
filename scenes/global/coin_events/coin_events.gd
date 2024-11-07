# Event bus for communicating coin events to distant nodes.
class_name CoinEvents
extends Node2D

# TODO: IMPORTANT - REDUCE SIGNALS
#   - Move the heads/tails button to coinflip and instantiate from there
#   - More the arrow keys to coinflip and instantiate from there!
#   - Hide progressbar before arrow keys

# Emit on delay timer timeout
# Should:
#   - Trigger random picker for heads or tails
signal coin_delay_countdown_finished

# Emit when a coin side has picked randomly
# Should:
# 	- Hide arrow buttons, progress bar and timer
# 	- Play animation of the result
signal coin_random_picker_picked(result_coin_name, is_successful_throw)

# Emit when the player picks a coin face
# Should:
# 	- Hide the UI for coin faces
# 	- Start the delay countdown
# 	- Show the UI for arrow buttons, progress bar and delay countdown text
#	- Show default coin face
signal coin_player_picked(player_coin_name)

# Emit when the randomly picked coin matches the player choice
# Should:
#   - Show the UI to restart, go to the next level and back to title screen
signal coin_flip_succeeded

# Emit when the randomly picked coin does no match the player choice
# Should:
#   - Show the UI to restart and back to title screen
#   - Show "restart" and "back to title" buttons as the game has ended
signal coin_flip_failed