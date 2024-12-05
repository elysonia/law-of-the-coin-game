extends VSlider

func _ready():
	if GlobalLevelState.volume == null:
		value = (abs(max_value) - abs(min_value)) / 2
	else:
		value = GlobalLevelState.volume


func _value_changed(new_value):
	GlobalLevelState.set_volume(new_value, min_value, max_value)
