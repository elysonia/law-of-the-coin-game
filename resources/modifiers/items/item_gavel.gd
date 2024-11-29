extends ModifierManager


func goto_next_trial():
	if _modifier.trial_effects != null:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
