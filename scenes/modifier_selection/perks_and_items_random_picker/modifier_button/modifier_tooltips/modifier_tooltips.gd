extends RichTextLabel


func initialize(modifier: Modifier):
	var title = (
		"[font_size={20}][b]"
		+ modifier.type.capitalize()
		+ ": "
		+ "[color=orange]"
		+ modifier.display_name
		+ "[/color][/b][/font_size]\n\n"
	)
	var flavor_text = "[color=yellow][i]" + modifier.description[0] + "[/i][/color]\n\n"
	var buff_text = "[color=green]" + modifier.description[1] + "[/color]\n\n"
	var debuff_text = "[color=red]" + modifier.description[2] + "[/color]\n"
	visible = true
	append_text(title)
	append_text(flavor_text)
	append_text(buff_text)
	append_text(debuff_text)
