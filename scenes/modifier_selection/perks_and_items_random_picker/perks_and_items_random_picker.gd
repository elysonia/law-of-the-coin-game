extends ModifierRandomPicker

const MAX_NUMBER_OF_MODIFIER_CHOSEN = 2
const MAX_NUMBER_OF_MODIFIER_CHOICES = 3

@onready var _modifier_container = $Control/ModifierContainer
@onready var _modifier_button = preload("./modifier_button/modifier_button.tscn")

# TODO: Complete
# func _init():
# pass


func _ready():
	modifiers = GlobalLevelState.modifiers

	# TODO: Check if NO_PERKS or NO_ITEM are in effect.
	# TODO: Check if there are enough available modifiers to show as options.
	# TODO: If there are only 3 modifiers left, just show them all.
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
	var modifier_choices = []

	modifier_choices.append_array(get_perks(number_of_perk_choices))
	modifier_choices.append_array(get_items(number_of_item_choices))
	modifier_choices.shuffle()

	for index in range(0, modifier_choices.size()):
		var modifier_choice = modifier_choices[index]
		var button = _modifier_button.instantiate()

		button.initialize(modifier_choice)
		_modifier_container.add_child(button)
