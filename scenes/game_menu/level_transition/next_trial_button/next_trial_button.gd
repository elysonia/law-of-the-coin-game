extends Button


func _pressed():
	# Prevent attempting to start a level that doesn't exist
	if GlobalLevelState.check_is_last_level():
		return

	# Reset special effects
	GlobalLevelState.level_reward_money = GlobalEnums.DEFAULT_REWARD_MONEY
	GlobalLevelState.level_trial_costs = {
		fixed_trial_cost = 0,
		fixed_trial_cost_desc = "",
		range_trial_cost = 0,
		range_trial_cost_desc = "",
		name = ""
	}
	GlobalLevelState.level_button_mash_time = {value = GlobalEnums.DEFAULT_BUTTON_MASH_TIME, label = "", name = ""}
	GlobalLevelState.level_button_mash_increment_rate = {
		value = GlobalEnums.ARROW_KEY_INCREMENT_RATE, label = "", name = ""
	}
	GlobalLevelState.level_decrease_other_modifiers_effectiveness_by = {value = 0.0, label = "", name = ""}
	GlobalLevelState.level_modifier_handicaps = []
	

	var new_level_modifiers = []

	for modifier_manager in GlobalLevelState.level_modifiers:
		modifier_manager.end_trial()

		# Remove modifiers that are no longer in effect
		if not modifier_manager.get_is_stopped():
			new_level_modifiers.append(modifier_manager)

			# Start modifiers that should apply immediately 
			# on the modifier selection screen.
			modifier_manager.goto_next_trial()
	

	if GlobalLevelState.check_is_next_level_last_level():
		var updated_perks = GlobalLevelState.modifiers.perks.map(
			func(original_modifier):
				if original_modifier.appear_condition == GlobalEnums.ModifierAppearCondition.LAST_TRIAL:
					original_modifier.can_be_picked = true
				return original_modifier
		)
		var updated_items = GlobalLevelState.modifiers.items.map(
			func(original_modifier):
				if original_modifier.appear_condition == GlobalEnums.ModifierAppearCondition.LAST_TRIAL:
					original_modifier.can_be_picked = true
				return original_modifier
		)

		GlobalLevelState.modifiers = {
			items = updated_items,
			perks = updated_perks
		}
		
	if GlobalLevelState.level_modifier_handicaps.has(GlobalEnums.ModifierHandicap.BLURRY_VISION):
		var updated_perks = GlobalLevelState.modifiers.perks.map(
			func(original_modifier):
				if original_modifier.appear_condition == GlobalEnums.ModifierAppearCondition.BLURRY_VISION:
					original_modifier.can_be_picked = true
				return original_modifier
		)

		var updated_items = GlobalLevelState.modifiers.items.map(
			func(original_modifier):
				if original_modifier.appear_condition == GlobalEnums.ModifierAppearCondition.BLURRY_VISION:
					original_modifier.can_be_picked = true
				return original_modifier
		)

		
		GlobalLevelState.modifiers = {
			items = updated_items,
			perks = updated_perks
		}

	GlobalLevelState.level_modifiers = new_level_modifiers
	
	var next_trial_cost_map = GlobalLevelState.level_modifiers.reduce(
		func(accum, modifier_manager):
			var modifier_obj = modifier_manager.get_modifier()
			var current_trial_effects = modifier_obj.trial_effects
		
			if current_trial_effects == null:
				return accum

			var has_trial_cost = accum.fixed_trial_cost > 0
			var is_new_trial_cost = not has_trial_cost and current_trial_effects.fixed_trial_cost > 0 
			var should_replace_trial_cost = (
				has_trial_cost 
				and current_trial_effects.fixed_trial_cost > 0 
				and current_trial_effects.fixed_trial_cost < accum.fixed_trial_cost
			)

			if is_new_trial_cost or should_replace_trial_cost:
				accum.fixed_trial_cost = current_trial_effects.fixed_trial_cost
				accum.fixed_trial_cost_desc = current_trial_effects.fixed_trial_cost_desc

				var range_trial_cost_result = (randi_range(1, current_trial_effects.range_trial_cost) if current_trial_effects != null and current_trial_effects.range_trial_cost else 0
				)
				accum.range_trial_cost = range_trial_cost_result
				accum.range_trial_cost_desc = current_trial_effects.range_trial_cost_desc

				accum.name = modifier_obj.name

			return accum
			, {
			fixed_trial_cost = 0,
			fixed_trial_cost_desc = "",
			range_trial_cost = 0,
			range_trial_cost_desc = "",
			name = ""
		})

	var next_level_index = GlobalLevelState.current_level_index + 1
	var next_level = GlobalLevelState.get_level(next_level_index)
	var next_level_fee = next_trial_cost_map.fixed_trial_cost if next_trial_cost_map != null and next_trial_cost_map.fixed_trial_cost > 0 else randi_range(1, 3)
	var next_level_fee_text = next_trial_cost_map.fixed_trial_cost_desc if next_trial_cost_map != null and next_trial_cost_map.fixed_trial_cost > 0 else "trial fee"

	GlobalLevelState.level_trial_costs = next_trial_cost_map
	GlobalLevelState.current_level_index = next_level_index
	GlobalLevelState.player_win_rate = next_level.player_win_rate

	var next_level_fee_notification = "-$" + str(next_level_fee) + " " + next_level_fee_text
	var next_level_extra_fee_notification = "-$" + str(next_trial_cost_map.range_trial_cost) + " " + next_trial_cost_map.range_trial_cost_desc if next_trial_cost_map != null and next_trial_cost_map.range_trial_cost > 0 else ""
	
	GlobalLevelState.set_money(GlobalLevelState.money - next_level_fee, next_level_fee_notification, true)
	
	if next_trial_cost_map != null and next_trial_cost_map.range_trial_cost > 0:
		GlobalLevelState.set_money(GlobalLevelState.money - next_trial_cost_map.range_trial_cost, next_level_extra_fee_notification, true)
	
	GlobalLevelState.game_mode_changed.emit(GlobalEnums.GameMode.MODIFIER_SELECTION)
