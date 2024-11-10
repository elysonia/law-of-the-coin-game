extends Label


func _ready():
	GlobalLevelState.money_updated.connect(_on_money_updated)
	text = "Money: $" + str(GlobalLevelState.money)


func _on_money_updated():
	text = "Money: $" + str(GlobalLevelState.money)
