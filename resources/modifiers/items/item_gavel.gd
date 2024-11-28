extends ModifierManager


func goto_next_trial():
	GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)


func _change_player_choice_success_rate(effects):
	GlobalLevelState.player_win_rate += effects.fixed_coin_pick_chance
