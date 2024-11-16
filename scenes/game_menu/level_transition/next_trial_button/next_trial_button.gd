extends Button

@onready var _updates_label = preload("res://scenes/notifications/updates_label/updates_label.tscn")


func _ready():
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	disabled = true
	hide()


func _pressed():
	# Reset handicaps
	GlobalLevelState.level_modifier_handicaps = []

	for modifier in GlobalLevelState.level_modifiers:
		modifier.add_to_group(GlobalEnums.GROUP.MODIFIER_MANAGERS)

	# Stop current modifiers.
	get_tree().call_group(GlobalEnums.GROUP.MODIFIER_MANAGERS, "end_trial")

	var new_level_modifiers = []
	
	# Remove modifiers that are no longer in effect
	for modifier in GlobalLevelState.level_modifiers:
		if not modifier.get_is_stopped():
			new_level_modifiers.append(modifier)

	GlobalLevelState.level_modifiers = new_level_modifiers

	# Prevent attempting to start a level that doesn't exist
	if GlobalLevelState.check_is_last_level():
		return
	
	# Start modifiers that should apply not and on the modifier selection screen.
	get_tree().call_group(GlobalEnums.GROUP.MODIFIER_MANAGERS, "start_trial")

	var next_trial_cost_map = GlobalLevelState.level_modifiers.reduce(
		func(accum, modifier):
			if modifier.fixed_trial_cost > 0 and modifier.fixed_trial_cost < accum.fixed_trial_cost:
				accum.fixed_trial_cost = modifier.fixed_trial_cost
				accum.fixed_trial_cost_desc = modifier.fixed_trial_cost_desc

			var range_trial_cost_result = randi_range(1, modifier.range_trial_cost) if modifier.range_trial_cost else 0
			if range_trial_cost_result > accum.range_trial_cost:
				accum.range_trial_cost = range_trial_cost_result
				accum.range_trial_cost_desc = modifier.range_trial_cost_desc


			return accum
			, {
			fixed_trial_cost = 0,
			fixed_trial_cost_desc = "",
			range_trial_cost = 0,
			range_trial_cost_desc = "",

		})

	# TODO: Compare level handicaps and appear_condition in GlobalLevelState.modifiers
	#	 then modify can_be_picked if the conditions are met.

	var next_level_index = GlobalLevelState.current_level_index + 1
	var next_level = GlobalLevelState.get_level(next_level_index)
	var next_level_fee = next_trial_cost_map.fixed_trial_cost if next_trial_cost_map.fixed_trial_cost > 0 else randi_range(1, 3)
	var next_level_fee_text = next_trial_cost_map.fixed_trial_cost_desc if next_trial_cost_map.fixed_trial_cost > 0 else "trial fee"
	
	GlobalLevelState.current_level_index = next_level_index
	GlobalLevelState.player_win_rate = next_level.player_win_rate

	var next_level_fee_notification = "-$" + str(next_level_fee) + " " + next_level_fee_text
	var next_level_extra_fee_notification = "-$" + str(next_trial_cost_map.range_trial_cost) + " " + next_trial_cost_map.range_trial_cost_desc if next_trial_cost_map.range_trial_cost > 0 else ""
	
	GlobalLevelState.set_money(GlobalLevelState.money - next_level_fee, next_level_fee_notification)
	
	if next_trial_cost_map.range_trial_cost > 0:
		GlobalLevelState.set_money(GlobalLevelState.money - next_trial_cost_map.range_trial_cost, next_level_extra_fee_notification)

	var notification_texts = [next_level_fee_notification, next_level_extra_fee_notification]

	for notification_text in notification_texts:
		var updates_label = _updates_label.instantiate()
		updates_label.text = notification_text
		get_tree().root.add_child(updates_label)
		await updates_label.fade_tween().finished

	GlobalLevelState.goto_game_scene()


func _on_coin_flip_succeeded():
	# Prevent showing the button when player has reached the end
	if GlobalLevelState.check_is_last_level():
		return

	disabled = false
	show()
