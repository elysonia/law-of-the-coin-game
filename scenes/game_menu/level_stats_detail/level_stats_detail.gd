extends RichTextLabel


func initialize():
	var default_level_win_rate_format_string = "[font_size={{10}}]Default win rate: {player_win_rate}% \nReward money: [color={reward_money_color}]${reward_money}[/color][/font_size]\n\n"
	var default_level_win_rate_text = default_level_win_rate_format_string.format(
		{
			player_win_rate =
			GlobalLevelState.get_level(GlobalLevelState.current_level_index).player_win_rate * 100,
			reward_money = GlobalLevelState.level_reward_money,
			reward_money_color = (
				func():
					if GlobalLevelState.level_reward_money == GlobalEnums.DEFAULT_REWARD_MONEY:
						return "white"

					if GlobalLevelState.level_reward_money > GlobalEnums.DEFAULT_REWARD_MONEY:
						return "lime"

					return "crimson"

						).call()
		}
	)
	append_text(default_level_win_rate_text)

	var button_mash_time_text = ""
	if GlobalLevelState.level_button_mash_time.value != GlobalEnums.DEFAULT_BUTTON_MASH_TIME:
		var button_mash_time_format_string = "[font_size={{10}}][color={color}] {operation}{level_button_mash_time_delta} button mash time.[/color][/font_size]"

		var is_button_mashed_time_increased = (
			GlobalLevelState.level_button_mash_time.value > GlobalEnums.DEFAULT_BUTTON_MASH_TIME
		)
		var operation_symbol = "+" if is_button_mashed_time_increased else ""
		var text_color = "green" if is_button_mashed_time_increased else "hot_pink"

		button_mash_time_text = (
			button_mash_time_format_string
			. format(
				{
					color = text_color,
					operation = operation_symbol,
					level_button_mash_time_delta =
					(
						GlobalLevelState.level_button_mash_time.value
						- GlobalEnums.DEFAULT_BUTTON_MASH_TIME
					),
				}
			)
		)

	var decrease_other_modifiers_effectiveness_by_text = ""
	if GlobalLevelState.level_decrease_other_modifiers_effectiveness_by.value > 0.0:
		var decrease_other_modifiers_effectiveness_by_format_string = "[font_size={{10}}][color=hot_pink] -{decrease_other_modifiers_effectiveness_by}% modifier effectiveness[/color][/font_size]"

		decrease_other_modifiers_effectiveness_by_text = (
			decrease_other_modifiers_effectiveness_by_format_string
			. format(
				{
					decrease_other_modifiers_effectiveness_by =
					GlobalLevelState.level_decrease_other_modifiers_effectiveness_by.value * 100
				}
			)
		)

	var button_mash_increment_rate_text = ""
	if (
		GlobalLevelState.level_button_mash_increment_rate.value
		!= GlobalEnums.ARROW_KEY_INCREMENT_RATE
	):
		var button_mash_increment_rate_format_string = "[font_size={10}][color=lightblue]{button_mash_increment_rate}% to increment rate by button mashing[/color][/font_size]"

		button_mash_increment_rate_text = button_mash_increment_rate_format_string.format(
			{
				button_mash_increment_rate =
				(
					(
						GlobalLevelState.level_button_mash_increment_rate.value
						- GlobalEnums.ARROW_KEY_INCREMENT_RATE
					)
					/ GlobalEnums.ARROW_KEY_INCREMENT_RATE
					* 100
				)
			}
		)

	
	var next_trial_costs_map = GlobalLevelState.level_modifiers.reduce(
		func(accum, modifier_manager):
			return get_effects_trial_cost_details(modifier_manager, "next_trial_effects", accum), 
			{
				fixed_trial_cost = 0,
				fixed_trial_cost_desc = "",
				range_trial_cost = 0,
				range_trial_cost_desc = "",
				name = ""
			}
		)
	print({"next_trial_costs_map": next_trial_costs_map})
	var level_modifier_stats = GlobalLevelState.level_modifiers.reduce(
		func(accum, modifier_manager):
			var modifier = modifier_manager.get_modifier()
			var type = GlobalEnums.ModifierType.find_key(modifier.type)

			var is_current_button_mash_time_effect = (
				GlobalLevelState.level_button_mash_time.name == modifier.name
			)
			var is_current_button_mash_increment_rate_effect = (
				GlobalLevelState.level_button_mash_increment_rate.name == modifier.name
			)
			var is_current_decrease_other_modifiers_effectiveness_by_effect = (
				GlobalLevelState.level_decrease_other_modifiers_effectiveness_by.name
				== modifier.name
			)

			var title_format_string = "[font_size={{10}}][b]{type}:[color=orange] {display_name}[/color][/b][/font_size]"
			var title = title_format_string.format(
				{type = type.capitalize(), display_name = modifier.display_name}
			)

			var special_modifier_effects = []
			# if is_current_trial_cost_effect:
			# 	special_modifier_effects.append(trial_costs_text)
			if is_current_button_mash_time_effect:
				special_modifier_effects.append(button_mash_time_text)
			if is_current_button_mash_increment_rate_effect:
				special_modifier_effects.append(button_mash_increment_rate_text)
			if is_current_decrease_other_modifiers_effectiveness_by_effect:
				special_modifier_effects.append(decrease_other_modifiers_effectiveness_by_text)

			var current_trial_effects_array = get_modifier_effects_stats_detail_string_array(
				modifier_manager, "trial_effects"
			)
			# var next_trial_cost_effects = get_effects_trial_cost_details(modifier_manager, "next_trial_effects", accum.next_trial_cost_details)
			var multi_trial_effects_array = get_modifier_effects_stats_detail_string_array(
				modifier_manager, "multi_trial_effects"
			)

			var modifier_stats = []
			modifier_stats.append(title)
			modifier_stats.append_array(
				special_modifier_effects.filter(func(effect): return not effect.is_empty())
			)
			modifier_stats.append_array(
				current_trial_effects_array.filter(func(effect): return not effect.is_empty())
			)
			modifier_stats.append_array(
				multi_trial_effects_array.filter(func(effect): return not effect.is_empty())
			)

			if modifier.name == next_trial_costs_map.name:
				var next_fixed_trial_costs_format_string = "[font_size={{10}}]Next trial will cost [color={color}]{fixed_trial_cost} coin(s) as {fixed_trial_cost_desc}.[/color][/font_size]"
				var next_range_trial_costs_format_string = "[font_size={{10}}]Next trial will cost extra [color=hot_pink]1 - {range_trial_cost} coin(s) as {range_trial_cost_desc}.[/color][/font_size]"

				if next_trial_costs_map.fixed_trial_cost > 0:
					var next_fixed_trial_costs_text = next_fixed_trial_costs_format_string.format(
						{
							color =
							"ivory" if next_trial_costs_map.fixed_trial_cost < 3 else "deep_pink",
							fixed_trial_cost = next_trial_costs_map.fixed_trial_cost,
							fixed_trial_cost_desc = next_trial_costs_map.fixed_trial_cost_desc
						}
					)
					modifier_stats.append(next_fixed_trial_costs_text)

				if next_trial_costs_map.range_trial_cost > 0:
					var next_range_trial_costs_text = next_range_trial_costs_format_string.format(
						{
							range_trial_cost = next_trial_costs_map.range_trial_cost,
							range_trial_cost_desc = next_trial_costs_map.range_trial_cost_desc
						}
					)
					modifier_stats.append(next_range_trial_costs_text)
			
			accum.append(modifier_stats)
			return accum,

		[],
	)

	for stats_array in level_modifier_stats:
		var stats_string = "\n".join(stats_array) + "\n\n"
		append_text(stats_string)


func get_modifier_effects_stats_detail_string_array(modifier_manager, effects_name: String = ""):
	var effects_string_array = []
	var modifier = modifier_manager.get_modifier()
	var effects = modifier[effects_name]

	if effects == null:
		return effects_string_array

	var effect_type_text_map = {
		trial_effects = "Current trial",
		multi_trial_effects = "Multiple trials"
	}

	var add_chance_format_string = "[font_size={{10}}][color={color}]{operator} {additional_pick_chance}% success rate for {effect_type_text}.[/color][/font_size]"

	var additional_pick_chance = modifier_manager._get_additional_coin_pick_chance(effects) * 100
	var pick_chance_operator = "+" if additional_pick_chance > 0 else ""
	var format_string_color = "green" if additional_pick_chance > 0 else "hot_pink"

	var trial_add_chance_text = (
		add_chance_format_string.format(
			{
				color = format_string_color,
				operator = pick_chance_operator,
				additional_pick_chance = additional_pick_chance,
				effect_type_text = effect_type_text_map[effects_name]
			}
		)
		if additional_pick_chance != 0
		else ""
	)

	effects_string_array.append(trial_add_chance_text)

	var is_same_handicap_for_effect_types = (
		func():
			var trial_effects_handicap = (
					modifier.trial_effects.handicap if modifier.trial_effects != null else GlobalEnums.ModifierHandicap.NONE 
				)
			var multi_trial_effects_handicap = (
					modifier.multi_trial_effects.handicap if modifier.multi_trial_effects != null else GlobalEnums.ModifierHandicap.NONE  
				)
			
			if GlobalEnums.ModifierHandicap.NONE in [trial_effects_handicap, multi_trial_effects_handicap]:
				return false

			return trial_effects_handicap == multi_trial_effects_handicap
	).call()

	var should_show_handicap_text = (
		func():
			if effects.handicap == GlobalEnums.ModifierHandicap.NONE:
				return false
			if not is_same_handicap_for_effect_types:
				return true

			return is_same_handicap_for_effect_types and effects_name == "multi_trial_effects"
	).call()

	if should_show_handicap_text:
		var handicap_format_string = "[font_size={{10}}][color=coral]{handicap_effect_type} handicap: {handicap}[/color][/font_size]"
		var modifier_handicap = GlobalEnums.ModifierHandicap.find_key(effects.handicap)

		var trial_handicap_text = (
			handicap_format_string.format({
				handicap_effect_type = effect_type_text_map[effects_name],
				handicap = modifier_handicap})
			if effects.handicap != GlobalEnums.ModifierHandicap.NONE
			else ""
		)

		effects_string_array.append(trial_handicap_text)


	var is_same_counter_modifier_for_effect_types = (
		func():
			var trial_effects_counter_modifier_name = (
				func():
					if modifier.trial_effects == null:
						return ""

					if modifier.trial_effects.counter_modifier == null:
						return ""

					return modifier.trial_effects.counter_modifier.name
			).call()

			var multi_trial_effects_counter_modifier_name = (
				func():
					if modifier.multi_trial_effects == null:
						return ""

					if modifier.multi_trial_effects.counter_modifier == null:
						return ""

					return modifier.multi_trial_effects.counter_modifier.name
			).call()

			return trial_effects_counter_modifier_name == multi_trial_effects_counter_modifier_name
	).call()

	var should_show_counter_modifier_text = (
		func():
			if effects.counter_modifier == null:
				return false

			if not is_same_counter_modifier_for_effect_types:
				return true

			return is_same_counter_modifier_for_effect_types and effects_name == "multi_trial_effects"
	).call()

	if should_show_counter_modifier_text:
		var is_modifier_countered = GlobalLevelState.level_modifiers.filter(
			func(level_modifier_manager):
				var modifier_obj = level_modifier_manager.get_modifier()
				return modifier_obj.name == effects.counter_modifier.name
		).size() > 0

		var modifier_handicap = GlobalEnums.ModifierHandicap.find_key(effects.handicap)

		if is_modifier_countered:
			var effects_countered_format_string = "[font_size={{10}}][color=blanched_almond]{modifier_handicap} removed by {modifier_counter}![/color][/font_size]"
			var effects_countered_text = effects_countered_format_string.format({
				modifier_handicap = modifier_handicap,
				modifier_counter = effects.counter_modifier.display_name
			})

			effects_string_array.append(effects_countered_text)
		else:
			var effects_counter_modifier_format_string = "[font_size={{10}}][color=blanched_almond]Remove {modifier_handicap} with: {modifier_counter}[/color][/font_size]"
			var effects_counter_modifier_text = effects_counter_modifier_format_string.format(
				{
					modifier_handicap = modifier_handicap,
					modifier_counter = effects.counter_modifier.display_name
				}
			)

			effects_string_array.append(effects_counter_modifier_text)

	return effects_string_array


func get_effects_trial_cost_details(modifier_manager, effects_name, next_trial_cost_map):
	var new_next_trial_cost_map = next_trial_cost_map.duplicate()

	var modifier_obj = modifier_manager.get_modifier()
	var effects = modifier_obj[effects_name]
	if effects == null:
		return new_next_trial_cost_map

	var has_existing_fixed_trial_cost = new_next_trial_cost_map.fixed_trial_cost > 0
	var has_existing_range_trial_cost = new_next_trial_cost_map.range_trial_cost > 0

	var is_new_fixed_trial_cost = not has_existing_fixed_trial_cost and effects.fixed_trial_cost > 0 
	var is_new_range_trial_cost = effects.range_trial_cost != null and effects.range_trial_cost > 0 and (not has_existing_fixed_trial_cost and not is_new_fixed_trial_cost)

	var should_replace_fixed_trial_cost = (
		has_existing_fixed_trial_cost 
		and effects.fixed_trial_cost != null
		and effects.fixed_trial_cost > 0 
		and effects.fixed_trial_cost < new_next_trial_cost_map.fixed_trial_cost
	)

	var should_replace_range_trial_cost = (
		has_existing_range_trial_cost
		and not is_new_fixed_trial_cost
		and not has_existing_fixed_trial_cost
		and effects.range_trial_cost != null
		and effects.range_trial_cost > 0
		and effects.range_trial_cost > new_next_trial_cost_map.range_trial_cost
	)

	if is_new_fixed_trial_cost or should_replace_fixed_trial_cost:
		new_next_trial_cost_map.fixed_trial_cost = effects.fixed_trial_cost
		new_next_trial_cost_map.fixed_trial_cost_desc = effects.fixed_trial_cost_desc
		new_next_trial_cost_map.range_trial_cost =  effects.range_trial_cost
		new_next_trial_cost_map.range_trial_cost_desc = effects.range_trial_cost_desc

		new_next_trial_cost_map.name = modifier_obj.name
	
	if is_new_range_trial_cost or should_replace_range_trial_cost:
		new_next_trial_cost_map.range_trial_cost =  effects.range_trial_cost
		new_next_trial_cost_map.range_trial_cost_desc = effects.range_trial_cost_desc

		new_next_trial_cost_map.name = modifier_obj.name

	
	print({"modifier_obj.name": modifier_obj.name, "is_new_fixed_trial_cost": is_new_fixed_trial_cost, "is_new_range_trial_cost": is_new_range_trial_cost,"should_replace_fixed_trial_cost":should_replace_fixed_trial_cost, "should_replace_range_trial_cost": should_replace_range_trial_cost, "next_trial_cost_map":next_trial_cost_map,})

	return new_next_trial_cost_map