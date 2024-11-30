extends ModifierRandomPicker

signal temp_modifier_cost_updated(temp_modifier_cost, temp_modifier_count)

const MAX_NUMBER_OF_MODIFIER_CHOSEN = 2
const MAX_NUMBER_OF_MODIFIER_CHOICES = 3

var temp_modifier_list = []

@onready var _total_cost_label = $TotalCostLabel
@onready var _start_trial_button = $StartTrialButton
@onready var _modifier_container = $Control/ModifierContainer
@onready var _modifier_button = preload("./modifier_button/modifier_button.tscn")


func _ready():
	modifiers = GlobalLevelState.modifiers
	_start_trial_button.pressed.connect(_on_start_trial_button_pressed)

	var all_selectable_modifiers = []
	var modifier_choices = []

	var can_pick_perks = GlobalEnums.ModifierHandicap.NO_PERKS not in GlobalLevelState.level_modifier_handicaps
	var can_pick_items = GlobalEnums.ModifierHandicap.NO_ITEMS not in GlobalLevelState.level_modifier_handicaps

	if can_pick_perks:
		all_selectable_modifiers.append_array(
			modifiers.perks.filter(func(perk): return perk.can_be_picked)
		)
	
	if can_pick_items:
		all_selectable_modifiers.append_array(
			modifiers.items.filter(func(item): return item.can_be_picked)
		)


	var is_show_all_selectable_modifiers = all_selectable_modifiers.size() <= 3

	if is_show_all_selectable_modifiers:
		modifier_choices.append_array(all_selectable_modifiers)
	else:
		var new_modifier_choices = get_modifier_choices()
		modifier_choices.append_array(new_modifier_choices)

	modifier_choices.shuffle()

	for index in range(0, modifier_choices.size()):
		var modifier_choice = modifier_choices[index]
		var button = _modifier_button.instantiate()

		button.initialize(modifier_choice)
		_modifier_container.add_child(button)

		# Disable button if player doesn't have enough money
		temp_modifier_cost_updated.connect(button.on_temp_modifier_cost_updated)

		# In case the remaining money isn't enough at the start.
		button.on_temp_modifier_cost_updated(0, temp_modifier_list.size())

		button.toggled.connect(
			func(toggled_on):
				if not toggled_on:
					button.is_toggled = false
					var new_temp_modifier_list = temp_modifier_list.filter(
						func(temp_modifier):
							return temp_modifier.name != modifier_choice.name
					)

					temp_modifier_list = new_temp_modifier_list

					var temp_modifier_cost = temp_modifier_list.reduce(
						func(accum, modifier):
							accum += modifier.price
							return accum
					, 0)

					_update_total_cost(temp_modifier_cost)
					temp_modifier_cost_updated.emit(temp_modifier_cost, temp_modifier_list.size()) 

				else:
					button.is_toggled = true
					temp_modifier_list.append(modifier_choice)
					var temp_modifier_cost = temp_modifier_list.reduce(
						func(accum, modifier):
							accum += modifier.price
							return accum
					, 0)

					_update_total_cost(temp_modifier_cost)
					temp_modifier_cost_updated.emit(temp_modifier_cost, temp_modifier_list.size()) 
		)


func get_modifier_choices():
	var temp_modifier_choices = []
	var number_of_choices = randi_range(2, 3)
	var number_of_perk_choices = (
		(func():
			if number_of_choices < 3:
				return 1

			if randf_range(0, 1) > 0.5:
				return 2

			return 1)
		. call()
	)
	var number_of_item_choices = number_of_choices - number_of_perk_choices

	temp_modifier_choices.append_array(get_perks(number_of_perk_choices))
	temp_modifier_choices.append_array(get_items(number_of_item_choices))

	var next_trial_handicaps = temp_modifier_choices.reduce(
		func(accum, modifier):
			if modifier.next_trial_effects != null:
				accum.append(modifier.next_trial_effects.handicap)
			return accum
	, [])

	# To make sure the NO_PERKS and NO_ITEM modifiers are not options at the same time.
	if GlobalEnums.ModifierHandicap.NO_ITEMS in next_trial_handicaps and GlobalEnums.ModifierHandicap.NO_PERKS in next_trial_handicaps:
		return get_modifier_choices()
		
	return temp_modifier_choices


func _update_total_cost(total_price):
	var text = "Total: $" + str(total_price)
	_total_cost_label.set_text(text)


func _on_start_trial_button_pressed():
	var sfx =  _start_trial_button.get_node("DoorOpenSFXPlayer")
	sfx.play()

	var modifier_managers_list = []

	for modifier in temp_modifier_list:
		var manager_script = modifier.manager_script
		var modifier_manager = load(manager_script).new(modifier, get_tree().root.get_children()[3])
		
		modifier_managers_list.append(modifier_manager)
	
	GlobalLevelState.level_modifiers.append_array(modifier_managers_list)
	
	var sorted_level_modifiers = GlobalLevelState.level_modifiers.duplicate()
	
	sorted_level_modifiers.sort_custom(
		func(before, after):
			var modifier_before = before.get_modifier()
			var modifier_after = after.get_modifier()

			if modifier_before.order < modifier_after.order:
				return true
			return false
	)

	for modifier_manager in sorted_level_modifiers:
		modifier_manager.start_trial()
	
	await sfx.finished
	GlobalLevelState.game_mode_changed.emit(GlobalEnums.GameMode.COIN_FLIP)
