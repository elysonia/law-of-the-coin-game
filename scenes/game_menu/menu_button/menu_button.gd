extends MenuButton

enum { BACK_TO_TITLE = 0, RESTART = 1 }


func _ready():
	get_popup().add_item("Back to title", BACK_TO_TITLE)  #._pressed.connect(_on_back_to_title_pressed)
	get_popup().add_item("Restart", RESTART)
	get_popup().id_pressed.connect(_on_popup_item_pressed)


func _on_popup_item_pressed(id):
	match id:
		BACK_TO_TITLE:
			GlobalLevelState.goto_main_scene()
		RESTART:
			var current_level = GlobalLevelState.get_level(0)

			GlobalLevelState.current_level_index = 0
			GlobalLevelState.player_win_rate = current_level.player_win_rate
			GlobalLevelState.set_money(0)

			get_tree().reload_current_scene()
