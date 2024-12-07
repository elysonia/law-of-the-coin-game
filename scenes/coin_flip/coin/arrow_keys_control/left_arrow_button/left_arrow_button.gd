extends Button

const LEFT_ARROW_TEXT = "<- Left"

@onready var _blinking_label_scene = $BlinkingLabel


func _ready():
	_blinking_label_scene.initialize(LEFT_ARROW_TEXT)
	start_blinking_text()

func start_blinking_text():
	_blinking_label_scene.start()


func stop_blinking_text():
	_blinking_label_scene.stop()
