extends ModifierRandomPicker

const MAX_NUMBER_OF_MODIFIER_CHOSEN = 2
const MAX_NUMBER_OF_MODIFIER_CHOICES = 3

var temp_modifier_list = []

@onready var _start_trial_button = $StartTrialButton
@onready var _modifier_container = $Control/ModifierContainer
@onready var _modifier_button = preload("./modifier_button/modifier_button.tscn")

# TODO: Complete
# func _init():
# pass


func _ready():
	modifiers = GlobalLevelState.modifiers
	_start_trial_button.pressed.connect(_on_start_trial_button_pressed)

	# TODO: Check if NO_PERKS or NO_ITEM are in effect.
	# TODO: Make sure the NO_PERKS and NO_ITEM modifiers are not options at the same time.
	# TODO: Check if there are enough available modifiers to show as options.
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
		modifier_choices.append_array(is_show_all_selectable_modifiers)
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

		# TODO: Disable button if player doesn't have enough money
		button.toggled.connect(
			func(toggled_on):
				if not toggled_on:
					temp_modifier_list = temp_modifier_list.filter(
						func(modifier): return modifier.name == modifier_choice.name
					)
				else:
					temp_modifier_list.append(modifier_choice)
		)

		_modifier_container.add_child(button)


func _on_start_trial_button_pressed():
	var modifier_managers_list = []
	for modifier in temp_modifier_list:
		var modifier_manager = load(modifier.manager_script).new(modifier)

		# Adding to a group to allow calling a method without iterating.
		modifier_manager.add_to_group(GlobalEnums.GROUP.MODIFIER_MANAGERS)

		# Adding to a list to store in state for persistence throughout the levels
		# without needing to save the current state on the PackedScene.
		modifier_managers_list.append(modifier_manager)

	GlobalLevelState.level_modifiers.append(modifier_managers_list)
	get_tree().call_group(GlobalEnums.GROUP.MODIFIER_MANAGERS, "start_trial")
