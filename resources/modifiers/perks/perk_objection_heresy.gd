extends ModifierManager


func goto_next_trial():
	if _modifier.trial_effects.handicap != GlobalEnums.ModifierHandicap.NONE:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)


func start_current_trial_effects():
	super.start_current_trial_effects()

	# Increase button mash time
	if (
		_modifier.trial_effects.button_mash_time_increase
		> GlobalLevelState.level_button_mash_time.value
	):
		GlobalLevelState.level_button_mash_time = {
			value = _modifier.trial_effects.button_mash_time_increase,
			label = _modifier.display_name
		}

	# Decrease other modifiers' effectiveness
	if (
		_modifier.trial_effects.decrease_other_modifiers_effectiveness_by
		> GlobalLevelState.level_decrease_other_modifiers_effectiveness_by.value
	):
		GlobalLevelState.level_decrease_other_modifiers_effectiveness_by = {
			value = _modifier.trial_effects.decrease_other_modifiers_effectiveness_by,
			label = _modifier.display_name
		}
