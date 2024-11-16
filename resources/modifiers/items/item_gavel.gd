extends ModifierManager


func start_current_trial_effects():
	if not _modifier.trial_effects:
		return

	if _check_is_effect_countered(_modifier.trial_effects):
		_modifier.trial_effects = null
		return

	GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
	_change_player_choice_success_rate(_modifier.trial_effects)
