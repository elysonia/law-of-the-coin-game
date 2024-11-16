class_name ModifierButton
extends TextureButton

var modifier_obj: Modifier
var tooltip_scene = preload(
	"./modifier_tooltips/modifier_tooltips.tscn"
)

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
