extends Label


## Text scales up in size and fades
func fade_tween():
	var tween = create_tween()

	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.5)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5)

	return tween
