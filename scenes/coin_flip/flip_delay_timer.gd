extends Timer

signal timer_label_updated(time)

var previous_time_left_rounded: int = 0


func _ready():
	pass


func _process(_delta):
	var time_left_rounded = floori(time_left)

	# Prevent countdown label from showing float numbers
	if time_left_rounded == previous_time_left_rounded:
		return

	previous_time_left_rounded = time_left_rounded

	timer_label_updated.emit(time_left_rounded)


func _on_player_control_flip_delay_timer_started():
	start()
