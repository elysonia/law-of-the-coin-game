extends Node2D
class_name Coin


@onready var _tails_animation = $TailsAnimatedSprite2D
@onready var _heads_animation = $HeadsAnimatedSprite2D


func _ready():
	_tails_animation.hide()
	_heads_animation.hide()


func _process(_delta):
	pass


func _on_coin_side_selection__coin_side_selected(result:Variant):
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
		


func _on_coin_side_selection__flip_delay_timer_started():
	_tails_animation.hide()
	_heads_animation.hide()
