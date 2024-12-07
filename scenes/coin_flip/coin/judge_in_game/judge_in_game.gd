extends Node2D


@onready var _judge_animation_sprite = $JudgeAnimationSprite


func get_animation():
	return _judge_animation_sprite


func normal():
	_judge_animation_sprite.stop()
	_judge_animation_sprite.play("normal")


func thinking():
	_judge_animation_sprite.stop()
	_judge_animation_sprite.play("thinking")


func hit_gavel():
	_judge_animation_sprite.stop()
	_judge_animation_sprite.play("hit_gavel")
