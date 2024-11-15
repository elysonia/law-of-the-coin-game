extends Node


var _modifier: Modifier


func _init(modifier: Modifier):
	_modifier = modifier


func remove_effects():
	# Remove either trial_effect/next_trial_effect/multitrial_effect
	pass


func start_effects():
	# Check if there are effects that can be started in the current trial.
	# Send out notifs.
	pass


func stop_effects():
	# Check if effects can be stopped because the trial ended or it was countered by another.
	# Remove effects once stopped for simplicity.
	# Send out notifs.
	pass
