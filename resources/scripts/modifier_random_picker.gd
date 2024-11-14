class_name ModifierRandomPicker
extends Node

@export var modifiers: Modifiers


func generate_unique_random_integers_list(
	required_amount, range_lower_boundary, range_upper_boundary
):
	var unique_random_integers_list = []

	var is_range_too_narrow = required_amount > range_upper_boundary - range_lower_boundary
	if is_range_too_narrow:
		push_error(
			"The range provided is not enough to generate the required number of unique integers"
		)
		return

	while unique_random_integers_list.size() < required_amount:
		var random_integer = randi_range(range_lower_boundary, range_upper_boundary)

		if unique_random_integers_list.has(random_integer):
			continue

		unique_random_integers_list.append(random_integer)

	return unique_random_integers_list


func get_random_modifiers(
	number_of_modifiers_required, available_modifier_list: Array[Modifier] = []
):
	var modifier_list = []
	var random_integers = generate_unique_random_integers_list(
		number_of_modifiers_required, 0, available_modifier_list.size() - 1
	)

	for integer in random_integers:
		var modifier = available_modifier_list[integer]
		modifier_list.append(modifier)

	return modifier_list


func get_perks(number_of_perks_required):
	var available_perks = modifiers.perks.filter(func(perk): return perk.can_be_picked)

	return get_random_modifiers(number_of_perks_required, available_perks)


func get_items(number_of_items_required):
	var available_items = modifiers.items.filter(func(item): return item.can_be_picked)

	return get_random_modifiers(number_of_items_required, available_items)
