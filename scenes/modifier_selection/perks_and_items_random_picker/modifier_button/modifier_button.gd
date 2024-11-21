class_name ModifierButton
extends TextureButton

var modifier_obj: Modifier
var tooltip_scene = preload("./modifier_tooltips/modifier_tooltips.tscn")
var is_toggled = false

@onready var _button_label = $ButtonLabel


func _ready():
	_button_label.hide()


func initialize(modifier: Modifier):
	modifier_obj = modifier
	texture_normal = ImageTexture.create_from_image(Image.load_from_file(modifier.normal))
	texture_hover = ImageTexture.create_from_image(Image.load_from_file(modifier.active))
	texture_pressed = ImageTexture.create_from_image(Image.load_from_file(modifier.active))
	toggle_mode = true


func _make_custom_tooltip(_for_text):
	var new_tooltip = tooltip_scene.instantiate()
	new_tooltip.initialize(modifier_obj)
	return new_tooltip


func on_temp_modifier_cost_updated(temp_modifier_cost):
	if is_toggled:
		return

	var temp_remaining_money = GlobalLevelState.money - temp_modifier_cost

	if modifier_obj.price > temp_remaining_money:
		disabled = true
		_button_label.show()
	else:
		disabled = false
		_button_label.hide()
