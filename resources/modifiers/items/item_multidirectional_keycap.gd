extends ModifierManager


func start_multi_trial_effects():
	var button_mash_increment_rate = _modifier.multi_trial_effects.button_mash_increment_rate
	print("multidirectionlkeycap", button_mash_increment_rate)
	super.start_multi_trial_effects()

	if (
		GlobalEnums.ARROW_KEY_INCREMENT_RATE * (1 + button_mash_increment_rate)
		< GlobalLevelState.level_button_mash_increment_rate.value
	):
		GlobalLevelState.level_button_mash_increment_rate = {
			value = GlobalEnums.ARROW_KEY_INCREMENT_RATE * (1 + button_mash_increment_rate),
			label = _modifier.display_name
		}
