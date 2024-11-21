extends ModifierManager


func goto_next_trial():
	if _modifier.trial_effects:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
		# TODO: Blur screen here

	if _modifier.multi_trial_effects.handicap not in GlobalLevelState.level_modifier_handicaps:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
		# TODO: Blur screen here


func stop_current_trial_effects():
	super.stop_current_trial_effects()
	# TODO: Stop screen blur here
