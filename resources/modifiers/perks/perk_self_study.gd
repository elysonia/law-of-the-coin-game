extends ModifierManager

var _simple_blur_filter = preload("res://scenes/game/simple_blur_filter.tscn")
var _instantiated_simple_blur = null


func goto_next_trial():
	_instantiated_simple_blur = _simple_blur_filter.instantiate()

	if _modifier.trial_effects != null:
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
		_parent_node.add_child(
			_instantiated_simple_blur
		)

	if (
		_modifier.multi_trial_effects != null
		and _modifier.multi_trial_effects.handicap not in GlobalLevelState.level_modifier_handicaps
	):
		GlobalLevelState.level_modifier_handicaps.append(_modifier.multi_trial_effects.handicap)
		_parent_node.add_child(
			_instantiated_simple_blur
		)


func start_trial():
	super.start_trial()
	_instantiated_simple_blur = _simple_blur_filter.instantiate()
	_parent_node.add_child(
		_instantiated_simple_blur
	)


func stop_current_trial_effects():
	super.stop_current_trial_effects()

	if is_instance_valid(_instantiated_simple_blur):
		_instantiated_simple_blur.queue_free()

	_instantiated_simple_blur = null
