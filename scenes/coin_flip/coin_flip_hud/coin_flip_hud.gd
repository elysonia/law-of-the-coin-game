extends Control

@onready var _timer_label = $TimerLabel
@onready var _timer_title_label = $TimerTitleLabel


func _ready():
	_hide_timer_texts()


func _process(_delta):
	pass


func _show_timer_texts():
	_timer_label.show()
	_timer_title_label.show()


func _hide_timer_texts():
	_timer_label.hide()
	_timer_title_label.hide()


func _on_flip_delay_timer_timer_label_updated(time: Variant):
	_timer_label.text = str(time)

	if _timer_label.hidden:
		_show_timer_texts()


func _on_flip_delay_timer_timeout():
	_hide_timer_texts()
