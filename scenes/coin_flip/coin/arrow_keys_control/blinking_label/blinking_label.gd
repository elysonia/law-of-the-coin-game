extends RichTextLabel


var _label_text = ""

func initialize(label_text):
	_label_text = label_text
	text = label_text


func start():
	var formatted_label_text = "[pulse freq=3.0 color=transparent ease=-2.0]" + _label_text +"[/pulse]"
	text = formatted_label_text


func stop():
	text = _label_text