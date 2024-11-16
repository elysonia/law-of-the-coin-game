extends ModifierManager


func start_current_trial_effects():
	super.start_current_trial_effects()
	GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
