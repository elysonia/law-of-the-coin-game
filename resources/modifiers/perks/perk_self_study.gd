extends ModifierManager

var _simple_blur_filter = preload("res://scenes/game/simple_blur_filter.tscn")
var _instantiated_simple_blur = null


func goto_next_trial():
	if is_instance_valid(_instantiated_simple_blur):
		_instantiated_simple_blur.queue_free()
		_instantiated_simple_blur = null


	if _modifier.trial_effects != null:
		_instantiated_simple_blur = _simple_blur_filter.instantiate()
		GlobalLevelState.level_modifier_handicaps.append(_modifier.trial_effects.handicap)
		_parent_node.add_child(
			_instantiated_simple_blur
		)

	if (
		_modifier.multi_trial_effects != null
		and _modifier.multi_trial_effects.handicap not in GlobalLevelState.level_modifier_handicaps
	):
		_instantiated_simple_blur = _simple_blur_filter.instantiate()
		GlobalLevelState.level_modifier_handicaps.append(_modifier.multi_trial_effects.handicap)
		_parent_node.add_child(
			_instantiated_simple_blur
		)


func start_multi_trial_effects():
	super.start_multi_trial_effects()

	if is_instance_valid(_instantiated_simple_blur):
		_instantiated_simple_blur.queue_free()
		_instantiated_simple_blur = null

	_instantiated_simple_blur = _simple_blur_filter.instantiate()
	_parent_node.add_child(
		_instantiated_simple_blur
	)


func stop_multi_trial_effects():
	super.stop_multi_trial_effects()

	if is_instance_valid(_instantiated_simple_blur):
		_instantiated_simple_blur.queue_free()

	_instantiated_simple_blur = null
