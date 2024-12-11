extends Node2D

@onready var _trophy_icon = $Panel/TrophyIcon
@onready var _description = $Panel/Description


func initialize(achievement) -> void:
	var icon_texture = load(achievement.icon_path)

	_trophy_icon.texture = icon_texture

	var name_format_text = "[font_size={{15}}][b]{text}[/b][/font_size]\n"
	var desc_format_text = "[font_size={{12}}][color={color}]{text}[/color][/font_size]\n"
	var flavor_text_format_text = "[font_size={{12}}][color={color}][i]{text}[/i][/color][/font_size]\n"
	
	var name_text = name_format_text.format({
		text = achievement.name
	})

	var description = desc_format_text.format({
		color = "white",
		text = achievement.description.format({
			current_progress = achievement.current_progress,
			count_goal = achievement.count_goal,
		})
	})


	var flavor_text_during_unlock = flavor_text_format_text.format({
		color = "green",
		text = achievement.flavor_texts.during_unlock
	})
	_description.append_text(name_text)
	_description.append_text(description)
	_description.append_text(flavor_text_during_unlock)
