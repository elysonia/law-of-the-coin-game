class_name RandomPicker
extends Node
# Reference: https://www.youtube.com/watch?v=IAhBZLlz5wY&ab_channel=JohnIvess

@export var item_list: Array[RandomItem] = []


func pick_random_item(items = null):
	var picked_item = null
	var overall_pick_chance = 0.0

	var valid_item_list = items if items else item_list

	# Calculate the overall pick chance
	for item in valid_item_list:
		if item.can_be_picked:
			overall_pick_chance += item.pick_chance

	# Generate random number between 0 and 1
	var random_number = fmod(randf(), overall_pick_chance)

	var offset = 0.0
	for item in valid_item_list:
		if item.can_be_picked:
			if random_number < item.pick_chance + offset:
				picked_item = item.name
				break
			else:
				offset += item.pick_chance

	return picked_item
