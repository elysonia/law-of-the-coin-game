extends Control

@onready var _credits_button = $CreditsButton
@onready var _credits_container = preload(
		"res://scenes/title_screen/credits_container/credits_container.tscn"
	)
@onready var _options_button = $OptionsButton


func _ready():
	_credits_button.pressed.connect(_on_credits_button_pressed)
	_options_button.pressed.connect(_on_options_button_pressed)


func _on_credits_button_pressed():
	var credits_scene = _credits_container.instantiate()
	get_tree().root.add_child(credits_scene)


func _on_options_button_pressed():
	GlobalLevelState.toggle_options_menu()
