extends RichTextLabel


func initialize(modifier: Modifier):
	var type = GlobalEnums.ModifierType.find_key(modifier.type)
	var title = (
		"[font_size={20}][b]"
		+ type.capitalize()
		+ ": "
		+ "[color=orange]"
		+ modifier.display_name
		+ "[/color][/b][/font_size]\n"
	)

	var price = (
		"[font_size={15}][b]"
		+ str(modifier.price)
		+ " coins"
		+ "[/b][/font_size]\n\n"
	)

	var flavor_text = "[color=yellow][i]" + modifier.description[0] + "[/i][/color]\n\n"
	var buff_text = "[color=green]" + modifier.description[1] + "[/color]\n\n"
	var debuff_text = "[color=red]" + modifier.description[2] + "[/color]\n"
	visible = true

	append_text(title)
	append_text(price)
	append_text(flavor_text)
	append_text(buff_text)
	append_text(debuff_text)
