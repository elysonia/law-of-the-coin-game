extends ModifierManager


func goto_next_trial():
	if _modifier.trial_effects != null:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)


func start_current_trial_effects():
	super.start_current_trial_effects()

	if _modifier.trial_effects.handicap == GlobalEnums.ModifierHandicap.NO_MONEY:
		GlobalLevelState.level_reward_money = 0
