class_name FlipDelayTimer
extends Timer

var previous_time_left_rounded: int = 0

# TODO: Check why the labels can't be referenced inside FlipDelayTimer
# unless they are direct children of FlipDelayTimer
@onready var _timer_label = $TimerLabel
@onready var _timer_title_label = $TimerTitleLabel


func _ready():
	# GlobalCoinEvents.coin_player_picked.connect(_on_coin_events_coin_player_picked)
	# timeout.connect(_on_flip_delay_timer_timeout)
	wait_time = 5
	one_shot = true
	start()


func _process(_delta):
	if not time_left:
		return

	# Uses floori instead of randomf to avoid NARROWING_CONVERSION,
	# 	a linter warning where float is converted into int, losing precision.
	#	1 is added to accurately display the countdown number.
	# TODO: Find a better way if any
	var time_left_rounded = floori(time_left) + 1

	# Prevent countdown label from showing float numbers
	if time_left_rounded == previous_time_left_rounded:
		return

	previous_time_left_rounded = time_left_rounded

	_update_timer_texts(time_left_rounded)


# func _on_flip_delay_timer_timeout():
# 	_hide_timer_texts()
# 	GlobalCoinEvents.coin_delay_countdown_finished.emit()


func _update_timer_texts(time):
	_timer_label.text = str(time)

	if _timer_label.hidden:
		_show_timer_texts()


func _show_timer_texts():
	_timer_label.show()
	_timer_title_label.show()


func _hide_timer_texts():
	_timer_label.hide()
	_timer_title_label.hide()

# func _on_coin_events_coin_player_picked(_player_coin_name):
# 	start()
# 	_show_timer_texts()
