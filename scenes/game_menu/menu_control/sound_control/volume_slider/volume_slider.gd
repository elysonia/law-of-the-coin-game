extends VSlider

func _ready():
	if GlobalLevelState.volume == null:
		value = (abs(max_value) - abs(min_value)) / 2
	else:
		value = GlobalLevelState.volume

