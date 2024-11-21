extends ModifierManager


func goto_next_trial():
	GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
