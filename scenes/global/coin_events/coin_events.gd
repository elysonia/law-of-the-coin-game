# Event bus for communicating coin events to distant nodes.
class_name CoinEvents
extends Node2D


# Emit when the randomly picked coin matches the player choice
# Should:
#   - Show the UI to restart, go to the next level and back to title screen
signal coin_flip_succeeded

# Emit when the randomly picked coin does no match the player choice
# Should:
#   - Show the UI to restart and back to title screen
#   - Show "restart" and "back to title" buttons as the game has ended
signal coin_flip_failed