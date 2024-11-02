class_name Coin
extends Node2D

@onready var _tails_animation = $TailsAnimatedSprite2D
@onready var _heads_animation = $HeadsAnimatedSprite2D


func _ready():
	_tails_animation.hide()
	_heads_animation.hide()


func _process(_delta):
	pass


# Show faceless coin before flipping animation
func _reset_animation():
	_tails_animation.hide()
	_heads_animation.set_frame(0)
	_heads_animation.show()


func _on_player_control_flip_delay_timer_started():
	_reset_animation()


func _on_coin_side_random_picker_coin_side_selected(result: Variant):
	_reset_animation()

	if result == "heads":
		_tails_animation.hide()
		_heads_animation.set_frame_and_progress(0, 0.0)
		_heads_animation.show()
		_heads_animation.play()

	elif result == "tails":
		_heads_animation.hide()
		_tails_animation.set_frame_and_progress(0, 0.0)
		_tails_animation.show()
		_tails_animation.play()
