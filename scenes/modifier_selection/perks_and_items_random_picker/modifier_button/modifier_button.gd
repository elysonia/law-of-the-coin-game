class_name ModifierButton
extends TextureButton

var modifier_obj: Modifier
var tooltip_scene = preload("./modifier_tooltips/modifier_tooltips.tscn")
var is_toggled = false
var _is_item_glasses_modifier = false
var _is_blurry_vision_active = false

@onready var _button_label = $ButtonLabel


func _ready():
	_button_label.hide()

	_is_blurry_vision_active = (
		GlobalEnums.ModifierHandicap.BLURRY_VISION in GlobalLevelState.level_modifier_handicaps
	)

	if _is_blurry_vision_active:
		_is_item_glasses_modifier = (
			modifier_obj.name == load("res://resources/modifiers/items/item_glasses.tres").name
		)

	# Allow player to see the glasses.
	if _is_item_glasses_modifier:
		z_index = 5


func initialize(modifier: Modifier):
	modifier_obj = modifier
	texture_normal = modifier.normal_image
	texture_hover = modifier.active_image
	texture_pressed = modifier.active_image

	toggle_mode = true


func _make_custom_tooltip(_for_text):
	var stylebox = get_theme_stylebox("panel", "TooltipPanel")
	var new_tooltip = tooltip_scene.instantiate()

	# Make transparent the default PopupPanel backdrop that still shows up
	# beneath the custom tooltip
	stylebox.set_bg_color(Color(0, 0, 0, 0))
	new_tooltip.initialize(modifier_obj)

	if _is_blurry_vision_active:
		# Allow player to see the glasses.
		if _is_item_glasses_modifier:
			pass
		else:
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
