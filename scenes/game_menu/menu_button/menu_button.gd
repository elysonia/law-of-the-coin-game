extends MenuButton

enum { BACK_TO_TITLE = 0, SOUND_VOLUME = 1 }

@onready
var _volume_slider = preload("res://scenes/game_menu/menu_button/volume_slider/volume_slider.tscn")


func _ready():
	# if GlobalLevelState.game_mode != GlobalEnums.GameMode.TITLE:
	get_popup().add_item("Back to title", BACK_TO_TITLE)

	get_popup().add_item("Sound volume", SOUND_VOLUME)
	get_popup().id_pressed.connect(_on_popup_item_pressed)
	print({"hide_on_item_selection": get_popup().hide_on_item_selection})
	get_popup().hide_on_item_selection = false


func _on_popup_item_pressed(id):
	match id:
		BACK_TO_TITLE:
			for modifier in GlobalLevelState.level_modifiers:
				modifier.end_trial()

			GlobalLevelState.reset_game()
			GlobalLevelState.goto_main_scene()
		SOUND_VOLUME:
			# var new_popup_panel = PopupPanel.new()

			# var popup_panel = PopupPanel.new()
			# popup_panel.add_child(_volume_slider.instantiate())

			# get_tree().root.add_child(popup_panel)
			# get_popup().add_sibling(_volume_slider.instantiate())
			get_popup().add_submenu_item("test", "test2", 1)
