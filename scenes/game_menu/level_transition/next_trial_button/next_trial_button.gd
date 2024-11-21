extends Button


func _ready():
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	disabled = true
	hide()


func _pressed():
	# Prevent attempting to start a level that doesn't exist
	if GlobalLevelState.check_is_last_level():
		return

	# Reset handicaps
	GlobalLevelState.level_modifier_handicaps = []
	var new_level_modifiers = []

	for modifier in GlobalLevelState.level_modifiers:
		modifier.end_trial()

		# Remove modifiers that are no longer in effect
		if not modifier.get_is_stopped():
			new_level_modifiers.append(modifier)

			# Start modifiers that should apply immediately 
			# on the modifier selection screen.
			modifier.goto_next_trial()
		else:
			pass
	
	GlobalLevelState.level_modifiers = new_level_modifiers
	
	var next_trial_cost_map = GlobalLevelState.level_modifiers.reduce(
		func(accum, modifier_manager):
			var current_trial_effects = modifier_manager.get_modifier().trial_effects
		
			if current_trial_effects.fixed_trial_cost > 0 and current_trial_effects.fixed_trial_cost < accum.fixed_trial_cost:
				accum.fixed_trial_cost = current_trial_effects.fixed_trial_cost
				accum.fixed_trial_cost_desc = current_trial_effects.fixed_trial_cost_desc

			var range_trial_cost_result = randi_range(1, current_trial_effects.range_trial_cost) if current_trial_effects.range_trial_cost else 0
			if range_trial_cost_result > accum.range_trial_cost:
				accum.range_trial_cost = range_trial_cost_result
				accum.range_trial_cost_desc = current_trial_effects.range_trial_cost_desc


			return accum
			, {
			fixed_trial_cost = 0,
			fixed_trial_cost_desc = "",
			range_trial_cost = 0,
			range_trial_cost_desc = "",

		})

	var next_level_index = GlobalLevelState.current_level_index + 1
	var next_level = GlobalLevelState.get_level(next_level_index)
	var next_level_fee = next_trial_cost_map.fixed_trial_cost if next_trial_cost_map.fixed_trial_cost > 0 else randi_range(1, 3)
	var next_level_fee_text = next_trial_cost_map.fixed_trial_cost_desc if next_trial_cost_map.fixed_trial_cost > 0 else "trial fee"
	
	GlobalLevelState.current_level_index = next_level_index
	GlobalLevelState.player_win_rate = next_level.player_win_rate

	var next_level_fee_notification = "-$" + str(next_level_fee) + " " + next_level_fee_text
	var next_level_extra_fee_notification = "-$" + str(next_trial_cost_map.range_trial_cost) + " " + next_trial_cost_map.range_trial_cost_desc if next_trial_cost_map.range_trial_cost > 0 else ""
	
	GlobalLevelState.set_money(GlobalLevelState.money - next_level_fee, next_level_fee_notification, true)
	
	if next_trial_cost_map.range_trial_cost > 0:
		GlobalLevelState.set_money(GlobalLevelState.money - next_trial_cost_map.range_trial_cost, next_level_extra_fee_notification, true)

	GlobalLevelState.game_mode_changed.emit(GlobalEnums.GameMode.MODIFIER_SELECTION)

	hide()


func _on_coin_flip_succeeded():
	# Prevent showing the button when player has reached the end
	if GlobalLevelState.check_is_last_level():
		return

	disabled = false
	show()
