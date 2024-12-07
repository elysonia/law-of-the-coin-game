extends Node2D


@onready var _judge_animation_sprite = $JudgeAnimationSprite
@onready var _accessories_front = $AccessoriesFront
@onready var _perk_better_lawyer = preload(
		"res://resources/modifiers/perks/perk_better_lawyer.tres"
	)
@onready var _perk_hush_money_burger = preload(
		"res://resources/modifiers/perks/perk_hush_money_burger.tres"
	)
@onready var _item_gavel = preload("res://resources/modifiers/items/item_gavel.tres")


func _ready():
	check_money_stack()
	check_number_one_necklace()
	check_empty_seat()


func get_animation():
	return _judge_animation_sprite


func check_money_stack():
	var level_modifiers = GlobalLevelState.level_modifiers

	var has_perk_hush_money_burger = level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == _perk_hush_money_burger.name
	).size() > 0

	if has_perk_hush_money_burger:
		var money_stack = _accessories_front.get_node("MoneyStack")
		money_stack.show()

	return has_perk_hush_money_burger

func check_number_one_necklace():
	var level_modifiers = GlobalLevelState.level_modifiers

	var has_perk_better_lawyer = level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == _perk_better_lawyer.name
	).size() > 0

	if has_perk_better_lawyer:
		var number_one_necklace = _accessories_front.get_node("NumberOneNecklace")
		number_one_necklace.show()

	return has_perk_better_lawyer


func check_empty_seat():
	var level_modifiers = GlobalLevelState.level_modifiers

	var has_item_gavel = level_modifiers.filter(
		func(modifier_manager):
			return modifier_manager.get_modifier().name == _item_gavel.name
	).size() > 0

	if has_item_gavel:
		empty_seat()

	return has_item_gavel

func normal():
	var should_play = not check_empty_seat()
	
	if should_play:
		_judge_animation_sprite.stop()
		_judge_animation_sprite.play("normal")


func thinking():
	var should_play = not check_empty_seat()

	if should_play:
		_judge_animation_sprite.stop()
		_judge_animation_sprite.play("thinking")


func hit_gavel():
	var should_play = not check_empty_seat()

	if should_play:
		_judge_animation_sprite.stop()
		_judge_animation_sprite.play("hit_gavel")


func empty_seat():
	_judge_animation_sprite.stop()
	_judge_animation_sprite.play("empty_seat")
