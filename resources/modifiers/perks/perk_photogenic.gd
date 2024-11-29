extends ModifierManager


func _get_additional_coin_pick_chance(effects):
	if effects.coin_pick_chance_increment == -2.0:
		return (
			_get_exponential_value_for_current_level(effects.fixed_coin_pick_chance) / 2
		)

	if effects.coin_pick_chance_increment == 2.0:
		return _get_exponential_value_for_current_level(effects.fixed_coin_pick_chance)

	return effects.coin_pick_chance_increment * (GlobalLevelState.current_level_index)


func _change_player_choice_success_rate(effects):
	# Reduce the success rate at the rate of success in the previous round.
	if effects.coin_pick_chance_increment == -2.0:
		var current_increment_rate = _get_additional_coin_pick_chance(effects)
		GlobalLevelState.player_win_rate += current_increment_rate
		return

	super._change_player_choice_success_rate(effects)
