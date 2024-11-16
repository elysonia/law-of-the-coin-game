extends ModifierManager


func _change_player_choice_success_rate(effects):
	if effects.coin_pick_chance_increment == -2.0:
		var current_increment_rate = (
			_get_exponential_value_for_current_level(effects.fixed_coin_pick_chance) / 2
		)
		GlobalLevelState.player_win_rate += current_increment_rate
		return

	super._change_player_choice_success_rate(effects)
