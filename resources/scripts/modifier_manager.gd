# Base class for managing modifiers in effect.
class_name ModifierManager
extends Node

var _modifier: Modifier

# Default behavior as reference:
# 1. Deducts modifier fee from the player money.
# 2. Applies player win rate effects.
# 3. Checks if effects can be applied/removed from current level.


func _init(modifier: Modifier):
	_modifier = modifier.duplicate()

	# Deduct fee from player money.
	var new_player_money = GlobalLevelState.money - _modifier.price
	var money_update_text = " ".join(["-$", str(_modifier.price), _modifier.display_name])
	GlobalLevelState.set_money(new_player_money, money_update_text, true)


## Getter for the "stopped" state of the modifier.
func get_is_stopped():
	return (
		_modifier.trial_effects == null
		and _modifier.next_trial_effects == null
		and _modifier.multi_trial_effects == null
	)


## Getter for the modifier data.
func get_modifier():
	return _modifier


## Apply effects that influences the start of next
## modifier selection like handicaps, extra costs
func goto_next_trial():
	pass


## Apply effects influencing the start of the next
## coin toss like player win rate
func start_trial():
	start_current_trial_effects()
	start_multi_trial_effects()


func end_trial():
	stop_current_trial_effects()
	stop_multi_trial_effects()


func start_current_trial_effects():
	if _modifier.trial_effects == null:
		return

	if _check_is_effect_countered(_modifier.trial_effects) >= 0:
		_modifier.trial_effects = null
		return

	_change_player_choice_success_rate(_modifier.trial_effects)


func start_multi_trial_effects():
	if _modifier.multi_trial_effects == null:
		return

	if _check_is_effect_countered(_modifier.multi_trial_effects) >= 0:
		_modifier.multi_trial_effects = null
		return

	_change_player_choice_success_rate(_modifier.multi_trial_effects)


func stop_current_trial_effects():
	if _modifier.next_trial_effects == null:
		_modifier.trial_effects = null
		return

	_modifier.trial_effects = _modifier.next_trial_effects
	_modifier.next_trial_effects = null


func stop_multi_trial_effects():
	if _modifier.multi_trial_effects == null:
		return

	if _check_is_effect_countered(_modifier.multi_trial_effects) >= 0:
		_modifier.multi_trial_effects = null


func _check_is_effect_countered(modifier_effect):
	return GlobalLevelState.level_modifiers.find(
		func(modifier_manager):
			return modifier_effect.counter_modifier.name == modifier_manager.get_modifier().name
	)


func _get_exponential_value_for_current_level(value):
	# Effects start at current_level_index 1, no increment necessary.
	if GlobalLevelState.current_level_index == 1:
		return value

	var exponentiated_value = value

	for _level in range(0, GlobalLevelState.current_level_index):
		exponentiated_value *= 2

	return exponentiated_value


func _change_player_choice_success_rate(effects):
	var additional_coin_pick_chance = (
		(func():
			if effects.coin_pick_chance_increment == 2.0:
				return _get_exponential_value_for_current_level(effects.fixed_coin_pick_chance)

			return (
				(effects.coin_pick_chance_increment * (GlobalLevelState.current_level_index + 1))
			))
		. call()
	)

	GlobalLevelState.player_win_rate += additional_coin_pick_chance
