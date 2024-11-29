extends RichTextLabel


func initialize():
	var default_level_win_rate_text = "[font_size={10}]" + "Default win rate: " + str(GlobalLevelState.get_level(GlobalLevelState.current_level_index).player_win_rate * 100) + " %" + "[/font_size]\n"
	append_text(default_level_win_rate_text)

	if GlobalLevelState.level_button_mash_time.value > 5:
		var button_mash_time_text = "[font_size={10}][color=green]" + "+" + str(GlobalLevelState.level_button_mash_time.value  - GlobalEnums.DEFAULT_BUTTON_MASH_TIME) + " button mash time from " + GlobalLevelState.level_button_mash_time.label + "[/color][/font_size]\n"
		append_text(button_mash_time_text)
	
	if GlobalLevelState.level_decrease_other_modifiers_effectiveness_by.value > 0.0:
		var decrease_other_modifiers_effectiveness_by_text = "[font_size={10}][color=red]" + "-" + str(GlobalLevelState.level_decrease_other_modifiers_effectiveness_by.value * 100) + "% modifier effectiveness from " + GlobalLevelState.level_decrease_other_modifiers_effectiveness_by.label + "[/color][/font_size]\n"
		append_text(decrease_other_modifiers_effectiveness_by_text)

	# Put some distance between the above special effects and modified effects.
	append_text("\n")

	var level_modifier_stats = GlobalLevelState.level_modifiers.reduce(
		func(accum, modifier_manager):
			var modifier = modifier_manager.get_modifier()

			var type = GlobalEnums.ModifierType.find_key(modifier.type)
			var title = (
				"[font_size={10}][b]"
				+ type.capitalize()
				+ ": "
				+ "[color=orange]"
				+ modifier.display_name
				+ "[/color][/b][/font_size]"
			)
	
			var current_trial_effects = []
			if modifier.trial_effects != null:
				var current_trial_add_chance = "[font_size={10}][color=green]" + "+ " + str(modifier_manager._get_additional_coin_pick_chance(modifier.trial_effects) * 100) + "%" + " success rate for current trial" + "[/color][/font_size]"
				var current_trial_handicap = "[font_size={10}]" + "Current trial handicap:  " + GlobalEnums.ModifierHandicap.find_key(modifier.trial_effects.handicap) + "[/font_size]"

				current_trial_effects.append_array([current_trial_add_chance, current_trial_handicap])
			
			var multi_trial_effects = []
			if modifier.multi_trial_effects != null:
				var multi_trial_add_chance = "[font_size={10}][color=green]" + "+ " + str(modifier_manager._get_additional_coin_pick_chance(modifier.multi_trial_effects) * 100)+ "%" + " success rate for multiple trials" + "[/color][/font_size]"
				
				var multi_trial_effects_counter = GlobalEnums.ModifierHandicap.find_key(modifier.multi_trial_effects.handicap)
				var multi_trial_handicap = "[font_size={10}]" + "Multi-trial handicap: " + str(multi_trial_effects_counter) + "[/font_size]"

				multi_trial_effects.append_array([multi_trial_add_chance, multi_trial_handicap])
				if modifier.multi_trial_effects.counter_modifier != null:
					var multi_trial_counter_modifier = "[font_size={10}]" + "Counter " + str(multi_trial_effects_counter) + " with: "  + modifier.multi_trial_effects.counter_modifier.display_name + "[/font_size]"
					multi_trial_effects.append(multi_trial_counter_modifier)

			var modifier_stats = []
			modifier_stats.append(title)
			modifier_stats.append_array(current_trial_effects)
			modifier_stats.append_array(multi_trial_effects)

			accum.append(modifier_stats)
			return accum
	, [])


	for stats_array in level_modifier_stats:
		var stats_string = "\n".join(stats_array) + "\n\n"
		append_text(stats_string)
