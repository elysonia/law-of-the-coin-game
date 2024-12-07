class_name ModifierRandomPicker
extends Node

@export var modifiers = {}


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


func get_random_modifiers(number_of_modifiers_required, available_modifier_list = []):
	var modifier_list = []
	var random_integers = generate_unique_random_integers_list(
		number_of_modifiers_required, 0, available_modifier_list.size() - 1
	)

	for integer in random_integers:
		var modifier = available_modifier_list[integer]
		modifier_list.append(modifier)

	return modifier_list


func check_modifier_effects_has_handicap(
		modifier,
		handicap: GlobalEnums.ModifierHandicap,
		effects_name: String,
	):
	var effects = modifier[effects_name]

	if effects == null:
		return false

	return effects.handicap == handicap


func check_modifier_can_be_picked(
		modifier,
		is_no_perks_handicap_modifier_allowed,
		is_no_items_handicap_modifier_allowed,
	):
	var is_next_trial_effects_handicap_no_perks = check_modifier_effects_has_handicap(
			modifier,
			GlobalEnums.ModifierHandicap.NO_PERKS,
			"next_trial_effects"
		)

	var is_next_trial_effects_handicap_no_items = check_modifier_effects_has_handicap(
			modifier,
			GlobalEnums.ModifierHandicap.NO_ITEMS,
			"next_trial_effects",
		)

	if is_next_trial_effects_handicap_no_perks or is_next_trial_effects_handicap_no_items:
		var should_include_modifier_with_no_perks_handicap = (
				is_no_perks_handicap_modifier_allowed
				and is_next_trial_effects_handicap_no_perks
			)
		var should_include_modifier_with_no_items_handicap = (
				is_no_items_handicap_modifier_allowed
				and is_next_trial_effects_handicap_no_items
			)

		return (
			modifier.can_be_picked
			and should_include_modifier_with_no_perks_handicap
			and should_include_modifier_with_no_items_handicap
		)

	return modifier.can_be_picked


func get_perks(
		number_of_perks_required,
		is_no_perks_handicap_modifier_allowed,
		is_no_items_handicap_modifier_allowed
	):
	if number_of_perks_required == 0:
		return []

	var available_perks = modifiers.perks.filter(
		func(modifier):
			return check_modifier_can_be_picked(
					modifier,
					is_no_perks_handicap_modifier_allowed,
					is_no_items_handicap_modifier_allowed,
				)
	)

	if number_of_perks_required >= available_perks.size():
		return available_perks

	return get_random_modifiers(number_of_perks_required, available_perks)


func get_items(
		number_of_items_required,
		is_no_perks_handicap_modifier_allowed,
		is_no_items_handicap_modifier_allowed
	):
	if number_of_items_required == 0:
		return []

	var available_items = modifiers.items.filter(
			func(modifier):
				return check_modifier_can_be_picked(
						modifier,
						is_no_perks_handicap_modifier_allowed,
						is_no_items_handicap_modifier_allowed,
					)
	)

	if number_of_items_required >= available_items.size():
		return available_items

	return get_random_modifiers(number_of_items_required, available_items)
