extends ModifierManager


func goto_next_trial():
	if _modifier.trial_effects != null:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)


func start_current_trial_effects():
	super.start_current_trial_effects()
	
	if _modifier.trial_effects != null:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)

	var simple_blur_filters = _parent_node.get_children().filter(
		func(node): return node.name == "SimpleBlurFilter"
	)

	if simple_blur_filters.size() > 0:
		for filter in simple_blur_filters:
			filter.queue_free()
