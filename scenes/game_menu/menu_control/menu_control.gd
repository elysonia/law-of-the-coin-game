extends Control

@onready var _buttons_container = $ButtonsMarginContainer/ButtonsContainer
@onready
var _home_button_scene = preload("res://scenes/game_menu/menu_control/home_button/home_button.tscn")
@onready var _sound_control_button_scene = preload(
	"res://scenes/game_menu/menu_control/sound_control/sound_control_button.tscn"
)


func _ready():
	GlobalLevelState.game_mode_changed.connect(_on_game_mode_changed)
	_on_game_mode_changed(GlobalLevelState.game_mode)


func _on_game_mode_changed(game_mode):
	for child in _buttons_container.get_children():
		child.queue_free()

	var sound_control_button_instance = _sound_control_button_scene.instantiate()
	var home_button_instance = _home_button_scene.instantiate()

	if game_mode != GlobalEnums.GameMode.TITLE:
		_buttons_container.add_child(home_button_instance)

	_buttons_container.add_child(sound_control_button_instance)
