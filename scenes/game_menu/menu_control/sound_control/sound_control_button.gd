extends TextureButton

var _volume_slider_container_instance = null

@onready var _volume_slider_container = preload(
	"res://scenes/game_menu/menu_control/sound_control/volume_slider_container.tscn"
)


func _input(event):
	if not is_instance_valid(_volume_slider_container_instance):
		return

	if not is_instance_of(event, InputEventMouseButton):
		return

	var mouse_position = event.get_position()
	var volume_slider_boundary = Rect2(
		Vector2(_volume_slider_container_instance.position), _volume_slider_container_instance.size
	)
	var sound_button_boundary = Rect2(position, size)

	var is_clicked_outside_volume_control = (
		not volume_slider_boundary.has_point(mouse_position)
		and not sound_button_boundary.has_point(mouse_position)
	)
	print({"is_clicked_outside_volume_control": is_clicked_outside_volume_control})
	if is_clicked_outside_volume_control:
		_volume_slider_container_instance.queue_free()
		_volume_slider_container_instance = null


func _pressed():
	if is_instance_valid(_volume_slider_container_instance):
		_volume_slider_container_instance.queue_free()
		_volume_slider_container_instance = null
		return

	_volume_slider_container_instance = _volume_slider_container.instantiate()
	add_child(_volume_slider_container_instance)
