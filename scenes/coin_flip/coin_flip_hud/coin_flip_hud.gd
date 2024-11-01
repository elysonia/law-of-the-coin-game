extends Control


@onready var _timer_label = $TimerLabel


func _ready():
	_timer_label.hide()

func _process(_delta):
	pass


func _on_flip_delay_timer_timer_label_updated(time:Variant):
	_timer_label.text = str(time)

	if _timer_label.hidden:
		_timer_label.show()


func _on_flip_delay_timer_timeout():
	_timer_label.hide()
