extends Node2D


var _next_yawn_time = null
var _is_yawning = false
var _last_player_animation = null

@onready var _accessories_front = $AccessoriesFront
@onready var _accessories_back = $AccessoriesBack
@onready var _player_animation = $PlayerAnimation

@onready var _perk_objection_heresy = preload(
		"res://resources/modifiers/perks/perk_objection_heresy.tres"
	)
@onready var _perk_photogenic = preload("res://resources/modifiers/perks/perk_photogenic.tres")
@onready var _perk_self_study = preload("res://resources/modifiers/perks/perk_self_study.tres")
@onready var _item_gavel = preload("res://resources/modifiers/items/item_gavel.tres")
@onready var _item_glasses = preload("res://resources/modifiers/items/item_glasses.tres")


func _ready():
	blink()
	check_tears()
	check_judge_outfit()
	check_glasses()
	check_mask()
	check_squint()


func _process(_delta):
	var current_time_msec = Time.get_ticks_msec()
	var should_play_yawn = (
		func():
			if _is_yawning:
				return false 

			if _next_yawn_time == null:
				_next_yawn_time = current_time_msec + get_yawn_interval()
				return false

			return current_time_msec >= _next_yawn_time
	).call()
	
	if should_play_yawn:
		_last_player_animation = _player_animation.get_animation()
		yawn()
		

func check_tears():
	var level_modifiers = GlobalLevelState.level_modifiers

	var has_perk_objection_heresy = level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == _perk_objection_heresy.name
	).size() > 0

	if has_perk_objection_heresy:
		var tears_animation = _accessories_front.get_node("TearsAnimation")
		tears_animation.show()
		tears_animation.play()


func check_judge_outfit():
	var level_modifiers = GlobalLevelState.level_modifiers

	var has_item_gavel = level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == _item_gavel.name
	).size() > 0

	if has_item_gavel:
		var judge_outfit = _accessories_front.get_node("JudgeOutfit")
		judge_outfit.show()


func check_glasses():
	var level_modifiers = GlobalLevelState.level_modifiers

	var has_item_glasses = level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == _item_glasses.name
	).size() > 0

	if has_item_glasses:
		var glasses = _accessories_front.get_node("Glasses")
		glasses.show()


func check_mask():
	var level_modifiers = GlobalLevelState.level_modifiers

	var has_perk_photogenic = level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == _perk_photogenic.name
	).size() > 0

	if has_perk_photogenic:
		var mask = _accessories_back.get_node("Mask")
		var mask_string = _accessories_front.get_node("MaskString")

		mask.show()
		mask_string.show()


func check_squint():
	var level_modifiers = GlobalLevelState.level_modifiers

	var has_perk_self_study = level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == _perk_self_study.name
	).size() > 0

	if has_perk_self_study:
		squint()


func blink():
	_player_animation.stop()
	_player_animation.play("blink")


func squint():
	_player_animation.stop()
	_player_animation.play("squint")


func yawn():
	_player_animation.stop()
	_is_yawning = true
	_player_animation.play("yawn")

	await _player_animation.animation_finished
	_is_yawning = false
	_player_animation.play(_last_player_animation)
	_last_player_animation = null

	var current_time_msec = Time.get_ticks_msec()
	_next_yawn_time = current_time_msec + get_yawn_interval()


func get_yawn_interval():
	return randi_range(4000, 8000)