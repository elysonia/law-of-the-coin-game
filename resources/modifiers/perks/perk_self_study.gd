extends ModifierManager


func start_current_trial_effects():
	if not _modifier.trial_effects:
		return

	if _check_is_effect_countered(_modifier.trial_effects):
		_modifier.trial_effects = null
		return

	GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
	# TODO: Blur screen here

	_change_player_choice_success_rate(_modifier.trial_effects)


func start_multi_trial_effects():
	if not _modifier.multi_trial_effects:
		return

	if _check_is_effect_countered(_modifier.multi_trial_effects):
		_modifier.multi_trial_effects = null
		return

	if _modifier.multi_trial_effects.handicap not in GlobalLevelState.level_modifier_handicaps:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
		# TODO: Blur screen here

	_change_player_choice_success_rate(_modifier.multi_trial_effects)


func stop_current_trial_effects():
	super.stop_current_trial_effects()
	# TODO: Stop screen blur here
