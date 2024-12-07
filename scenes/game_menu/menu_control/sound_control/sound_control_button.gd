extends TextureButton


@onready var _volume_slider_container = $VolumeSliderContainer


func _ready():
	_volume_slider_container.hide()


func _input(event):
	if not is_instance_of(event, InputEventMouseButton):
		return

	var mouse_position = event.get_position()
	var volume_slider_boundary = Rect2(
		_volume_slider_container.global_position, _volume_slider_container.size
	)
	var sound_button_boundary = Rect2(global_position, size)

	var is_clicked_outside_volume_control = (
		not volume_slider_boundary.has_point(mouse_position)
		and not sound_button_boundary.has_point(mouse_position)
	)

	if is_clicked_outside_volume_control:
		_volume_slider_container.hide()


func _pressed():
	if _volume_slider_container.visible:
		_volume_slider_container.hide()
		return

	_volume_slider_container.show()
