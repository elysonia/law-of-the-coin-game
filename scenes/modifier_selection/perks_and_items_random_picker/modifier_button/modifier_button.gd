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
	var stylebox = get_theme_stylebox("panel", "TooltipPanel")
	var new_tooltip = tooltip_scene.instantiate()

	# Make transparent the default PopupPanel backdrop that still shows up
	# beneath the custom tooltip
	stylebox.set_bg_color(Color(0, 0, 0, 0))
	new_tooltip.initialize(modifier_obj)

	if GlobalEnums.ModifierHandicap.BLURRY_VISION in GlobalLevelState.level_modifier_handicaps:
		var simple_blur_filter = load("res://scenes/game/simple_blur_filter.tscn").instantiate()
		new_tooltip.add_child(simple_blur_filter)

	return new_tooltip


func on_temp_modifier_cost_updated(temp_modifier_cost, temp_modifier_count):
	if is_toggled:
		return

	if temp_modifier_count == 2:
		disabled = true
		_button_label.set_text("Max reached")
		_button_label.show()
		return 

	var temp_remaining_money = GlobalLevelState.money - temp_modifier_cost

	if modifier_obj.price > temp_remaining_money:
		disabled = true
		_button_label.set_text("Cannot afford")
		_button_label.show()
	else:
		disabled = false
		_button_label.set_text("Cannot afford")
		_button_label.hide()
