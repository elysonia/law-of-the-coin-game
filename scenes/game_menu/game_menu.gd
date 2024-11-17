extends Control

@onready var _level_label = $LevelLabel
@onready var _money_label = $MoneyLabel


func _ready():
	var level_number = GlobalLevelState.current_level_index + 1
	_level_label.text = "Trial " + str(level_number)
	_money_label.text = "Money: $" + str(GlobalLevelState.money)

	GlobalLevelState.show_all_notifications()
