class_name UpdatesLabel
extends Label


func fade_tween():
	var tween = create_tween()

	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "position", Vector2(664, 100), 1)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)

	return tween
