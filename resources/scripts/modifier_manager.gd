# Base class for managing modifiers in effect.
class_name ModifierManager
extends Node

var _modifier: Modifier
var _parent_node

# Default behavior as reference:
# 1. Deducts modifier fee from the player money.
# 2. Applies player win rate effects.
# 3. Checks if effects can be applied/removed from current level.


func _init(modifier: Modifier, parent_node):
	_modifier = modifier.duplicate()
	_parent_node = parent_node
	# Deduct fee from player money.
	var new_player_money = GlobalLevelState.money - _modifier.price
	var money_update_text = " ".join(["-$", str(_modifier.price), _modifier.display_name])
	GlobalLevelState.set_money(new_player_money, money_update_text, true)

	_update_global_level_state_modifiers()


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

	if _check_is_effect_countered(_modifier.trial_effects):
		_modifier.trial_effects = null
		return

	_change_player_choice_success_rate(_modifier.trial_effects)


func start_multi_trial_effects():
	if _modifier.multi_trial_effects == null:
		return

	if _check_is_effect_countered(_modifier.multi_trial_effects):
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

	if _check_is_effect_countered(_modifier.multi_trial_effects):
		_modifier.multi_trial_effects = null


func _check_is_effect_countered(modifier_effect):
	var counters = GlobalLevelState.level_modifiers.filter(
		func(modifier_manager):
			if modifier_effect.counter_modifier != null:
				return modifier_effect.counter_modifier.name == modifier_manager.get_modifier().name
			return false
	)

	return counters.size() > 0


func _get_exponential_value_for_current_level(value):
	# Effects start at current_level_index 1, no increment necessary.
	if GlobalLevelState.current_level_index == 1:
		return value

	var exponentiated_value = value

	for _level in range(0, GlobalLevelState.current_level_index):
		exponentiated_value *= 2

	return exponentiated_value


func _get_additional_coin_pick_chance(effects):
	if effects.coin_pick_chance_increment == 2.0:
		return _get_exponential_value_for_current_level(effects.fixed_coin_pick_chance)

	return (
		effects.fixed_coin_pick_chance
		+ (effects.coin_pick_chance_increment * (GlobalLevelState.current_level_index - 1))
	)


func _change_player_choice_success_rate(effects):
	var additional_coin_pick_chance = _get_additional_coin_pick_chance(effects)

	GlobalLevelState.player_win_rate += (
		additional_coin_pick_chance
		* (1 - GlobalLevelState.level_decrease_other_modifiers_effectiveness_by.value)
	)


func _update_global_level_state_modifiers():
	var modifier_type = (GlobalEnums.ModifierType.keys()[_modifier.type] + "s").to_lower()

	var updated_modifiers = GlobalLevelState.modifiers[modifier_type].map(
		func(original_modifier):
			if original_modifier.name == _modifier.name:
				original_modifier.can_be_picked = false

			return original_modifier
	)

	GlobalLevelState.modifiers.set(modifier_type, updated_modifiers)
