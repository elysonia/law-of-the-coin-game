extends Button

@onready var _updates_label = preload(
	"res://scenes/notifications/updates_label/updates_label.tscn"
)


func _ready():
	GlobalCoinEvents.coin_flip_succeeded.connect(_on_coin_flip_succeeded)
	hide()


func _pressed():
	# Prevent attempting to start a level that doesn't exist
	if GlobalLevelState.check_is_last_level():
		return

	var next_level_index = GlobalLevelState.current_level_index + 1
	var next_level = GlobalLevelState.get_level(next_level_index)
	var next_level_fee = randi_range(1, 3)

	GlobalLevelState.current_level_index = next_level_index
	GlobalLevelState.player_win_rate = next_level.player_win_rate
	GlobalLevelState.set_money(GlobalLevelState.money - next_level_fee)

	var updates_label_text = "-$" + str(next_level_fee) + " trial fee"
	var updates_label = _updates_label.instantiate()
	updates_label.text = updates_label_text
	get_tree().root.add_child(updates_label)
	await updates_label.fade_tween().finished

	GlobalLevelState.goto_game_scene()


func _on_coin_flip_succeeded():
	# Prevent showing the button when player has reached the end
	if GlobalLevelState.check_is_last_level():
		return

	show()
