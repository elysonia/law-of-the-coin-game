extends Node2D


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
