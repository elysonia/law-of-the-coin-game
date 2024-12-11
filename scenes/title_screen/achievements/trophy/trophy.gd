extends TextureRect

@export var locked_icon: Texture2D
@export var unlocked_icon: Texture2D
@export var achievement_key: String

var achievement

@onready var _trophy_name = $TrophyName
@onready var _trophy_description = $TrophyDescription


func _ready():
	achievement = GodotParadiseAchievements.get_achievement(achievement_key)

	if achievement.unlocked:
		set("texture",unlocked_icon)
	else:
		set("texture",locked_icon)

	_get_trophy_name()
	_get_trophy_description()


func _get_trophy_name():
	var format_text = "[center][font_size={{12}}][b]{text}[/b][/font_size][center]"
	
	var name_text = format_text.format({
		text = achievement.name
	})

	if achievement.unlocked:
		_trophy_name.append_text(name_text)
	else:
		_trophy_name.append_text(format_text.format({
		text = "???"
	}))


func _get_trophy_description():
	var format_text = "[center][font_size={{10}}][color={color}]{text}[/color][/font_size][/center]\n"
	var flavor_text_format_text = "[center][font_size={{10}}][color={color}][i]{text}[/i][/color][/font_size][/center]\n"

	var description = format_text.format({
		color = "white",
		text = achievement.description.format({
			current_progress = achievement.current_progress,
			count_goal = achievement.count_goal,
		})
	})

	var flavor_text_before_unlock = flavor_text_format_text.format({
		color = "yellow",
		text = achievement.flavor_texts.before_unlock
	})


	_trophy_description.append_text(description)

	_trophy_description.append_text(flavor_text_before_unlock)

	if achievement.unlocked:
		var flavor_text_during_unlock = flavor_text_format_text.format({
			color = "green",
			text = achievement.flavor_texts.during_unlock
		})

		var flavor_text_after_unlock = flavor_text_format_text.format({
			color = "dim_gray",
			text = achievement.flavor_texts.after_unlock
		})

		_trophy_description.append_text(flavor_text_during_unlock)
		_trophy_description.append_text(flavor_text_after_unlock)
