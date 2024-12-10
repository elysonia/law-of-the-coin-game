extends Control


@onready var _close_button = $CloseButton


func _ready():
	_close_button.pressed.connect(_on_close_button_pressed)


func _on_close_button_pressed():
	GlobalLevelState.toggle_options_menu()
