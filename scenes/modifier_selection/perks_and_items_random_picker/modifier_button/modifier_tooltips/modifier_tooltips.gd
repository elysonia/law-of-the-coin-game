extends RichTextLabel


func initialize(modifier: Modifier):
	visible = true
	var formatted_tooltip_text = ModifierManager.get_formatted_tooltip_text(modifier)
	parse_bbcode(formatted_tooltip_text)
