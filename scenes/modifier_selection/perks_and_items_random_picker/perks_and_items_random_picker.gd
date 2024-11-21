extends ModifierRandomPicker

signal temp_modifier_cost_updated(temp_modifier_cost)

const MAX_NUMBER_OF_MODIFIER_CHOSEN = 2
const MAX_NUMBER_OF_MODIFIER_CHOICES = 3

var temp_modifier_list = []

@onready var _start_trial_button = $StartTrialButton
@onready var _modifier_container = $Control/ModifierContainer
@onready var _modifier_button = preload("./modifier_button/modifier_button.tscn")


func _ready():
	modifiers = GlobalLevelState.modifiers
	_start_trial_button.pressed.connect(_on_start_trial_button_pressed)


	# TODO: Check if NO_PERKS or NO_ITEM are in effect.
	# TODO: Make sure the NO_PERKS and NO_ITEM modifiers are not options at the same time.
	var all_selectable_modifiers = []
	var modifier_choices = []

	all_selectable_modifiers.append_array(
		modifiers.perks.filter(func(perk): return perk.can_be_picked)
	)
	all_selectable_modifiers.append_array(
		modifiers.items.filter(func(item): return item.can_be_picked)
	)

	var is_show_all_selectable_modifiers = all_selectable_modifiers.size() <= 3

	if is_show_all_selectable_modifiers:
		modifier_choices.append_array(all_selectable_modifiers)
	else:
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

		modifier_choices.append_array(get_perks(number_of_perk_choices))
		modifier_choices.append_array(get_items(number_of_item_choices))

	modifier_choices.shuffle()

	for index in range(0, modifier_choices.size()):
		var modifier_choice = modifier_choices[index]
		var button = _modifier_button.instantiate()

		button.initialize(modifier_choice)

		# Disable button if player doesn't have enough money
		temp_modifier_cost_updated.connect(button.on_temp_modifier_cost_updated)

		button.toggled.connect(
			func(toggled_on):
				if not toggled_on:
					button.is_toggled = false
					temp_modifier_list = temp_modifier_list.filter(
						func(modifier): return modifier.name != modifier_choice.name
					)
					var temp_modifier_cost = temp_modifier_list.reduce(
						func(accum, modifier):
							accum += modifier.price
							return accum
					, 0)
					temp_modifier_cost_updated.emit(temp_modifier_cost) 

				else:
					button.is_toggled = true
					temp_modifier_list.append(modifier_choice)
					var temp_modifier_cost = temp_modifier_list.reduce(
						func(accum, modifier):
							accum += modifier.price
							return accum
					, 0)
					temp_modifier_cost_updated.emit(temp_modifier_cost) 
		)

		_modifier_container.add_child(button)


func _on_start_trial_button_pressed():
	var modifier_managers_list = []
	for modifier in temp_modifier_list:
		var manager_script = modifier.manager_script
		var modifier_manager = load(manager_script).new(modifier)
		
		modifier_managers_list.append(modifier_manager)
		modifier_manager.start_trial()
	
	GlobalLevelState.level_modifiers.append_array(modifier_managers_list)
	GlobalLevelState.game_mode_changed.emit(GlobalEnums.GameMode.COIN_FLIP)
	
