extends MenuButton

enum { BACK_TO_TITLE = 0, RESTART = 1 }


func _ready():
	get_popup().add_item("Back to title", BACK_TO_TITLE)  #._pressed.connect(_on_back_to_title_pressed)
	get_popup().id_pressed.connect(_on_popup_item_pressed)


func _on_popup_item_pressed(id):
	match id:
		BACK_TO_TITLE:
			GlobalLevelState.goto_main_scene()
