class_name Coin
extends Node2D

@onready var _tails_animation = $TailsAnimatedSprite2D
@onready var _heads_animation = $HeadsAnimatedSprite2D


func _ready():
	GlobalCoinEvents.coin_player_picked.connect(_on_coin_events_coin_player_picked)
	GlobalCoinEvents.coin_random_picker_picked.connect(_on_coin_events_coin_random_picker_picked)

	_reset_animation()


func _process(_delta):
	pass


# Show faceless coin before flipping animation
func _reset_animation():
	_tails_animation.hide()
	_heads_animation.set_frame(0)
	_heads_animation.show()


# TODO: Maybe start the flipping animation but stop midway
# 	so the coin is "midair" during countdown
func _on_coin_events_coin_player_picked(_player_coin_name):
	_reset_animation()


func _on_coin_events_coin_random_picker_picked(result_coin_name, is_successful_throw):
	_reset_animation()

	# TODO: Revise
	_heads_animation.animation_finished.connect(
		_on_coin_animation_finished.bind(is_successful_throw)
	)
	_tails_animation.animation_finished.connect(
		_on_coin_animation_finished.bind(is_successful_throw)
	)

	if result_coin_name == GlobalEnums.COIN.HEADS:
		_tails_animation.hide()
		_heads_animation.set_frame_and_progress(0, 0.0)
		_heads_animation.show()
		_heads_animation.play()

	elif result_coin_name == GlobalEnums.COIN.TAILS:
		_heads_animation.hide()
		_tails_animation.set_frame_and_progress(0, 0.0)
		_tails_animation.show()
		_tails_animation.play()


func _on_coin_animation_finished(is_successful_throw):
	if is_successful_throw:
		GlobalCoinEvents.coin_flip_succeeded.emit()
	else:
		GlobalCoinEvents.coin_flip_failed.emit()
